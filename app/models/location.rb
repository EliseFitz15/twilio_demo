class Location < ApplicationRecord
  belongs_to :client
  has_many :memberships, dependent: :destroy, inverse_of: :location
  has_many :members, through: :memberships, inverse_of: :location
  validates :name, presence: true, uniqueness: {
    scope: :client_id,
    message: 'You already have a location with that name'
  }
  validates :customer_location_id, presence: true, uniqueness: {
    scope: :client_id,
    case_sensitive: false,
    message: 'You already have a location with that ID'
  }
  validates :street_1, presence: true
  validates :city, presence: true
  validates :state, presence: true, inclusion: { in: proc { STATES_BY_ABBR.values } }
  validates :zip_code, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :client_id, presence: true

  STATES_BY_ABBR = {
    'Alaska' => 'AK',
    'Alabama' => 'AL',
    'Arkansas' => 'AR',
    'Arizona' => 'AZ',
    'California' => 'CA',
    'Colorado' => 'CO',
    'Connecticut' => 'CT',
    'Delaware' => 'DE',
    'District of Columbia' => 'DC',
    'Florida' => 'FL',
    'Georgia' => 'GA',
    'Hawaii' => 'HI',
    'Iowa' => 'IA',
    'Idaho' => 'ID',
    'Illinois' => 'IL',
    'Indiana' => 'IN',
    'Kansas' => 'KS',
    'Kentucky' => 'KY',
    'Louisiana' => 'LA',
    'Massachusetts' => 'MA',
    'Maryland' => 'MD',
    'Maine' => 'ME',
    'Michigan' => 'MI',
    'Minnesota' => 'MN',
    'Mississippi' => 'MS',
    'Missouri' => 'MO',
    'Montana' => 'MT',
    'North Carolina' => 'NC',
    'North Dakota' => 'ND',
    'Nebraska' => 'NE',
    'New Hampshire' => 'NH',
    'New Jersey' => 'NJ',
    'New Mexico' => 'NM',
    'Nevada' => 'NV',
    'New York' => 'NY',
    'Ohio' => 'OH',
    'Oklahoma' => 'OK',
    'Oregon' => 'OR',
    'Pennsylvania' => 'PA',
    'Rhode Island' => 'RI',
    'South Carolina' => 'SC',
    'South Dakota' => 'SD',
    'Tennessee' => 'TN',
    'Texas' => 'TX',
    'Utah' => 'UT',
    'Virginia' => 'VA',
    'Vermont' => 'VT',
    'Washington' => 'WA',
    'Wisconsin' => 'WI',
    'West Virginia' => 'WV',
    'Wyoming' => 'WY'
  }.freeze
end
