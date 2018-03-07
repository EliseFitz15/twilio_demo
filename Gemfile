source 'https://rubygems.org'
ruby '2.4.0'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'administrate', '0.8.1'
gem 'bootstrap', '4.0.0.beta2.1'
gem 'devise', '4.3.0'
gem 'doorkeeper', '4.2.6'
gem 'grape', '1.0.1'
gem 'grape-active_model_serializers', '1.5.1'
gem 'grape-swagger', '0.27.3'
gem 'grape-swagger-entity', '0.2.3'
gem 'grape-swagger-rails', '~> 0.3.0'
gem 'grape-swagger-representable', '0.1.5'
gem 'haml-rails', '1.0.0'
gem 'jbuilder', '2.7.0'
gem 'jquery-rails', '4.3.1'
gem 'newrelic_rpm', '4.6.0.338'
gem 'oj', '3.3.9' # needed by rollbar
gem 'pg', '0.21.0'
gem 'puma', '3.11.0'
gem 'pundit', '1.1'
gem 'rack-cors', '1.0.2'
gem 'rack-timeout', '0.4.2'
gem 'rails', '5.1.4'
gem 'rollbar', '2.15.5'
gem 'sass-rails', '5.0.7'
gem 'turbolinks', '5.0.1'
gem 'twilio-ruby', '5.6.0'
gem 'uglifier', '4.0.2'

group :development, :test do
  gem 'brakeman', '4.1', require: false

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '2.16.1'
  gem 'dotenv-rails', '2.2.1'
  gem 'factory_bot_rails', '4.8.2'
  gem 'pry-rails', '0.3.6'
  gem 'pundit-matchers', '1.4.1'
  gem 'rspec-rails', '3.7.2'
  gem 'rubocop', '~> 0.52.0'
  gem 'rubocop-rspec', '1.21.0'
  gem 'scss_lint', '0.56.0', require: false
  gem 'selenium-webdriver', '3.8'
  gem 'shoulda-matchers', '3.1.2'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'grape_on_rails_routes', '~> 0.3.2'
  gem 'listen', '3.1.5'
  gem 'web-console', '3.5.1'
end
