import RollingSpider from 'rolling-spider'
import express from 'express'
import bodyParser from 'body-parser'
import env from 'node-env-file'

// Load the env file
try {
  env(`${__dirname}/.env`)
} catch (error) {
  console.log(error)
}

const drone = new RollingSpider({ uuid: process.env.DRONE_UUID })
const app = express()
app.use(bodyParser.json())

let flipCount = 0
let moveCount = 0

const perform = (action, callback) => {
  return new Promise((resolve, reject) => {
    switch (action.toLowerCase()) {
      case '2':
      case 'forward':
        drone.forward({ steps: 25 })
        moveCount++
        resolve({ action: 'forward', type: 'move', description: 'Going forward' })
        break
      case '6':
      case 'right':
        drone.right({ steps: 25 })
        moveCount++
        resolve({ action: 'right', type: 'move', description: 'Going right' })
        break
      case '8':
      case 'back':
        drone.backward({ steps: 25 })
        moveCount++
        resolve({ action: 'back', type: 'move', description: 'Going back' })
        break
      case '4':
      case 'left':
        drone.left({ steps: 25 })
        moveCount++
        resolve({ action: 'left', type: 'move', description: 'Going left' })
        break
      case '1':
      case 'takeoff':
        drone.takeoff()
        resolve({ action: 'takeoff', type: 'takeoff', description: 'Taking off' })
        break
      case '9':
      case 'land':
        drone.land()
        moveCount = 0
        resolve({ action: 'land', type: 'land', description: 'Landing' })
        break
      case '5':
      case 'flip':
        drone.frontFlip()
        flipCount++
        resolve({ action: 'flip', type: 'flip', description: 'Flipping' })
        break
      default:
        return reject(`Got "${action}" but instruction was not understood.`)
    }
  })
}

app.post('/sms', (req, res) => {
  perform(req.body.text)
  .then((action) => {
    console.log(action);
    res.sendStatus(200)
  })
  .catch((error) => {
    console.log(error);
    res.sendStatus(200)
  })
})

app.get('/answer', (req, res) => {
  res.json([
    {
      action: "talk",
      voiceName: "Brian",
      text: "Welcome to dial-a-drone. Now let's fuck this place up."
    },
    {
      action: "input",
      maxDigits: 1,
      eventUrl: [`${process.env.HOSTNAME}/dtmf`],
      timeOut: 30,
    }
  ])
})

app.post('/dtmf', (req, res) => {
  let responsePayload = [
    {
      action: "input",
      maxDigits: 1,
      eventUrl: [`${process.env.HOSTNAME}/dtmf`],
      timeOut: 30,
    }
  ]

  perform(req.body.dtmf)
  .then((action) => {
    console.log(action);

    switch (action.type) {
      case 'move':
        if (moveCount == 1) {
          responsePayload.unshift({
            action: "talk",
            voiceName: "Brian",
            text: "On the move. Watch those pretty faces folks."
          })
        }
        break;
      case 'flip':
        if (flipCount == 1) {
          responsePayload.unshift({
            action: "talk",
            voiceName: "Brian",
            text: "That was badass"
          })
        } else if (flipCount == 2) {
          responsePayload.unshift({
            action: "talk",
            voiceName: "Brian",
            text: "Ok stop it. I'm dizzy."
          })
        }
        break;
    }

    res.json(responsePayload)
  })
  .catch((error) => {
    console.log(error);
    responsePayload.unshift({
      action: "talk",
      voiceName: "Brian",
      text: "Sorry I didn't understand that. Try again."
    })

    res.json(responsePayload)
  })
})

drone.connect(() => {
  console.log('connected');
  drone.setup(() => {
    console.log('setup');
    drone.startPing();

    app.listen(3000, () => {
      console.log('Dial-a-Drone listening on port 3000!')
    })
  });
});
