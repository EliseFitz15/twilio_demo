require 'rails_helper'

describe Client, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:locations) }
  end

  describe 'validations' do
    subject { create(:client) }

    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
