# -*- encoding: utf-8 -*-

require File.expand_path('../lib/restful_api_authentication/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.required_rubygems_version = Gem::Requirement.new('>= 0') if gem.respond_to? :required_rubygems_version=
  gem.authors       = ['Dave Kiger']
  gem.email         = ['davejkiger@gmail.com']
  gem.description   = 'A gem which implements a standard api_key / secret authentication system for your Ruby on Rails RESTful web services.'
  gem.summary       = "With most RESTful Web API's, it is important to know which app is using your resources and that only the apps you allow access those resources. This gem allows you to easily add this layer of authentication to any Rails RESTful resource you want, and it even includes protection against various forms of attack."
  gem.homepage      = 'http://davejkiger.github.com/restful_api_authentication/'

  # gem.files         = `git ls-files`.split($\)
  gem.files         = Dir.glob('{bin,lib}/**/*') + %w[CHANGELOG.md Gemfile LICENSE Rakefile README.md restful_api_authentication.gemspec]
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'restful_api_authentication'
  gem.require_paths = ['lib']
  gem.version       = RestfulApiAuthentication::VERSION

  gem.add_runtime_dependency('rails', ['>= 5.1.0'])
  gem.add_runtime_dependency('uuid', ['>= 2.3.8'])
  gem.add_runtime_dependency('chronic', ['>= 0.10.2'])
end
