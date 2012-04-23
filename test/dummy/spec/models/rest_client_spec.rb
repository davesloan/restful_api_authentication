require 'spec_helper'

describe RestClient do

  it "should be able to generate a new api key upon request" do
    rest_client = RestClient.new
    rest_client.gen_api_key
    rest_client.api_key.should_not be_nil
  end

  it "should be able to generate a new secret upon request" do
    rest_client = RestClient.new
    rest_client.gen_secret
    rest_client.secret.should_not be_nil
  end

  it "should save a valid client" do
    RestClient.should have(0).records
    rest_client = FactoryGirl.build :rest_client
    rest_client.save
    RestClient.should have(1).record
  end
  
  it "should not allow an empty name on create" do
    rest_client = FactoryGirl.build :rest_client
    rest_client.name = nil
    rest_client.should_not be_valid
  end
  
  it "should not allow an empty description on create" do
    rest_client = FactoryGirl.build :rest_client
    rest_client.description = nil
    rest_client.should_not be_valid
  end
  
  it "should enforce unique api keys" do
    rest_client1 = FactoryGirl.build :rest_client
    rest_client1.save
    rest_client2 = FactoryGirl.build :rest_client
    rest_client2.should_not be_valid
  end
  
  it "should set is_master to false if not explicitly set" do
    rest_client = RestClient.new(:name => "Test", :description => "Test")
    rest_client.should be_valid
    rest_client.is_master.should == false
  end
  
end
