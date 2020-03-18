# Download the twilio-ruby library from twilio.com/docs/libraries/ruby
require 'twilio-ruby'

account_sid = 'AC06bfa68be32002bbdd18f000420f1dc2'
auth_token = '3cb010572db20076682f5d4bf128ef00'
client = Twilio::REST::Client.new(account_sid, auth_token)

 from = '+12244123472'
 to = '+13129730053'

client.messages.create(
from: from,
to: to,
body: "Welcome to Rotations.io!"
)