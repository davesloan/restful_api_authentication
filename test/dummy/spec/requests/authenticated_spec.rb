require 'rails_helper'

describe 'Authentication', type: :request, requests: true do
  let(:path) { '/help/authentication' }
  let!(:rest_client) { FactoryGirl.create(:rest_client) }
  let(:headers) { {} }

  context 'authorized' do
    it 'should return 200 (ok) when requesting with valid credentials' do
      headers = signiture_headers(rest_client)
      get path, params: nil, headers: headers
      expect(response).to have_http_status 200
      expect(json[:auth][0]).to eq('authorized')
    end

    it 'should return 200 (ok) when requesting with valid credentials but chance case of signiture' do
      headers = signiture_headers(rest_client)
      headers['x-signature'] = headers['x-signature'].upcase
      get path, params: nil, headers: headers
      expect(response).to have_http_status 200
      expect(json[:auth][0]).to eq('authorized')
    end
  end

  context 'unauthorized' do
    it 'should return 401 (unauthorized) when requesting without credentials' do
      get path
      expect(response).to have_http_status 401
      expect(json[:errors][0]).to eq('one or more required headers is missing')
    end

    it 'should return 401 (unauthorized) when requesting with invalid secret' do
      headers = signiture_headers(rest_client)
      headers['x-signature'] = 'invalid'
      get path, params: nil, headers: headers
      expect(response).to have_http_status 401
      expect(json[:errors][0]).to eq('signature is invalid')
    end

    it 'should return 401 (unauthorized) when requesting with invalid time format' do
      headers = signiture_headers(rest_client)
      headers['x-timestamp'] = '2012-53-05 13:53:55 UTC'
      get path, params: nil, headers: headers
      expect(response).to have_http_status 401
      expect(json[:errors][0]).to eq('timestamp was in an invalid format; should be YYYY-MM-DD HH:MM:SS UTC')
    end

    it 'should return 401 (unauthorized) when requesting with unknown api key' do
      headers = signiture_headers(rest_client)
      headers['x-api-key'] = 'unknown'
      get path, params: nil, headers: headers
      expect(response).to have_http_status 401
      expect(json[:errors][0]).to eq('client is not registered')
    end

    it 'should return 401 (unauthorized) when requesting timestamp is too far in furture' do
      headers = signiture_headers(rest_client)
      headers['x-timestamp'] = (Time.now.utc + 11.minutes).to_s
      get path, params: nil, headers: headers
      expect(response).to have_http_status 401
      expect(json[:errors][0]).to eq('request is outside the required time window of 10 minutes')
    end
  end
end
