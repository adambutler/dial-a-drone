# Dial-a-Drone

Control the Parrot Minidrone Rolling Spider with SMS & a phone call.

## Install

```
$ git clone git@github.com:adambutler/dial-a-drone.git
$ cd dial-a-drone
$ npm install
$ cp .env.example .env
```

## Usage

1. Create a Nexmo app and point the webhooks to your app.

```
$ nexmo app:create dial-a-drone <HOSTNAME>/answer <HOSTNAME>/event --type=voice --keyfile=private.key
```

2. Change the variables in `.env`

3. Run the app

    ```
    $ npm start
    ```

4. Dial your Nexmo number.


> Note: You can use [ngrok](https://ngrok.com/) to point to your local system.

Dial your number and control the drone with the following commands -

| Action     | Key | SMS Message |
| ---------- | --- | ----------- |
| Take off   | 1   | `takeoff`   |
| Land       | 9   | `land`      |
| Forward    | 2   | `forward`   |
| Backwards  | 8   | `back`      |
| Tilt left  | 4   | `left`      |
| Tilt right | 6   | `right`     |
| Flip       | 5   | `flip`      |

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)
