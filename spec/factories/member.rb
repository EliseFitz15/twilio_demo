FactoryBot.define do
  factory :member do
    client_member_id 'MyString'
    first_name 'MyString'
    last_name 'MyString'
    email 'a@b.com'
    phone '+155555555555'
    date_of_birth '2017-11-17'
    gender 'F'

    trait :with_active_membership do
      transient do
        started_at nil
        ended_at nil
        location nil
      end

      after(:build) { |m, evaluator| set_membership(m, evaluator, true) }
    end

    trait :with_inactive_membership do
      transient do
        started_at nil
        ended_at nil
        location nil
      end

      after(:build) { |m, evaluator| set_membership(m, evaluator, false) }
    end
  end
end

def set_membership(member, evaluator, is_active)
  started_at = evaluator.try(:started_at) || 30.days.ago
  ended_at = evaluator.try(:ended_at) || 1.day.ago
  location = evaluator.try(:location) || FactoryBot.build(:location)
  member.memberships << build(:membership, started_at: started_at, ended_at: is_active ? nil : ended_at, member: member, location: location)
end
