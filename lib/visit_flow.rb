class VisitFlow
  def send_message(member, client, **args)
    if args[:send_first]
      message = send_first_message(member, client)
      interaction = Interaction.new(member: member, interaction_type: 'SMS', flow_type: 'Visit')
      interaction.update_current_conversation(member.phone, message[:body])
    else
      message = send_next_message(member, client)
      member.current_interaction.update_current_conversation(member.phone, message[:body])
    end
  end

  private

  def send_first_message(member, client)
    body = if member.first_time_gym_goer
             "Getting started in the gym can be an intimidating experience, so your're a rock star just for showing up! 💪 \n
             Now let's make it a habit. 🙂 How many days a week do you plan on going to the gym?"
           else
             "Strong work at the gym today, #{member.first_name}! \n \nI'll keep track of your visits for you. How many days a week do you plan on going to the gym?"
           end
    client.send_message(member.phone, body)
    { body: body }
  end

  def send_next_message(member, client)
    body = 'Got it. Now get some rest and drink plenty of water before your next visit!'
    client.send_message(member.phone, body)
    { body: body }
  end
end
