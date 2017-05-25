class HelpController < ApplicationController
  skip_before_action :authenticated?, only: [:master_authentication]
  before_action :authenticated_master?, only: [:master_authentication]

  def authentication
    render(json: { auth: ['authorized'] }, status: :ok)
  end

  def master_authentication
    render(json: { auth: ['authorized'] }, status: :ok)
  end
end
