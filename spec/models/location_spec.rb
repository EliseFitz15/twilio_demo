require 'rails_helper'

describe Location, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to have_many(:memberships) }
  end

  describe 'validations' do
    subject { create(:location) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:customer_location_id) }
    it { is_expected.to validate_presence_of(:street_1) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:zip_code) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:client_id) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:client_id).with_message('You already have a location with that name') }
    it { is_expected.to validate_uniqueness_of(:customer_location_id).scoped_to(:client_id).case_insensitive.with_message('You already have a location with that ID') }

    it { is_expected.to validate_inclusion_of(:state).in_array(Location::STATES_BY_ABBR.values) }
  end

  describe 'database level uniqueness validation' do
    let(:client) { create(:client) }
    let(:locationA) { create(:location, client: client) }
    let(:locationB) { build(:location, client: client, customer_location_id: locationA.customer_location_id) }

    it 'fails' do
      expect { locationB.save(validate: false) }.to raise_error(StandardError)
    end
  end
end
