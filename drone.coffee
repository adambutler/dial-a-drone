Drone  = require "rolling-spider"
express = require "express"
env    = require "node-env-file"
app = express()

try
  env "#{__dirname}/.env"
catch error
  console.log error

drone = new Drone(process.env.UUID)

fakeMode = false

app.get '/takeoff', (req, res) ->
  drone.takeOff() unless fakeMode
  console.log "drone.takeOff()"
  res.send 'OK!'

app.get '/left', (req, res) ->
  drone.tiltLeft() unless fakeMode
  console.log "drone.tiltLeft()"
  res.send 'OK!'

app.get '/right', (req, res) ->
  drone.tiltRight() unless fakeMode
  console.log "drone.tiltRight()"
  res.send 'OK!'

app.get '/back', (req, res) ->
  drone.back() unless fakeMode
  console.log "drone.back()"
  res.send 'OK!'

app.get '/forward', (req, res) ->
  drone.front() unless fakeMode
  console.log "drone.front()"
  res.send 'OK!'

app.get '/land', (req, res) ->
  drone.land() unless fakeMode
  console.log "drone.land()"
  res.send 'OK!'

app.get '/flip', (req, res) ->
  drone.frontFlip() unless fakeMode
  console.log "drone.frontFlip()"
  res.send 'OK!'

if fakeMode
  app.listen 5001
else
  drone.connect ->
    console.log 'Connected'
    drone.setup ->
      console.log 'setup'
      drone.startPing()
      app.listen 5001
