FactoryBot.define do
  factory :membership do
    association :member, factory: :member, strategy: :build
    association :location
    started_at { 30.days.ago }
    ended_at { 1.day.ago }

    trait :active do
      ended_at nil
    end

    trait :inactive do
      ended_at { 1.day.ago }
    end
  end
end
