class RestClient < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :api_key, presence: true, uniqueness: true
  validates :secret, presence: true

  # white list fields for mass assignment
  attr_accessor :name, :description

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
    gen_api_key if api_key.nil? || api_key == ''
    gen_secret if secret.nil? || secret == ''
    self.is_master = false if is_master.nil?
    self.is_disabled = false if is_disabled.nil?
    true
  end
end
