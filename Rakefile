# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'rollbar/rake_tasks'

task :environment do
  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_SERVER_ACCESS_TOKEN']
  end
end

task brakeman: :environment do
  output = `brakeman --rails5 --no-pager --except CheckPermitAttributes `
  puts output
end

unless Rails.env.production?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new do |task|
    task.options = %w[--format simple]
  end

  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new

  tasks = %i[spec rubocop scss_lint brakeman]
  task(:default).clear.enhance(tasks)
end

Rails.application.load_tasks
