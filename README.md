# Dial-a-Drone

Control the Parrot Minidrone Rolling Spider over a phone call.

## Install

```
$ git clone git@github.com:adambutler/dial-a-drone.git
$ cd dial-a-drone
$ npm install
$ cp .env.example .env
```

## Usage

Point twilio to wherever you run the ruby server, by default this is on port 4567.

You can use [ngrok](https://ngrok.com/) to point to your local system.

```
$ coffee drone.coffee
$ ruby dialadrone.rb
```

Dial your number and control the drone with the following commands -

| Key | Action     |
| --- | ---------- |
| 1   | Take off   |
| 9   | Land       |
| 2   | Forward    |
| 8   | Backwards  |
| 4   | Tilt left  |
| 6   | Tilt right |
| 5   | Flip       |

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)
