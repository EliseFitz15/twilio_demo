require 'rails_helper'

RSpec.describe LocationPolicy do
  subject { described_class.new(logged_in_client, location) }

  let(:logged_in_client) { create :client }
  let(:logged_in_client_location) { create :location, client: logged_in_client }

  let(:resolved_scope) do
    described_class::Scope.new(logged_in_client, Location.all).resolve
  end

  context 'when a client manipulates a location that is theirs' do
    let(:location) { logged_in_client_location }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
  end

  context 'when a client tries to manipulate a location that isn\'t theirs' do
    let(:location) { create :location }

    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
  end

  context 'when a client requests their location' do
    let(:location) { create :location }

    before do
      create_list :location, 3
      create :location, client: logged_in_client
    end

    it 'filters out locations that don\'t belong to the client in context' do
      expect(resolved_scope.all.count).to eq(1)
    end

    it 'returns the locations in the DB that belong to that client' do
      expect(resolved_scope.all).to include(logged_in_client_location)
    end
  end

  context 'when a client tries to retrieve a location that is not their own' do
    let(:location) { :logged_in_client_location }

    it 'does not return a member that doesn\t belong to the location' do
      expect(resolved_scope).not_to include(location)
    end
  end
end
