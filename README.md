# RestfulApiAuthentication

RestfulApiAuthentication is a gem which implements a standard api_key/secret authentication system for your Ruby on Rails RESTful web services.

With most RESTful Web API's, it is important to know which app is using your resources and that only the apps you allow access those resources. This gem allows you to easily add this layer of authentication to any Rails RESTful resource you want, and it even includes protection against various forms of attack.

Go here to read a more lengthy description of the problem this gem is attempting to solve: [Authentication of a Ruby on Rails RESTful Web API / Service](http://www.djkiger.com/?p=41)

## Requirements

1. Rails 3.2.0+
2. ActiveRecord database (sqlite, MySQL, etc.)

## Dependencies

1. Rails 3.2.0+
2. UUID Gem 2.3.5+
3. Chronic Gem 0.6.7+

## Installation

Add this line to your application's Gemfile:

    gem 'restful_api_authentication'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restful_api_authentication

Run Rails generator:

    $ rails g restful_api_authentication:install

Run the migration task:

    $ rake db:migrate

Update the configuration (if you like) by editing the `config/restful_api_authentication.yml` file.

## Usage

### How It Works From A Client's Perspective

Before anyone can use a resource which is protected using this gem, that person/app must have a valid API key and secret. These are generated and stored as a RestClient model in your app. The easiest way to generate this is to use the Rails console:

```ruby
new_app = RestClient.create(:name => "My New App", :description => "This is my new application that will access my RESTful API.")
new_app.api_key
new_app.secret
```

In order to authenticate with your web service, the new application must include the following HTTP headers with each request:
* x-timestamp
* x-api-key
* x-signature

The x-timestamp should be the date and time the request is sent. It should be in UTC time and be formatted as "YYYY-MM-DD HH:MM:SS UTC". For example: `2012-03-31 15:37:32 UTC`

The x-api-key should be the same as the API key generated above. It should look something like `0f0721f0-5cc9-012f-c884-68a86d3dfd0`.

The x-signature is generated by concatenating the secret generated above, the API request URL, and the x-timestamp into a single string and then using the SHA256 hash algorithm to generate a hash of this string. The x-signature is this hash.

Here is an example in Ruby code using the HTTParty gem:

```ruby
require 'httparty'
require 'digest/sha2'

class MyTestApi
  include HTTParty

  API_KEY = "e4a80df0-5cca-012f-c884-68a86d3dfd02"
  SECRET = "473287f8298dba7163a897908958f7c0eae733e25d2e027992ea2edc9bed2fa8"
  
  def auth_headers(request_uri)
    timestamp = Time.now.utc.strftime "%Y-%m-%d %H:%M:%S UTC"
    signature_string = SECRET + request_uri + timestamp
    digest = Digest::SHA256.new << signature_string
    signature = digest.to_s
    { "x-api-key" => API_KEY, "x-timestamp" => timestamp, "x-signature" => signature }
  end
  
  def authenticate_test
    request_uri = "https://api.mywebservice.com/help/authenticate"
    self.class.post(request_uri, { :headers => auth_headers(request_uri) })
  end

end

api = MyTestApi.new
result = api.authenticate_test
puts result.inspect
```

### Configuration

In the `config/restful_api_authentication.yml` file you will find several things that you can change. The defaults are usually fine for most cases.

#### Verbose Error Messages (>= 0.2.0)

By default, the standard response to any authentication error is "not authorized". However, more meaningful explanations of why authentication is failing can be sent by adding the following to the `config/restful_api_authentication.yml` file:

```
verbose_errors: true
```

### Requiring Authentication

To require authentication for a specific resource (controller) of your RESTful web service, add this at the top of your controller just under where you open the controller class:

```ruby
include RestfulApiAuthentication
respond_to :json, :xml
before_filter :authenticated?
```

If you want to protect your entire web service, add those same lines to your ApplicationController class.

If the headers are not provided or the application fails to authenticate, your web service will deliver a 401 Unauthorized response.

### Master Authentication

Some web services might require an extra bit of security (creating new RestClients or managing User records). In these cases, you can require "master" authorization. Then, any RestClient with the is_master attribute set to true can use the resources but the others cannot.

Assuming you have authentication setup in your application controller, in the controller that requires master authentication:

```ruby
skip_before_filter :authenticated?
before_filter :authenticated_master?
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
