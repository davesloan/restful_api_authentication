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

module RestfulApiAuthentication
  class Railtie < Rails::Railtie
    initializer "restful_api_authentication_railtie.config_initializer" do
      if File.exists? Rails.root.join('config', 'restful_api_authentication.yml')
        config_data = YAML::load_file(Rails.root.join('config', 'restful_api_authentication.yml'))[Rails.env]
        RestfulApiAuthentication::Checker.time_window      = config_data['request_window']
        RestfulApiAuthentication::Checker.header_timestamp = config_data['header_names']['timestamp']
        RestfulApiAuthentication::Checker.header_signature = config_data['header_names']['signature']
        RestfulApiAuthentication::Checker.header_api_key   = config_data['header_names']['api_key']
      else
        RestfulApiAuthentication::Checker.time_window      = nil
        RestfulApiAuthentication::Checker.header_timestamp = nil
        RestfulApiAuthentication::Checker.header_signature = nil
        RestfulApiAuthentication::Checker.header_api_key   = nil
      end
    end
  end
end
