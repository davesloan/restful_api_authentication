module RequestHelper
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body).deep_symbolize_keys!
    end
  end

  module HeaderHelpers
    def signiture_headers(rest_client)
      headers = {}
      headers['x-api-key'] = rest_client.api_key
      headers['x-timestamp'] = Time.now.utc.to_s
      signiture = (Digest::SHA256.new << rest_client.secret + path + Time.now.utc.to_s).to_s
      headers['x-signature'] = signiture
      headers
    end
  end
end
