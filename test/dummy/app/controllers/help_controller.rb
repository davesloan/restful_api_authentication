class HelpController < ApplicationController
  skip_before_filter :authenticated?, :only => [:master_authentication]
  before_filter :authenticated_master?, :only => [:master_authentication]
  def authentication
    respond_with(["authorized"], :status => 200, :location => nil)
  end
  
  def master_authentication
    respond_with(["authorized"], :status => 200, :location => nil)
  end
end
