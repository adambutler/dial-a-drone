require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'httparty'

post '/' do
  Twilio::TwiML::Response.new do |r|
    r.Gather :numDigits => '1', :action => '/action', :method => 'post' do |g|
      g.Say 'Ready'
    end
  end.text
end

post '/action' do
  puts "#{params["Digits"]} was pressed"

  case params["Digits"]
  when "2"
    puts "Go forward"
    HTTParty.get('http://127.0.0.1:5001/forward')
  when "4"
    puts "Go left"
    HTTParty.get('http://127.0.0.1:5001/left')
  when "6"
    puts "Go right"
    HTTParty.get('http://127.0.0.1:5001/right')
  when "8"
    puts "Go back"
    HTTParty.get('http://127.0.0.1:5001/back')
  when "1"
    puts "Take off"
    HTTParty.get('http://127.0.0.1:5001/takeoff')
  when "9"
    puts "Land"
    HTTParty.get('http://127.0.0.1:5001/land')
  when "5"
    puts "Go flip"
    HTTParty.get('http://127.0.0.1:5001/flip')
  end

  Twilio::TwiML::Response.new do |r|
    r.Gather :numDigits => '1', :action => '/action', :method => 'post' do |g|
      g.Say 'That was bad ass!' if params["Digits"] == "5"
    end
  end.text
end
