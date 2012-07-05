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
  class Checker
    # Class attributes which are set when the Rails application is initialized: locally cached version of configuration settings stored in YML file.
    cattr_accessor :header_timestamp, :header_signature, :header_api_key, :time_window, :verbose_errors
    attr_accessor :http_headers, :request_uri, :errors
    
    def initialize(http_headers, request_uri)
      @http_headers = http_headers
      @request_uri = request_uri
      @errors = []
    end

    # Checks if the current request passes authorization
    def authorized?(options = {})
      raise "Configuration values not found. Please run rails g restful_api_authentication:install to generate a config file." if @@header_timestamp.nil? || @@header_signature.nil? || @@header_api_key.nil? || @@time_window.nil?
      return_val = false
      if headers_have_values?
        if in_time_window?
          if test_hash == @http_headers[@@header_signature]
            if options[:require_master] == true
              if is_master?
                return_val = true
              else
                @errors << "client does not have the required permissions"
              end
            else
              return_val = true
            end
          else
            @errors << "signature is invalid"
          end
        else
          @errors << "request is outside the required time window of #{@@time_window.to_s} minutes"
        end
      else
        @errors << "one or more required headers is missing"
      end
      if return_val == false && @errors.count == 0
        @errors << "authentication failed"
      end
      return_val
    end

    private

      # determines if a RestClient has master privileges or not
      def is_master?
        client = RestClient.where(:api_key => @http_headers[@@header_api_key]).first
        client.is_master
      end

      # determines if given timestamp is within a specific window of minutes
      def in_time_window?
        @@time_window = 4 if @@time_window < 4
        minutes = (@@time_window / 2).floor
        ts = Chronic.parse @http_headers[@@header_timestamp]
        before = Time.now.utc - 60*minutes
        after = Time.now.utc + 60*minutes
        if ts.nil?
          @errors << "timestamp was in an invalid format; should be YYYY-MM-DD HH:MM:SS UTC"
          return false
        end
        ts > before && ts < after
      end

      # checks that incoming parameters have the keys we expect
      def headers_have_values?
        !@http_headers[@@header_api_key].nil? && !@http_headers[@@header_signature].nil? && !@http_headers[@@header_timestamp].nil?
      end

      # generates the string that is hashed to produce the signature
      def str_to_hash
        client = RestClient.where(:api_key => @http_headers[@@header_api_key]).first
        if client.nil?
          @errors << "client is not registered"
        end
        client.nil? ? "" : client.secret + @request_uri.gsub( /\?.*/, "" ) + @http_headers[@@header_timestamp]
      end

      # generates the hash that is compared to the incoming signature
      def test_hash
        (Digest::SHA256.new << str_to_hash).to_s
      end    
    
  end
end