class ApplicationController < ActionController::Base
  include RestfulApiAuthentication
  respond_to :json, :xml
  before_filter :set_default_format, :authenticated?
  
  def set_default_format
    request.format = :json unless request.format.xml?
  end
  
end
