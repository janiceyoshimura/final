# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :rotations do
  primary_key :id
  String :company
  String :address
  String :city
  String :function
  String :function_description
  String :length
end

# DB.create_table! :comments do
#   primary_key :id
#   foreign_key :rotation_id
#   String :first_name
#   String :email
#   String :comment_detail, text: true
# end

DB.create_table! :interests do
  primary_key :id
  foreign_key :user_id
  foreign_key :rotation_id
  String :interested
  String :company
  String :function
  Boolean :follow_up
  Boolean :mark_interested
end

DB.create_table! :users do
  primary_key :id
  String :first_name
  String :last_name
  String :email
  Integer :phone
  String :password
end

# Insert initial (seed) data
rotations_table = DB.from(:rotations)

rotations_table.insert(company: "Allbirds", 
                    address: "730 Montgomery St, San Francisco, CA 94111",
                    city: "San Francisco, CA",
                    function: "Operations",
                    function_description: "Allbirds is in the process of building a world class Operations team to consistently surprise and delight our customers while making a positive impact on the world. As we continue to grow at a rapid pace, we are managing our supply chain efficiently from start to finish, and leveraging our operational capabilities to create competitive advantages.
                    The Operations team plays a critical role in ensuring this occurs. The team currently manages the strategy development and execution of sourcing, procurement, production, planning, transportation and warehousing, and customer support.
                    As we expand rapidly, the complexity of the products and the organization also increases. This role will help us manage this complexity by managing the Go-to-Market and new partner onboarding processes for the Operations team as well as a variety of other projects, ranging from hardware and software implementations (e.g. for inventory management) to strategic initiatives.",
                    length: "6 months")

rotations_table.insert(company: "McDonalds", 
                    address: "1035 W Randolph St, Chicago, IL 60607",
                    city: "Chicago, IL",
                    function: "Digital Strategy",
                    function_description: "This position owns and activates McDonald's global digital strategy on behalf of the Corporate Relations function. With an emphasis on how our narrative enhances reputation to ultimately accelerate business growth, the incumbent will be the digital and social media subject matter expert.",
                    length: "12 months")

rotations_table.insert(company: "Estee Lauder", 
                    address: "767 Fifth Avenue New York, NY 10153",
                    city: "New York, NY",
                    function: "Merchandising",
                    function_description: "The primary role of the Visual Merchandising Field Manager is to ensure all brands within the Estée Lauder portfolio maintain brand equity through exceptional visual merchandising at point of sale.",
                    length: "8 months")

rotations_table.insert(company: "Amazon", 
                    address: "410 Terry Ave N, Seattle, WA 98109",
                    city: "Seattle, WA",
                    function: "Logistics",
                    function_description: "Amazon’s transportation teams work to ensure the delivery packages globally for customers around the world. On its busiest day, Cyber Monday,Amazon customers around the world have ordered more than 400 items per second and the transportation teams play a critical role ensuring packages make it to customers’ doors on-time and in great condition.",
                    length: "6 months")

