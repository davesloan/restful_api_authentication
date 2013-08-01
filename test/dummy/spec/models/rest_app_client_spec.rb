require 'spec_helper'

describe RestAppClient do

  it "should be able to generate a new api key upon request" do
    rest_app_client = RestAppClient.new
    rest_app_client.gen_api_key
    rest_app_client.api_key.should_not be_nil
  end

  it "should be able to generate a new secret upon request" do
    rest_app_client = RestAppClient.new
    rest_app_client.gen_secret
    rest_app_client.secret.should_not be_nil
  end

  it "should save a valid client" do
    RestAppClient.should have(0).records
    rest_app_client = FactoryGirl.build :rest_app_client
    rest_app_client.save
    RestAppClient.should have(1).record
  end
  
  it "should not allow an empty name on create" do
    rest_app_client = FactoryGirl.build :rest_app_client
    rest_app_client.name = nil
    rest_app_client.should_not be_valid
  end
  
  it "should not allow an empty description on create" do
    rest_app_client = FactoryGirl.build :rest_app_client
    rest_app_client.description = nil
    rest_app_client.should_not be_valid
  end
  
  it "should enforce unique api keys" do
    rest_app_client1 = FactoryGirl.build :rest_app_client
    rest_app_client1.save
    rest_app_client2 = FactoryGirl.build :rest_app_client
    rest_app_client2.should_not be_valid
  end
  
  it "should set is_master to false if not explicitly set" do
    rest_app_client = RestAppClient.new(:name => "Test", :description => "Test")
    rest_app_client.should be_valid
    rest_app_client.is_master.should == false
  end
  
end
