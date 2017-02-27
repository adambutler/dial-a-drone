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

const drone = new RollingSpider(process.env.UUID)
const app = express()
app.use(bodyParser.json())

const perform = (action, callback) => {
  return new Promise((resolve, reject) => {
    switch (action.toLowerCase()) {
      case '2':
      case 'forward':
        drone.front()
        resolve('Going forward')
        break
      case '6':
      case 'right':
        drone.right()
        resolve('Going right')
        break
      case '8':
      case 'back':
        drone.back()
        resolve('Going back')
        break
      case '4':
      case 'left':
        drone.left()
        resolve('Going left')
        break
      case '1':
      case 'takeoff':
        drone.takeoff()
        resolve('Taking off')
        break
      case '9':
      case 'land':
        drone.land()
        resolve('Landing')
        break
      case '5':
      case 'flip':
        drone.flip()
        resolve('Flipping')
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
      voiceName: "Emma",
      text: "Welcome to dial-a-drone."
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
    res.json(responsePayload)
  })
  .catch((error) => {
    console.log(error);
    responsePayload.unshift({
      action: "talk",
      voiceName: "Emma",
      text: "Sorry I didn't understand that. Try again."
    })

    res.json(responsePayload)
  })
})

app.listen(3000, () => {
  console.log('Dial-a-Drone listening on port 3000!')
})
