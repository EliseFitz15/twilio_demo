require 'rails_helper'

describe 'Authentication', type: :request do
  let(:application) { create :application }

  describe 'retrieving token' do
    let(:token_params) do
      {
        grant_type: 'client_credentials',
        client_id: application.uid,
        client_secret: application.secret
      }
    end

    let(:body) { JSON.parse(response.body) }

    before do
      post '/api/v1/oauth/token', params: token_params
    end

    it 'returns a 200' do
      expect(response.status).to eq(200)
    end

    it 'returns an access token' do
      expect(body['access_token']).not_to be_empty
    end

    it 'returns a token type of bearer' do
      expect(body['token_type']).to eq('bearer')
    end

    it 'returns the correct expiration time ' do
      expect(body['expires_in']).to eq(7200)
    end
  end

  describe 'doesn\'t return a token with bad credentials' do
    let(:bad_params) do
      {
        grant_type: 'client_credentials',
        client_id: application.uid,
        client_secret: 'bad secret'
      }
    end

    before do
      post '/api/v1/oauth/token', params: bad_params
    end

    it 'returns a 401' do
      expect(response.status).to eq(401)
    end

    it 'contains an error message in the response body' do
      msg = '{"error":"invalid_client","error_description":"Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method."}'
      expect(response.body).to eq(msg)
    end
  end
end
