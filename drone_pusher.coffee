RollingSpider = require('rolling-spider')
Pusher = require('pusher-client')
env = require('node-env-file')

drone = new RollingSpider

fakeMode = true

droneOptions = {
  speed: 50
  steps: 20
}

try
  env "#{__dirname}/.env"
catch error
  console.log error

pusherOptions = {
  appId: process.env.PUSHER_APP_ID
  key: process.env.PUSHER_KEY
  secret: process.env.PUSHER_SECRET
}

console.log pusherOptions

pusher = new Pusher(process.env.PUSHER_KEY)

channel = pusher.subscribe('action')
channel.bind 'new-price', (data) ->

channel.bind 'takeoff', (data) ->
  drone.takeOff() unless fakeMode
  console.log "drone.takeOff()"

channel.bind 'left', (data) ->
  drone.left(droneOptions) unless fakeMode
  console.log "drone.left()"

channel.bind 'right', (data) ->
  drone.right(droneOptions) unless fakeMode
  console.log "drone.right()"

channel.bind 'backward', (data) ->
  drone.backward(droneOptions) unless fakeMode
  console.log "drone.backward()"

channel.bind 'forward', (data) ->
  drone.forward(droneOptions) unless fakeMode
  console.log "drone.forward()"

channel.bind 'land', (data) ->
  drone.land() unless fakeMode
  console.log "drone.land()"

channel.bind 'flip', (data) ->
  drone.frontFlip() unless fakeMode
  console.log "drone.frontFlip()"

channel.bind 'up', (data) ->
  drone.up() unless fakeMode
  console.log "drone.up()"

channel.bind 'down', (data) ->
  drone.down() unless fakeMode
  console.log "drone.down()"

unless fakeMode
  drone.connect ->
    console.log 'Connected'
    drone.setup ->
      console.log 'Ready'
      drone.startPing()

process.on 'exit', (code) ->
  drone.disconnect()
