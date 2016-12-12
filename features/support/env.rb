ENV['RAILS_ENV'] = 'test'
require './config/environment'
require 'minitest/spec'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'poltergeist/suppressor'
require 'mocha/mini_test'
require 'minitest/rg'

ActionDispatch::IntegrationTest.extend Minitest::Spec::DSL
DatabaseCleaner.strategy = :truncation

# database setup
Spinach.hooks.before_scenario do
  DatabaseCleaner.clean
end
Spinach.hooks.before_step do
  I18n.locale = :en
end

# javascript setup
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: false})
end
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 30

Spinach.hooks.on_tag('javascript') do
  ::Capybara.current_driver = ::Capybara.javascript_driver
end
