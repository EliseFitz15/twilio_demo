# If running puma we need this per https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#timeout
Rack::Timeout.service_timeout = 20
