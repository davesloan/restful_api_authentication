# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rake'
require 'json_spec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Rails.application.load_tasks

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.infer_spec_type_from_file_location!
  config.include RequestHelper::JsonHelpers, type: :request
  config.include RequestHelper::HeaderHelpers, type: :request
end
