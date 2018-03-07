require 'rails_helper'

describe Member, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:memberships) }
  end

  describe 'validations' do
    subject(:member) { create(:member, :with_inactive_membership) }

    let(:location) { create :location }

    it { is_expected.to validate_presence_of(:client_member_id) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:memberships) }

    it { is_expected.to validate_length_of(:phone).is_at_least(10) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(%w[M F]) }

    # TODO: Revisit this one.  Is a member truly valid w/o a membership?
    it 'allows a member with no memberships to be valid' do
      expect(member.valid?).to be true
    end

    it 'allows a member with only inactive memberships to be valid' do
      member.memberships << create(:membership, location: location, member: member)
      expect(member.valid?).to be true
    end

    describe 'Only one active membership allowed' do
      let(:member) { create :member, :with_active_membership }

      before do
        member.memberships << build(:membership, location: location, member: member, started_at: 1.day.ago, ended_at: nil)
        member.save
      end

      it 'is invalid' do
        expect(member.valid?).to be false
      end

      it 'has the correct error message' do
        member.valid?
        expect(member.errors.full_messages).to include('Member can\'t have more than one active membership')
      end
    end
  end

  describe '#active_memberships' do
    let(:member) { create :member, :with_active_membership }

    before do
      member.reload
    end

    it 'returns the active membership record' do
      expect(member.active_membership).to eq(Membership.find_by(member: member))
    end
  end

  describe '#first_time_gym_goer' do
    context 'when member responded yes' do
      let(:interaction) { create :interaction, :with_full_conversation }

      it 'returns true' do
        expect(interaction.member.first_time_gym_goer).to be(true)
      end
    end

    context 'when member responded no' do
      let(:interaction) { create :interaction, :with_full_conversation }

      it 'returns false' do
        interaction.conversation['2']['body'] = 'no'
        interaction.save!
        expect(interaction.member.first_time_gym_goer).to be(false)
      end
    end

    context 'when member did not respond' do
      let(:interaction) { create :interaction }

      it 'returns false' do
        expect(interaction.member.first_time_gym_goer).to be(false)
      end
    end
  end
end
