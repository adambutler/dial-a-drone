RollingSpider = require('rolling-spider')
drone = new RollingSpider

express = require "express"
app = express()

fakeMode = false

droneOptions = {
  speed: 50
  steps: 20
}

app.get '/takeoff', (req, res) ->
  drone.takeOff() unless fakeMode
  console.log "drone.takeOff()"
  res.send 'OK!'

app.get '/left', (req, res) ->
  drone.left(droneOptions) unless fakeMode
  console.log "drone.left()"
  res.send 'OK!'

app.get '/right', (req, res) ->
  drone.right(droneOptions) unless fakeMode
  console.log "drone.right()"
  res.send 'OK!'

app.get '/backward', (req, res) ->
  drone.backward(droneOptions) unless fakeMode
  console.log "drone.backward()"
  res.send 'OK!'

app.get '/forward', (req, res) ->
  drone.forward(droneOptions) unless fakeMode
  console.log "drone.forward()"
  res.send 'OK!'

app.get '/land', (req, res) ->
  drone.land() unless fakeMode
  console.log "drone.land()"
  res.send 'OK!'

app.get '/flip', (req, res) ->
  drone.frontFlip() unless fakeMode
  console.log "drone.frontFlip()"
  res.send 'OK!'

app.get '/up', (req, res) ->
  drone.up() unless fakeMode
  console.log "drone.up()"
  res.send 'OK!'

app.get '/down', (req, res) ->
  drone.down() unless fakeMode
  console.log "drone.down()"
  res.send 'OK!'

if fakeMode
  app.listen 5001
else
  drone.connect ->
    console.log 'Connected'
    drone.setup ->
      console.log 'Ready'
      drone.startPing()
      app.listen 5001

process.on 'exit', (code) ->
  drone.disconnect()
