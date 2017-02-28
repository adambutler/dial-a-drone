# Dial-a-Drone

Control the Parrot Minidrone Rolling Spider with SMS & a phone call using [Nexmo](https://nexmo.com)

## Install

```sh
$ git clone git@github.com:adambutler/dial-a-drone.git
$ cd dial-a-drone
$ npm install
$ cp .env.example .env
```

## Prerequisites

1. Setup a [Nexmo account](https://dashboard.nexmo.com/sign-up)

2. Setup the [Nexmo CLI](https://github.com/Nexmo/nexmo-cli)

## Usage

1. Host this application or setup a local tunnel to your development machine.

> Note: We recommend you use [ngrok](https://ngrok.com/) to point to your local system.

2. Search for and buy a virtual number in your country with SMS support.

    ```sh
    $ nexmo numbers:search GB --sms
    $ nexmo number:buy <NUMBER>
    ```

3. Create a Nexmo app pointing the webhooks to your application & link the number

    ```sh
    $ nexmo app:create dial-a-drone <HOSTNAME>/answer <HOSTNAME>/event --type=voice --keyfile=private.key

    $ nexmo link:app <YOUR_NUMBER> <YOUR_APP_ID>
    ```

    ![dial-a-drone-number-2](https://cloud.githubusercontent.com/assets/1238468/23401629/4e25bc58-fda0-11e6-99b6-61e1d073a1ed.gif)


4. In your Nexmo account **Settings > API settings** change **HTTP Method** to **POST-JSON**.

    ![account-settings](https://cloud.githubusercontent.com/assets/1238468/23401614/40b78aba-fda0-11e6-8307-4b39571d8b7f.png)


5. Add the HOSTNAME to the `.env` file

6. Run the app

    ```sh
    $ npm start
    ```

7. Dial your Nexmo number.

## Controlling the Drone

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
