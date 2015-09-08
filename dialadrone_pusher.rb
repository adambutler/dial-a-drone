require 'pusher'
require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'dotenv'

Dotenv.load

flipCount = 0

Pusher.url = "https://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/#{ENV['PUSHER_APP_ID']}"

puts "https://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/#{ENV['PUSHER_APP_ID']}"

def perform(action)
  puts action
  Pusher['action'].trigger(action, {})
end

post '/' do
  Twilio::TwiML::Response.new do |r|
    r.Gather :numDigits => '1', :action => '/action', :method => 'post', :timeout => 60 do |g|
      flipCount = 0
      g.Say 'Thanks for calling Dial-a-drone. Now lets fuck this place up. On your command Sir.', voice: "man"
    end
  end.text
end

post '/action' do
  puts "#{params["Digits"]} was pressed"

  case params["Digits"]
  when "2"
    perform('forward')
  when "4"
    perform('left')
  when "6"
    perform('right')
  when "8"
    perform('backward')
  when "1"
    perform('takeoff')
  when "9"
    perform('land')
  when "5"
    perform('flip')
  when "5"
    perform('up')
  when "7"
    perform('down')
  end

  Twilio::TwiML::Response.new do |r|
    r.Gather :numDigits => '1', :action => '/action', :method => 'post', :timeout => 60 do |g|
      unless ["1", "9", "5"].include? params["Digits"]
        g.Say "On the move. Watch those pretty faces folks."
      end

      if params["Digits"] == "5"
        if flipCount < 2
          g.Say 'That was bad ass!'
        else
          g.Say "Ok. Stop it! I'm dizzy"
        end
        flipCount = flipCount + 1
      end
    end
  end.text
end
