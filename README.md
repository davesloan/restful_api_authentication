# RestfulApiAuthentication

RestfulApiAuthentication is a gem which implements a standard api_key/secret authentication system for your Ruby on Rails RESTful web services.

With most RESTful Web API's, it is important to know which app is using your resources and that only the apps you allow access those resources. This gem allows you to easily add this layer of authentication to any Rails RESTful resource you want, and it even includes protection against various forms of attack.

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
