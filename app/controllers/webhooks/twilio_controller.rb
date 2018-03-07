require 'sms_client'
require 'interaction_factory'

module Webhooks
  class TwilioController < ApplicationController
    skip_before_action :verify_authenticity_token, :authenticate_user!
    before_action do
      @sms_client = SMSClient.new
    end

    def reply
      @member = Member.find_by(phone: message_params[:From])
      @member.current_interaction.update_current_conversation(message_params[:To], message_params[:Body])
      flow_type = @member.current_interaction.flow_type
      conversation_type = InteractionFactory.create(flow_type)
      conversation_type.send_message(@member, @sms_client)
    end

    def status_callback
      sms_status = message_params[:SmsStatus]
      error_code = message_params[:ErrorCode]
      message_sid = message_params[:MessageSid]
      if sms_status == 'failed'
        Rollbar.error("** STATUS FAILED ** ---- Error Code #{error_code}. See additional Twilio error details: https://www.twilio.com/console/sms/logs/#{message_sid}")
        logger.error("** STATUS FAILED ** ---- Error Code #{error_code}. Message Sid: #{message_sid}")
      else
        logger.info("---- SMS Status: #{sms_status}. Message Sid: #{message_sid}.")
      end
    end

    private

    def message_params
      params.permit(:Body, :From, :To, :ErrorCode, :MessageSid, :SmsStatus)
    end
  end
end
