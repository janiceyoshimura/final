# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################
require "geocoder"
require "rubygems"


account_sid = ENV["TWILIO_ACCOUNT_SID"]
auth_token = ENV["TWILIO_AUTH_TOKEN"]

client = Twilio::REST::Client.new(account_sid, auth_token)

rotations_table = DB.from(:rotations)
interests_table = DB.from(:interests)
comments_table = DB.from(:comments)
users_table = DB.from(:users)

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

# homepage and list of rotations (aka "index")
get "/" do
    puts "params: #{params}"

    @rotations = rotations_table.all.to_a
    pp @rotations
    @interests = interests_table.where(user_id: session["user_id"]).to_a
    pp @interests

    # this stuff is broken - need to show the join of the rotations table and the interests table
    # interest = @interests[:interested] == 1
    # @interested_rotations = rotations_table.where(id: interest[:rotation_id])

    view "rotations"
end

# rotations details (aka "show")
get "/rotations/:id" do
    puts "params: #{params}"

    @users_table = users_table
    @rotation = rotations_table.where(id: params[:id]).to_a[0]
    pp @rotation
    @interests = interests_table.where(user_id: session["user_id"]).to_a
   
    view "rotation"
end

# display the interest form (aka "new")
get "/rotations/:id/interest/new" do
    puts "params: #{params}"

    @rotation = rotations_table.where(id: params[:id]).to_a[0]
    view "new_interest"
end

# receive the submitted interest (aka "create")
post "/rotations/:id/interests/create" do
    puts "params: #{params}"

    # first find the rotation that you are adding an interest for
    @rotation = rotations_table.where(id: params[:id]).to_a[0]
    # next we want to insert a row in the interests table with the interest form data
    interests_table.insert(
        rotation_id: @rotation[:id],
        user_id: session["user_id"],
        interested: 1,
    )
    redirect "/rotations/#{@rotation[:id]}"
end

# display the signup form (aka "new")
get "/users/new" do
    view "new_user"
end

# receive the submitted signup form (aka "create")
post "/users/create" do
    puts "params: #{params}"

    # if there's already a user with this email, skip
    existing_user = users_table.where(email: params["email"]).to_a[0]
    if existing_user
        view "error"
    else
        users_table.insert(
            first_name: params["first_name"],
            last_name: params["last_name"],
            email: params["email"],
            phone: params["phone"],
            password: BCrypt::Password.create(params["password"])
        )

        from = '+12244123472'
        to = params["phone"]

        client.messages.create(
        from: from,
        to: to,
        body: "Welcome to Rotations.io! Use the same email and password to login and start checking out rotations"
        )

        redirect "/logins/new"
    end
end

# display the login form (aka "new")
get "/logins/new" do
    view "new_login"
end

# receive the submitted login form (aka "create")
post "/logins/create" do
    puts "params: #{params}"

    # step 1: user with the params["email"] ?
    @user = users_table.where(email: params["email"]).to_a[0]

    if @user
        # step 2: if @user, does the encrypted password match?
        if BCrypt::Password.new(@user[:password]) == params["password"]
            # set encrypted cookie for logged in user
            session["user_id"] = @user[:id]
            redirect "/"
        else
            view "create_failed_login"
        end
    else
        view "create_failed_login"
    end
end

# logout user
get "/logout" do
    # remove encrypted cookie for logged out user
    session["user_id"] = nil
    redirect "/logins/new"
end



