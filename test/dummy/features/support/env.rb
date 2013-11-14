# needed for SimpleCov to include cucumber tests in it's coverage report
require 'simplecov'
SimpleCov.start 'rails'

# include cucumber
require 'cucumber/rails'

# default selector
Capybara.default_selector = :css

# don't allow a rescue so exceptions fail tests
ActionController::Base.allow_rescue = false

# for faster cleanup with javascript
Cucumber::Rails::Database.javascript_strategy = :truncation

# for easier JSON testing
require 'json_spec/cucumber'

def last_json
  last_response.body
end

# includes some useful steps for working with factories
require "factory_girl"
require "factory_girl_rails"
