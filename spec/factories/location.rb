FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Training Location #{n}" }
    sequence(:customer_location_id) { |n| "#{n}#{n}#{n}#{n}#{n}" }
    city 'Rockland'
    state 'MA'
    street_1 '200 Ledgewood Pl'
    zip_code '02370'
    latitude '42.1630307'
    longitude '-70.9081377'
    association :client
  end
end
