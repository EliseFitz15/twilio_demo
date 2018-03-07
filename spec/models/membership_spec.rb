require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:member) }
    it { is_expected.to belong_to(:location) }
  end

  describe 'validations' do
    subject { create(:membership) }

    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:member) }

    describe 'canceled at occurring before started_at' do
      let(:membership) { build(:membership, ended_at: Time.zone.parse('2012-11-11'), started_at: Time.zone.now) }

      before do
        membership.save
      end

      it 'is invalid' do
        expect(membership.valid?).to eq(false)
      end

      it 'validates that canceled_at can\'t occur before started_at' do
        expect(membership.errors[:ended_at]).to include('can\'t come before started_at')
      end
    end

    describe 'one active membership' do
      let(:member) { create :member, :with_active_membership }
      let(:second_active) do
        membership = build :membership, member: member, ended_at: nil
        member.memberships << membership
        membership
      end

      it 'does not allow a second active membership' do
        second_active.save
        expect(second_active.valid?).to be false
      end

      it 'has the correct error message' do
        second_active.valid?
        expect(second_active.errors.full_messages).to include('Ended at can\'t be null for more than one record')
      end
    end
  end
end
