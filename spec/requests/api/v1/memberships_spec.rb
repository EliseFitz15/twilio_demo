require 'rails_helper'

describe 'MembershipsAPI', type: :request do
  include_context :doorkeeper_app_with_token
  let(:location) { create :location, client: client }
  let(:member) { create :member, :with_inactive_membership, started_at: '2000-11-19', location: location }
  let(:id_that_doesnt_exist) { 666 }

  describe 'POST /api/v1/members/:id/memberships HAPPY Path' do
    let(:membership) { build :membership, member: member, started_at: '2000-11-19', location: location }

    before do
      params = membership.attributes.merge(customer_location_id: membership.location.customer_location_id)
      post "/api/v1/members/#{member.client_member_id}/memberships", headers: auth_header, params: params
    end

    it 'returns a 201' do
      expect(response.status).to eq(201)
    end

    describe 'response attributes' do
      let(:parsed_json) { JSON.parse(response.body) }

      it 'has our db id' do
        expect(parsed_json['id']).not_to be_nil
      end

      it 'has the correct ended_at' do
        expect(parsed_json['ended_at']).to eq(membership.ended_at.strftime('%FT%T.000Z'))
      end

      it 'has the correct started_at' do
        expect(parsed_json['started_at']).to eq(membership.started_at.strftime('%FT%T.000Z'))
      end

      it 'is associated to the correct location' do
        db_membership = Membership.find_by(started_at: '2000-11-19')
        expect(parsed_json['customer_location_id']).to eq(db_membership.location.customer_location_id)
      end

      it 'is associated to the correct member' do
        db_membership = Membership.find_by(started_at: '2000-11-19')
        expect(parsed_json['client_member_id']).to eq(db_membership.member.client_member_id)
      end
    end
  end

  describe 'POST /api/v1/members/:id/memberships SAD Path  - Authorization -does not allow a client to create a membership for another client\'s location' do
    let(:membership) { build :membership, member: member, started_at: '2000-11-19', location: location }

    before do
      params = membership.attributes.merge(customer_location_id: create(:location).customer_location_id)
      post "/api/v1/members/#{member.client_member_id}/memberships", headers: auth_header, params: params
    end

    it 'returns a 403' do
      expect(response.status).to eq(403)
    end

    it 'returns a not authorized error' do
      expect(response.body).to eq('{"error":"Not Authorized","detail":"Not authorized to access this resource"}')
    end
  end
  describe 'POST /api/v1/members/:id/memberships SAD Path' do
    let(:membership) { build :membership, member: member, location: member.memberships.first.location, started_at: '2000-11-19' }

    before do
      params = membership.attributes.merge(customer_location_id: membership.location.customer_location_id)
      post "/api/v1/members/#{id_that_doesnt_exist}/memberships", headers: auth_header, params: params
    end

    it 'returns a 404' do
      expect(response.status).to eq(404)
    end

    it 'returns a meaningful error message' do
      expect(response.body).to eq('{"error":"not_found","detail":"Member with id 666 not found."}')
    end
  end

  describe 'PUT /api/v1/members/:id/memberships/cancel HAPPY Path' do
    let!(:membership) do
      create :membership, member: member, location: member.memberships.first.location, ended_at: nil
    end

    before do
      put "/api/v1/members/#{member.client_member_id}/memberships/cancel", headers: auth_header
      membership.reload
    end

    it 'return a 200' do
      expect(response.status).to eq(200)
    end

    describe 'response attributes' do
      let(:parsed_json) { JSON.parse(response.body) }

      it 'has our db id' do
        expect(parsed_json['id']).to eq(membership.id)
      end

      it 'has the correct ended_at' do
        expect(parsed_json['ended_at']).to eq(membership.ended_at.strftime('%FT%T.%3NZ'))
      end

      it 'has the correct started_at' do
        expect(parsed_json['started_at']).to eq(membership.started_at.strftime('%FT%T.%3NZ'))
      end

      it 'is associated to the correct location' do
        expect(parsed_json['customer_location_id']).to eq(membership.location.customer_location_id)
      end

      it 'is associated to the correct member' do
        expect(parsed_json['client_member_id']).to eq(membership.member.client_member_id)
      end
    end
  end

  describe 'PUT /api/v1/members/:id/memberships/cancel SAD Path - Member Not Found' do
    let!(:membership) { create :membership, member: member, location: member.memberships.first.location, ended_at: nil }

    before do
      put "/api/v1/members/#{id_that_doesnt_exist}/memberships/cancel", headers: auth_header
      membership.reload
    end

    it 'returns a 404' do
      expect(response.status).to eq(404)
    end

    it 'returns a meaningful error message' do
      expect(response.body).to eq('{"error":"not_found","detail":"Member with id 666 not found."}')
    end
  end

  describe 'PUT /api/v1/members/:id/memberships/cancel SAD Path - No active membership' do
    let!(:membership) { create :membership, member: member, location: member.memberships.first.location }

    before do
      put "/api/v1/members/#{member.client_member_id}/memberships/cancel", headers: auth_header
      membership.reload
    end

    it 'returns a 422' do
      expect(response.status).to eq(422)
    end

    it 'returns a meaningful error message' do
      expect(response.body).to eq('{"error":"no_active_membership","detail":"Member with id MyString does not have an active membership to cancel."}')
    end
  end

  describe 'PUT /api/v1/members/:id/memberships/cancel SAD Path - Not authorized to update membership' do
    let(:location) { create :location }
    let!(:membership) { create :membership, :active, member: member, location: location }

    before do
      put "/api/v1/members/#{member.client_member_id}/memberships/cancel", headers: auth_header
      membership.reload
    end

    it 'returns a 403' do
      expect(response.status).to eq(403)
    end

    it 'returns a not authorized error' do
      expect(response.body).to eq('{"error":"Not Authorized","detail":"Not authorized to access this resource"}')
    end
  end

  describe 'GET /api/v1/members/:id/memberships HAPPY PATH' do
    # let!(:membership) { create :membership, member: member, location: member.memberships.first.location, ended_at: nil }

    before do
      get "/api/v1/members/#{member.client_member_id}/memberships", headers: auth_header
      member.reload
    end

    it 'returns a 200' do
      expect(response.status).to eq(200)
    end

    describe 'response attributes' do
      let(:parsed_json) { JSON.parse(response.body) }

      it 'returns the correct results' do
        expected_string = member.memberships.map do |m|
          m.attributes.except('member_id', 'location_id', 'updated_at', 'created_at').merge(client_member_id: m.member.client_member_id, customer_location_id: m.location.customer_location_id)
        end.to_json

        expect(response.body).to eq(expected_string)
      end
    end
  end

  describe 'GET /api/v1/members/:id/memberships HAPPY PATH' do
    before do
      get "/api/v1/members/#{id_that_doesnt_exist}/memberships", headers: auth_header
    end

    it 'returns a 404' do
      expect(response.status).to eq(404)
    end

    it 'returns a meaningful error message' do
      expect(response.body).to eq('{"error":"not_found","detail":"Member with id 666 not found."}')
    end
  end

  describe 'GET /api/v1/members/:id/memberships - HAPPY PATH ' do
    let(:parsed_json) { JSON.parse(response.body) }

    before do
      member.memberships.destroy_all
      create_list(:membership, 3, :inactive, member: member)
      create(:membership, :active, member: member, location: location)
      get "/api/v1/members/#{member.client_member_id}/memberships", headers: auth_header
      member.reload
    end

    it 'returns a 200' do
      expect(response.status).to eq(200)
    end

    it 'onlies return 1 membership record' do
      expect(parsed_json.count).to eq(1)
    end

    it 'returns the correct attributes' do
      expect(parsed_json[0]['id']).to eq(member.active_membership.id)
    end
  end
end
