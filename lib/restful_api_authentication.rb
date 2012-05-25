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
require 'uuid'
require File.expand_path('../restful_api_authentication/version.rb', __FILE__)
require File.expand_path('../restful_api_authentication/checker.rb', __FILE__)
require File.expand_path('../restful_api_authentication/railtie.rb', __FILE__)

module RestfulApiAuthentication

  # This method should be used as a Rails before_filter in any controller in which one wants to ensure requests have valid client authentication headers.
  #
  # If the request is not authenticated, it will use the rails respond_with method to send a 401 Unauthorized response.
  def authenticated?
    checker = RestfulApiAuthentication::Checker.new(request.headers, request.fullpath)
    if checker.authorized?
      return true
    else
      if checker.verbose_errors
        respond_with(checker.errors, :status => 401, :location => nil)
      else
        respond_with(["not authorized"], :status => 401, :location => nil)
      end
    end
  end

  # This method should be used as a Rails before_filter in any controller in which one wants to ensure requests have valid client authentication headers and are considered master applications.
  #
  # In order to be authenticated, not only do the headers need to be valid but the is_master flag must be true in the associated RestClient model.
  #
  # Master accounts can be used for anything you like but are typically reserved for admin specific requests that should only be performed by a limited number of clients.
  def authenticated_master?
    checker = RestfulApiAuthentication::Checker.new(request.headers, request.fullpath)
    if checker.authorized?({:require_master => true})
      return true
    else
      if checker.verbose_errors
        respond_with(checker.errors, :status => 401, :location => nil)
      else
        respond_with(["not authorized"], :status => 401, :location => nil)
      end
    end
  end

end