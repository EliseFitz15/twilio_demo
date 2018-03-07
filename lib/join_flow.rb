class JoinFlow
  FIRST_REPLY_FROM_MEMBER = 2
  SECOND_REPLY_FROM_MEMBER = 4

  def send_message(member, client, **args)
    if args[:send_first]
      message = send_first_message(member, client)
      generate_interaction(member, message)
    else
      case member.current_interaction.conversation.keys.count
      when FIRST_REPLY_FROM_MEMBER
        send_first_reply(member, client)
      when SECOND_REPLY_FROM_MEMBER
        send_second_reply(member, client)
      end
    end
  end

  private

  def generate_interaction(member, message)
    interaction = Interaction.new(member: member, interaction_type: 'SMS', flow_type: 'Join')
    interaction.update_current_conversation(member.phone, message[:body], message[:media])
  end

  def send_first_message(member, client)
    url_config = Rails.application.config.sms_default_url_options
    body = formatted_first_message(member)
    media = ["http://#{url_config[:host]}#{ActionController::Base.helpers.image_url('giphy-downsized.gif')}",
             Rails.application.routes.url_helpers.vcard_url(url_config)]
    client.send_message(member.phone, body, media)
    { body: body, media: media }
  end

  def send_first_reply(member, client)
    body = build_first_reply_body(member.current_interaction.conversation['2']['body'])
    client.send_message(member.phone, body)
    member.current_interaction.update_current_conversation(member.phone, body)
  end

  def send_second_reply(member, client)
    body = "👍  Let's do this! I'll be in touch after your next visit."
    client.send_message(member.phone, body)
    member.current_interaction.update_current_conversation(member.phone, body)
  end

  def build_first_reply_body(incoming_message)
    prefix = if incoming_message.downcase.start_with? 'y'
               '💯 Awesome! '
             elsif incoming_message.downcase.start_with? 'n'
               '👊  Sweet. '
             end
    prefix + 'I can keep track of your progress and suggest ways to reach your goals. (You can tell me to stop at any time.) What is your #1 fitness goal right now?'
  end

  def formatted_first_message(member)
    "You rock #{member.first_name}. Welcome to the #{member.memberships.last.location.city} Club. My name is Atlas. I'm here to help you get the most out of your gym membership.
    Is this your first time in a gym?"
  end
end
