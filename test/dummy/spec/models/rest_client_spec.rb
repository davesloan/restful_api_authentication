require 'spec_helper'

describe RestClient, models: true do
  it 'should be able to generate a new api key upon request' do
    rest_client = RestClient.new
    rest_client.gen_api_key
    expect(rest_client.api_key).to_not eq(nil)
  end

  it 'should be able to generate a new secret upon request' do
    rest_client = RestClient.new
    rest_client.gen_secret
    expect(rest_client.secret).to_not eq(nil)
  end

  it 'should save a valid client' do
    expect(RestClient.count).to eq(0)
    rest_client = FactoryGirl.build :rest_client
    rest_client.save
    expect(RestClient.count).to eq(1)
  end

  it 'should not allow an empty name on create' do
    rest_client = FactoryGirl.build :rest_client
    rest_client.name = nil
    expect(rest_client.valid?).to eq(false)
  end

  it 'should not allow an empty description on create' do
    rest_client = FactoryGirl.build :rest_client
    rest_client.description = nil
    expect(rest_client.valid?).to eq(false)
  end

  it 'should enforce unique api keys' do
    rest_client1 = FactoryGirl.build :rest_client
    rest_client1.save
    rest_client2 = FactoryGirl.build :rest_client
    expect(rest_client2.valid?).to eq(false)
  end

  it 'should set is_master to false if not explicitly set' do
    rest_client = RestClient.new(name: 'Test', description: 'Test')
    expect(rest_client.valid?).to eq(true)
    expect(rest_client.is_master).to eq(false)
  end

  it 'should set is_disabled to false if not explicitly set' do
    rest_client = RestClient.new(name: 'Test', description: 'Test')
    expect(rest_client.valid?).to eq(true)
    expect(rest_client.is_disabled).to eq(false)
  end
end
