require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.logger = Rails.logger
Before do
  DatabaseCleaner.start
end

After do |scenario|
  DatabaseCleaner.clean
end