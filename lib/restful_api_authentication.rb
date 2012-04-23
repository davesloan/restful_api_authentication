# encoding: utf-8

# Copyright (c) 2012 David Kiger
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'digest'
require 'chronic'
require 'rails'
require File.expand_path('../restful_api_authentication/version.rb', __FILE__)
require File.expand_path('../restful_api_authentication/checker.rb', __FILE__)
require File.expand_path('../restful_api_authentication/railtie.rb', __FILE__)

module RestfulApiAuthentication

  # before filter to ensure the request has valid client authentication headers
  # returns a 401 not authorized if the authentication headers are missing or invalid
  def authenticated?
    checker = RestfulApiAuthentication::Checker.new(request.headers, request.fullpath)
    if checker.authorized?
      return true
    else
      respond_with(["not authorized"], :status => 401, :location => nil)
    end
  end

  # before filter to ensure the request has valid client authentication headers
  # client must have is_master flag set to true to pass authentication
  # returns a 401 not authorized if the authentication headers are missing or invalid
  def authenticated_master?
    checker = RestfulApiAuthentication::Checker.new(request.headers, request.fullpath, :require_master => true)
    if checker.authorized?
      return true
    else
      respond_with(["not authorized"], :status => 401, :location => nil)
    end
  end

end