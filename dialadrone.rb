require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'httparty'

flipCount = 0

def perform(action)
  puts action
  begin
    HTTParty.get("http://127.0.0.1:5001/#{action}")
  rescue Exception
    puts "Request for #{action} failed"
  end
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
