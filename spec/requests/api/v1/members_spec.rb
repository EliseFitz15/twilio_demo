require 'rails_helper'

describe 'MembersAPI', type: :request do
  include_context :doorkeeper_app_with_token
  let(:id_that_doesnt_exist) { 666 }
  let(:location) { create :location, client: client }

  describe 'POST /api/v1/members' do
    let(:member) { build :member, :with_active_membership, first_name: 'Foo', last_name: 'Dude', location: location }

    describe 'valid post' do
      before do
        post '/api/v1/members', headers: auth_header,
                                params: extract_post_params_from_member(member)
      end

      it 'returns a created response' do
        expect(response.status).to eq(201)
      end

      it 'creates the user in the database' do
        expect(Member.all.count).to eq(1)
      end

      it 'has the correct attributes set' do
        m = Member.find_by(last_name: 'Dude')
        expect(m).to have_attributes(member.attributes.except('created_at', 'updated_at', 'id'))
      end

      it 'creates a membership for the member' do
        m = Member.includes(:memberships).find_by(last_name: 'Dude')
        expect(m.memberships.count).to eq(1)
      end
    end

    describe 'invalid posts' do
      before do
        attrs = member.attributes
        post '/api/v1/members', headers: auth_header, params: attrs
      end

      it 'returns a 400' do
        expect(response.status).to eq(400)
      end

      it 'indicates what went wrong in the response body' do
        expect(response.body).to eq('{"error":"memberships is missing"}')
      end
    end

    describe 'post duplicate member' do
      before do
        member.save!
        post '/api/v1/members',
             headers: auth_header,
             params: extract_post_params_from_member(member)
      end

      it 'returns a 422' do
        expect(response.status).to eq(422)
      end

      it 'indicates what went wrong in the response body' do
        expect(response.body).to eq('{"error":"duplicate_record","detail":"Member with id MyString already exists."}')
      end
    end

    describe 'Post existing client member id for different client' do
      before do
        common_id = 7
        member.client_member_id = common_id
        create :member, :with_active_membership, location: (create :location), client_member_id: common_id

        post '/api/v1/members',
             headers: auth_header,
             params: extract_post_params_from_member(member)
      end

      it 'creates the member' do
        expect(response.status).to eq(201)
      end
    end
  end

  describe 'put /api/v1/members/{id}' do
    let(:member) { create :member, :with_active_membership, location: location }

    describe 'valid put' do
      before do
        member.email = 'a@b.com'
        attrs = member.attributes
        put "/api/v1/members/#{member.client_member_id}", headers: auth_header, params: attrs
      end

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'updates the attribute in the database' do
        saved_member = Member.find(member.id)
        expect(saved_member.email).to eq('a@b.com')
      end
    end

    describe 'invalid field' do
      before do
        member.email = 'foo'
        attrs = member.attributes
        put "/api/v1/members/#{member.client_member_id}", headers: auth_header, params: attrs
      end

      it 'returns a 400 response' do
        expect(response.status).to eq(422)
      end

      it 'indicates what went wrong in the response body' do
        expect(response.body).to eq('{"error":"Validation failed: Email is invalid"}')
      end

      it 'does not update the user in the database' do
        updated_member = Member.find(member.id)
        expect(updated_member.email).to eq('a@b.com')
      end
    end

    describe 'Record not found' do
      before do
        member.email = 'foo@bar.com'
        attrs = member.attributes
        put "/api/v1/members/#{id_that_doesnt_exist}", headers: auth_header, params: attrs
      end

      it 'returns a 400 response' do
        expect(response.status).to eq(404)
      end

      it 'indicates what went wrong in the response body' do
        expect(response.body).to eq('{"error":"not_found","detail":"Member with id 666 not found."}')
      end

      it 'does not update the user in the database' do
        updated_member = Member.find(member.id)
        expect(updated_member.email).to eq('a@b.com')
      end
    end
  end

  describe 'get /api/v1/members/{id}' do
    describe 'valid get' do
      let(:member) { create :member, :with_active_membership, location: location }

      before do
        get "/api/v1/members/#{member.client_member_id}", headers: auth_header
      end

      it 'returns a 200' do
        expect(response.status).to eq(200)
      end

      it 'returns the correct member data' do
        member_json = create_member_json(member)
        expect(response.body).to eq(member_json)
      end
    end

    describe 'invalid get' do
      let(:member) { create :member, :with_active_membership, location: location }

      before do
        get "/api/v1/members/#{id_that_doesnt_exist}", headers: auth_header
      end

      it 'returns a 404' do
        expect(response.status).to eq(404)
      end

      it 'returns the correct member data' do
        expect(response.body).to eq('{"error":"not_found","detail":"Member with id 666 not found."}')
      end
    end
  end
end

def create_member_json(member)
  attrs = member.attributes.except('created_at', 'updated_at')
  memberships = member.memberships.map do |membership|
    base_membership_atts = membership.attributes.except('created_at', 'updated_at', 'member_id', 'location_id')
    base_membership_atts.merge(client_member_id: membership.member.client_member_id, customer_location_id: membership.location.customer_location_id)
  end
  attrs = attrs.merge(memberships: memberships)

  attrs.to_json
end

def extract_post_params_from_member(member)
  member.attributes.merge(memberships: [member.memberships.first.attributes.merge(customer_location_id: member.memberships.first.location.customer_location_id)])
end
