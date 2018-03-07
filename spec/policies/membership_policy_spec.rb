require 'rails_helper'

RSpec.describe MembershipPolicy do
  subject { described_class.new(logged_in_client, membership) }

  let(:logged_in_client) { create :client }
  let(:logged_in_client_location) { create :location, client: logged_in_client }

  let(:resolved_scope) do
    described_class::Scope.new(logged_in_client, Membership.all).resolve
  end

  context 'when a client manipulates a memberhsip that belongs to one of their locations' do
    let(:membership) { build :membership, :active, location: logged_in_client_location }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
  end

  context 'when a client tries to manipulate another client\'s member' do
    let(:some_other_client_location) { create :location }
    let(:membership) { build :membership, :active, location: some_other_client_location }

    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
  end

  context 'when a client requests their member' do
    let(:member) { create :member, :with_active_membership, location: logged_in_client_location }

    before do
      create_list :membership, 3, :inactive, member: member
    end
    it 'filters out memberships that don\'t belong to the client in context' do
      expect(resolved_scope.all.count).to eq(1)
    end

    it 'returns the memberships in the DB that belong to that location' do
      expect(resolved_scope.all).to include(member.active_membership)
    end
  end

  context 'when a client tries to retrieve a membership that is not their own' do
    let(:some_other_client_location) { create :location }
    let(:membership) { create :membership, :active, location: some_other_client_location }

    it 'does not return a member that doesn\t belong to the location' do
      expect(resolved_scope).not_to include(membership)
    end
  end
end
