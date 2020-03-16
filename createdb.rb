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
DB.create_table! :comments do
  primary_key :id
  foreign_key :rotation_id
  String :first_name
  String :email
  String :comment_detail, text: true
end

DB.create_table! :interests do
  primary_key :id
  foreign_key :user_id
  Boolean :interested
end

DB.create_table! :users do
  primary_key :id
  String :first_name
  String :last_name
  String :email
  String :password
end

# Insert initial (seed) data
rotations_table = DB.from(:rotations)

rotations_table.insert(company: "Allbirds", 
                    address: "730 Montgomery St, San Francisco, CA 94111",
                    city: "San Francisco, CA",
                    function: "Operations",
                    function_description: "Kellogg Global Hub",
                    length: "6 months")

rotations_table.insert(company: "McDonalds", 
                    address: "1035 W Randolph St, Chicago, IL 60607",
                    city: "Chicago, IL",
                    function: "Global Strategy",
                    function_description: "Kellogg Global Hub",
                    length: "12 months")

rotations_table.insert(company: "Estee Lauder", 
                    address: "767 Fifth Avenue New York, NY 10153",
                    city: "New York, NY",
                    function: "Merchandising",
                    function_description: "Kellogg Global Hub",
                    length: "8 months")

rotations_table.insert(company: "Amazon", 
                    address: "410 Terry Ave N, Seattle, WA 98109",
                    city: "Seattle, WA",
                    function: "Logistics",
                    function_description: "Kellogg Global Hub",
                    length: "6 months")

