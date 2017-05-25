class ApplicationController < ActionController::Base
  include RestfulApiAuthentication

  protect_from_forgery with: :exception

  before_action :authenticated?
end
