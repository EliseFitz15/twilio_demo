require 'rails_helper'

describe Webhooks::TwilioController, type: :request do
  describe 'Join interaction POST /webhooks/twilio/reply' do
    recieved_params = {
      From: '+155555555555',
      To: '+10987654321',
      Body: 'no'
    }

    before do
      member = create(:member, :with_active_membership)
      create(:interaction, member: member)
    end

    it 'returns a 200 response' do
      post webhooks_twilio_reply_path, params: recieved_params
      expect(response).to have_http_status(204)
    end

    it 'expects the following message when replying the the first question with no' do
      post webhooks_twilio_reply_path, params: recieved_params
      expect(FakeSMS.messages.last.body).to eql(
        '👊  Sweet. I can keep track of your progress and suggest ways to reach your goals. (You can tell me to stop at any time.) What is your #1 fitness goal right now?'
      )
    end

    it 'expects the following message when replying the the first question with yes' do
      recieved_params[:Body] = 'yes'
      post webhooks_twilio_reply_path, params: recieved_params
      expect(FakeSMS.messages.last.body).to eql(
        '💯 Awesome! I can keep track of your progress and suggest ways to reach your goals. (You can tell me to stop at any time.) What is your #1 fitness goal right now?'
      )
    end

    it 'expects the following message when provided a fitness goal' do
      post webhooks_twilio_reply_path, params: recieved_params
      recieved_params[:Body] = 'build muscles'
      post webhooks_twilio_reply_path, params: recieved_params
      expect(FakeSMS.messages.last.body).to eql('👍  Let\'s do this! I\'ll be in touch after your next visit.')
    end
  end

  describe 'Visit interaction POST /webhooks/twilio/reply' do
    recieved_params = {
      From: '+155555555555',
      To: '+10987654321',
      Body: '4'
    }

    it 'expects the following message when replying to visit' do
      member = create(:member, :with_active_membership)
      create(:interaction, member: member, flow_type: 'Visit')

      post webhooks_twilio_reply_path, params: recieved_params
      expect(FakeSMS.messages.last.body).to eql('Got it. Now get some rest and drink plenty of water before your next visit!')
    end
  end

  describe 'Message callback POST /webhooks/twilio/message_status_callback' do
    message_params = {
      SmsStatus: 'sent',
      MessageSid: 'SM0b42a572c9fd411fb49c805c9d4fb2a7'
    }

    it 'returns a 200 response when sent' do
      post webhooks_twilio_status_callback_path, params: message_params
      expect(response).to have_http_status(204)
    end

    it 'logs error if sms status fails' do
      message_params[:SmsStatus] = 'failed'
      message_params[:ErrorCode] = '30008'
      allow(Rails.logger).to receive(:error)
      post webhooks_twilio_status_callback_path, params: message_params
      expect(Rails.logger).to have_received(:error).with('** STATUS FAILED ** ---- Error Code 30008. Message Sid: SM0b42a572c9fd411fb49c805c9d4fb2a7')
    end
  end
end
