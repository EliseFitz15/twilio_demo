require 'rails_helper'

RSpec.describe MemberPolicy do
  subject { described_class.new(logged_in_client, member) }

  let(:logged_in_client) { create :client }
  let(:logged_in_client_location) { create :location, client: logged_in_client }

  let(:resolved_scope) do
    described_class::Scope.new(logged_in_client, Member.all).resolve
  end

  context 'when a client manipulates their members' do
    let(:member) { build :member, :with_active_membership, location: logged_in_client_location }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }

    context 'when a client updates a member with a canceled membership' do
      let(:member) { build :member, :with_inactive_membership, location: logged_in_client_location }

      it { is_expected.to forbid_action(:update) }
    end
  end

  context 'when a client tries to manipulate another client\'s member' do
    let(:some_other_client_location) { create :location }
    let(:member) { build :member, :with_active_membership, location: some_other_client_location }

    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
  end

  context 'when a client requests their member' do
    let(:member) { create :member, :with_active_membership, location: logged_in_client_location }

    it 'returns the members in the DB that belong to that location' do
      expect(resolved_scope.all).to include(member)
    end
  end

  context 'when a client tries to retrieve a member that is not their own' do
    let(:some_other_client_location) { create :location }
    let(:member) { create :member, :with_active_membership, location: some_other_client_location }

    it 'does not return a member that doesn\t belong to the location' do
      expect(resolved_scope).not_to include(member)
    end
  end
end
