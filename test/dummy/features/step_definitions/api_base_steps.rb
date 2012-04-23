World(Rack::Test::Methods)

Given /^I am authenticated$/ do
  @rest_client = FactoryGirl.build(:rest_client)
  @rest_client.is_master = false
  header 'x-api-key', @rest_client.api_key
end

Given /^I have master permissions$/ do
  @rest_client.is_master = true
end

Given /^an? "([^"]*)" exists$/ do |factory_name|
  create_factory_object(factory_name)
end

# used to test authentication system
When /^I perform an authentication test with "([^"]*)"$/ do |payload_type|
  client = FactoryGirl.build(:rest_client)
  ts = Time.now.utc
  request_uri = '/help/authentication'
  if payload_type == "old authentication data"
    ts = Time.now.utc - 11.minutes
  elsif payload_type == "future authentication data"
    ts = Time.now.utc + 11.minutes
  elsif payload_type == "unknown api key data"
    client.api_key = '69704d90-4b77-012f-c334-68a86d3dfd00'
  elsif payload_type == "invalid secret data"
    client.secret = '1e5483d9c6ddbe2f26eecf444ec7a976b2836ab17a209a0940f4dfdee1b3bc99'
  elsif payload_type == "invalid request uri data"
    request_uri = '/clients/delete'
  end
  timestamp = ts.to_s
  str_to_hash = client.secret + request_uri + timestamp
  d = Digest::SHA256.new << str_to_hash
  signature = d.to_s
  add_headers({ "x-api-key" => client.api_key, "x-timestamp" => timestamp, "x-signature" => signature })
  url = "/help/authentication"
  get(url)
end

## Methods with parameters 
When /^I perform a ([^"]*) to "([^\"]*)" with an? "([^\"]*)" as ([^"]*)$/ do |method, path, factory_name, format|
  @rest_client.save unless @rest_client.nil?
  replace_attributes path, factory_name
  add_authentication_headers path
  params = nil
  case format
    when "JSON"
      header 'Accept', 'application/json'
      header 'Content-Type', 'application/json' 
      params = FactoryGirl.attributes_for(factory_name).to_json(:except => [:_id, :created_at, :updated_at ]) unless factory_name == ""
    when "XML"
      header 'Accept', 'application/xml'
      header 'Content-Type', 'application/xml' 
      params = FactoryGirl.build(factory_name).to_xml(:except => [:_id, :created_at, :updated_at ]) unless factory_name == ""
    when "HTTP"
      obj = FactoryGirl.build(factory_name).attributes.except([:_id, :created_at, :updated_at ]) unless factory_name == ""
      params = obj.to_query(FactoryGirl.build(factory_name).class.name.underscore) unless factory_name == ""
    else
      raise "Invalid format. Must be JSON, XML, or HTTP"
  end
  case method
    when "POST"
      post path, params
    else
      raise "Invalid method. Method must be POST"
  end
end

## Methods with parameters 
When /^I perform a GET to "([^\"]*)" as ([^"]*)$/ do |path, format|
  @rest_client.save unless @rest_client.nil?
  replace_attributes path, nil
  add_authentication_headers path
  params = nil
  case format
    when "JSON"
      header 'Accept', 'application/json'
      header 'Content-Type', 'application/json' 
    when "XML"
      header 'Accept', 'application/xml'
      header 'Content-Type', 'application/xml' 
    when "HTTP"
    else
      raise "Invalid format. Must be JSON, XML, or HTTP"
  end
  get path
end

## Post Methods with query string parameters
When /^I perform a POST to "([^\"]*)" $/ do |path|
  post path
end

# Http Response validation
Then /^the HTTP status code should be "([^\"]*)"$/ do |status|
  last_response.status.should == status.to_i
end

# Response validation

Then /^the response at index (\d+) of the ([^"]*) response data should be "([^"]*)"$/ do |index, format, response_text|
  if format == 'XML'
    response = Hash.from_xml(last_response.body)
    response["strings"][index.to_i].should == response_text
  elsif format == 'JSON'
    response = JSON.parse(last_response.body)
    response[index.to_i].should == response_text
  else
    raise "Invalid format. Must be JSON or XML."
  end
end

# JSON
Then /^the response JSON should have 1 "([^\"]*)" element$/ do |name|
  response = JSON.parse(last_response.body)
  response[name].should be
end

Then /^the response JSON should have (\d+) records?$/ do |index|
  response = JSON.parse(last_response.body)
  response.count.should == index.to_i
end

# XML
Then /^the response XML should have a root element of "([^\"]*)"$/ do |name|
  response = Hash.from_xml(last_response.body)
  response[name].should be
  @xml_root_element = name
end

Then /^the response XML should have (\d+) "([^\"]*)" records?$/ do |index, name|
  response = Hash.from_xml(last_response.body)
  response[name.pluralize].count.should == index.to_i
end

Then /^the response XML should have 1 "([^\"]*)" child element$/ do |name|
  response = Hash.from_xml(last_response.body)
  response[@xml_root_element][name].should be
end
