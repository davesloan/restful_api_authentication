class RestAppClient < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :description, :presence => true
  validates :api_key, :presence => true, :uniqueness => true
  validates :secret, :presence => true
  
  # white list fields for mass assignment
  attr_accessible :name, :description

  # set default values on save
  before_validation :set_defaults

  # generates a new API key
  def gen_api_key
    u = UUID.new
    self.api_key = u.generate
  end
  
  # generates a new secret
  def gen_secret
    u = UUID.new
    d = Digest::SHA256.new << u.generate
    self.secret = d.to_s
  end
  
  private
  
    def set_defaults
      self.gen_api_key if self.api_key.nil? || self.api_key == ""
      self.gen_secret if self.secret.nil? || self.secret == ""
      self.is_master = false if self.is_master.nil?
      return true
    end

end