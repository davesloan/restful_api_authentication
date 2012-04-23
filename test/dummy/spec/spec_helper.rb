# These lines are needed for SimpleCov to generate a complete coverage report
require 'simplecov'
SimpleCov.start 'rails'

# Sets Rails environment to test and includes rspec
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.mock_with :rspec # use rspec's built-in mock objects
  config.use_transactional_fixtures = true

  # keep our mongo DB all shiney and new between tests
  require 'database_cleaner'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
