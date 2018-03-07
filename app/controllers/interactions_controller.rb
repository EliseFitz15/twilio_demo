require 'sms_client'
require 'interaction_factory'
class InteractionsController < ApplicationController
  include MemberHelper

  before_action do
    @sms_client = SMSClient.new
  end

  def create
    @member = Member.includes(:interactions).find_by(phone: interaction_params[:phone])
    @member = @member.nil? ? demo_membership.last.member : @member
    save_and_initiate_send
  end

  def conversation
    @interaction = Interaction.find(conversation_params[:id])
  end

  private

  def interaction_params
    params.permit(:phone, :first_name, :last_name, :flow_type)
  end

  def conversation_params
    params.permit(:id)
  end

  def save_and_initiate_send
    if @member.save
      begin
        send_message
      rescue Twilio::REST::RestError => e
        handle_twilio_error(e)
      end
      redirect_to root_path
    else
      flash[:error] = @member.errors.full_messages.join('. ')
      render 'home/index'
    end
  end

  def send_message
    flow_type = interaction_params[:flow_type]
    conversation_type = InteractionFactory.create(flow_type)
    conversation_type.send_message(@member, @sms_client, send_first: true)
    flash[:notice] = "#{flow_type} SMS sent to #{@member.phone}"
  end

  def handle_twilio_error(e)
    Rollbar.error("***#{e.message}***")
    logger.error("***#{e.message}***")
    flash[:error] = e.message.to_s
  end
end
