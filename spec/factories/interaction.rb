FactoryBot.define do
  factory :interaction do
    msg = {
      '1' => {
        'to' => '+11234567890',
        'body' => "You rock User. Welcome to the Rockland Club. My name is Atlas. I'm here to help you get the most out of your gym membership. Is this your first time in a gym?",
        'from' => ENV['TWILIO_NUMBER'],
        'media' => 'http://gph.to/2kcZn9Y',
        'datetime' => '2017-12-07T21:15:34.142Z'
      }
    }

    association :member, :with_active_membership
    interaction_type 'SMS'
    flow_type 'Join'
    conversation msg

    trait :with_full_conversation do
      discussion = {
        '1' => {
          'to' => '+11234567890',
          'body' => "You rock User. Welcome to the Rockland Club. My name is Atlas. I'm here to help you get the most out of your gym membership. Is this your first time in a gym?",
          'from' => ENV['TWILIO_NUMBER'],
          'media' => 'http://gph.to/2kcZn9Y',
          'datetime' => '2017-12-07T21:15:34.142Z'
        },
        '2' => {
          'to' =>  ENV['TWILIO_NUMBER'],
          'body' => 'yes',
          'from' => '+11234567890',
          'media' => nil,
          'datetime' => '2017-12-07T22:15:34.142Z'
        },
        '3' => {
          'to' => '+11234567890',
          'body' => 'What is your goal?',
          'from' =>  ENV['TWILIO_NUMBER'],
          'media' => nil,
          'datetime' => '2017-12-07T22:15:34.142Z'
        },
        '4' => {
          'to' => '+11234567890',
          'body' => 'Build muscle',
          'from' =>  '+11234567890',
          'datetime' => '2017-12-07T22:15:34.142Z'
        }
      }

      conversation discussion
    end
  end
end
