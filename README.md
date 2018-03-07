# Project Atlas

### Set up
Standard rails set up, download, `bundle install` and `db:setup`.

In order to run rails system tests you'll need to first run: `brew install chromedriver`.

Save a local `.env` see the reference to the `.env.example`

### Actively Developing with Twilio

Install tool for tunneling to localhost via [ngrok](https://ngrok.com/)

To use it run `rails s` and then `./ngrok http 3000` to populate url that can be used for testing Twilio locally.

Then update the `config/environment/development.rb` file to have the tunnel being provided to Twilio.

```
# When developing with Twilio. To Test this replace local host with your ngrok tunnel host. ex. 25eee9c8.ngrok.io
url_options = { host: '25eee9c8.ngrok.io' }
```

Once you have a tunnel via ngrok, go into the [Messaging Service console](https://www.twilio.com/console/sms/services/) and update the following:
  - request url
  - status callback url

![twilio-screenshot](https://user-images.githubusercontent.com/10551597/34585363-5f5c856c-f16d-11e7-8b78-9099a5d63358.png)
