class HelpController < ApplicationController
  def authentication
    respond_with(["authorized"], :status => 200, :location => nil)
  end
end
