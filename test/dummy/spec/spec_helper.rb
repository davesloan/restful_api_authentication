require 'factory_girl'
require 'database_cleaner'
require 'simplecov'
require File.expand_path('../../config/environment', __FILE__)

SimpleCov.start 'rails'

RSpec.configure do |config|
  config.order = :random
  config.include FactoryGirl::Syntax::Methods
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
