require 'rails_helper'

describe 'Locations API', type: :request do
  describe 'THe resource is protected' do
    it 'is protected' do
      get '/api/v1/locations'
      expect(response.status).to eq(401)
    end
  end

  describe 'GET /api/v1/locations' do
    include_context :doorkeeper_app_with_token

    let!(:location) { create(:location, client: client) }

    before do
      get '/api/v1/locations', headers: auth_header
    end

    it 'returns a 200' do
      expect(response.status).to eq(200)
    end

    describe 'Response body' do
      it 'has the correct id' do
        location_json = JSON.parse(response.body)[0]
        expect(location_json['id']).to eq(location.id)
      end

      it 'has the correct customer location id' do
        location_json = JSON.parse(response.body)[0]
        expect(location_json['customer_location_id']).to eq(location.customer_location_id)
      end

      it 'has the correct name' do
        location_json = JSON.parse(response.body)[0]
        expect(location_json['name']).to eq(location.name)
      end

      it 'has the correct client id' do
        location_json = JSON.parse(response.body)[0]
        expect(location_json['client_id']).to eq(client.id)
      end
    end

    describe 'It returns information scoped to the client passed in and not other clients info' do
      let(:location_json) { JSON.parse(response.body) }

      before do
        other_client = create :client
        create :location, client: other_client
        get '/api/v1/locations', headers: auth_header
      end

      it 'returns a 200' do
        expect(response.status).to eq(200)
      end

      it 'returns the client\'s one location' do
        expect(location_json.count).to eq(1)
      end

      it ' has two locations in the db' do
        expect(Location.all.count).to eq(2)
      end

      it 'does not have the other client\'s id in the parsed json' do
        expect(location_json[0]['id']).to eq(location.id)
      end
    end
  end

  describe 'POST /api/v1/locations' do
    include_context :doorkeeper_app_with_token

    let(:new_location_params) do
      {
        customer_location_id: '12345',
        name: 'Koko Rockland',
        city: 'Rockland',
        state: 'MA',
        street_1: '200 Ledgewood Pl',
        zip_code: '02370',
        latitude: 42.1630307,
        longitude: -70.9081377
      }
    end

    before do
      post '/api/v1/locations', params: new_location_params, headers: auth_header
    end

    it 'returns a 201' do
      expect(response.status).to eq(201)
    end

    describe 'Response body' do
      let(:location_json) { JSON.parse(response.body) }

      it 'has the correct customer location_id' do
        expect(location_json['customer_location_id']).to eq('12345')
      end

      it 'has the correct location name' do
        expect(location_json['name']).to eq('Koko Rockland')
      end

      it 'has the correct client id' do
        expect(location_json['client_id']).to eq(client.id)
      end
    end

    describe 'POST /api/v1/locations SAD PATH' do
      let(:incomplete_params) { { customer_location_id: '12345' } }

      before do
        post '/api/v1/locations', params: incomplete_params, headers: auth_header
      end

      it 'returns a 400' do
        expect(response.status).to eq(400)
      end

      it 'has the correct error message' do
        expected_msg = '{"error":"name is missing, name is empty, street_1 is missing, street_1 is empty, '\
                        'city is missing, city is empty, state is missing, state is empty, state does not have a valid value, zip_code is missing, '\
                        'zip_code is empty, latitude is missing, latitude is empty, longitude is missing, longitude is empty"}'
        expect(response.body).to include(expected_msg)
      end
    end
  end

  describe 'POST /api/v1/locations unique constraints' do
    include_context :doorkeeper_app_with_token
    let(:location) { create(:location, client: client) }

    let(:duplicate_loc_params) do
      {
        customer_location_id: location.customer_location_id.to_s,
        name: 'Koko Rockland',
        city: 'Rockland',
        state: 'MA',
        street_1: '200 Ledgewood Pl',
        zip_code: '02370',
        latitude: '42.1630307',
        longitude: '-70.9081377'
      }
    end

    it 'Creates a new location with the same location id for a different client' do
      location = create(:location)
      duplicate_loc_params[:customer_location_id] = location.customer_location_id.to_s

      post '/api/v1/locations', params: duplicate_loc_params, headers: auth_header
      expect(response.status).to eq(201)
    end

    describe 'POST /api/v1/locations unique constraints -Sad Path ' do
      before do
        post '/api/v1/locations', params: duplicate_loc_params, headers: auth_header
      end

      it 'returns a 422' do
        expect(response.status).to eq(422)
      end

      it 'has the correct response body' do
        expect(response.body).to include('Validation failed: Customer location You already have a location with that ID')
      end
    end
  end

  describe 'PUT /api/v1/locations' do
    include_context :doorkeeper_app_with_token
    let(:location) { create(:location, client: client) }
    let(:update_params) do
      {
        customer_location_id: location.customer_location_id.to_s,
        name: "#{location.name}!!",
        city: 'Braintree',
        state: 'MA',
        street_1: '200 Ledgewood Pl',
        zip_code: '02370',
        latitude: '42.1630307',
        longitude: '-70.9081377'
      }
    end

    it 'Updates location successfully' do
      put '/api/v1/locations', params: update_params, headers: auth_header
      expect(response.status).to eq(200)
    end

    describe 'PUT /api/v1/locations -Sad Path' do
      let(:bad_update_params) do
        {
          customer_location_id: location.customer_location_id.to_s,
          name: "#{location.name}!!",
          city: 'Braintree'
        }
      end

      before do
        put '/api/v1/locations', params: bad_update_params, headers: auth_header
      end

      it 'returns a 422' do
        expect(response.status).to eq(422)
      end

      it 'Fails to updates location if all requirements are not met' do
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['error']).to eq("Validation failed: Street 1 can't be blank, State can't be blank, State is not included in "\
                                           "the list, Zip code can't be blank, Latitude can't be blank, Longitude can't be blank")
      end
    end

    describe 'Create Location state validation' do
      let(:location) { build :location, state: 'zz' }

      before do
        post '/api/v1/locations', params: location.attributes, headers: auth_header
      end
      it 'returns a 422' do
        expect(response.status).to eq(400)
      end
      it 'Fails to create the location' do
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to eq('error' => 'state does not have a valid value')
      end
    end

    describe 'Create Location state validation' do
      let(:location) { create :location }

      before do
        location.state = 'zz'
        put '/api/v1/locations', params: location.attributes, headers: auth_header
      end

      it 'returns a 422' do
        expect(response.status).to eq(400)
      end

      it 'Fails to create the location' do
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to eq('error' => 'state does not have a valid value')
      end
    end
  end
end
