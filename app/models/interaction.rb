class Interaction < ApplicationRecord
  belongs_to :member

  validates :member_id,
            :interaction_type,
            :flow_type,
            :conversation,
            presence: true

  validates :interaction_type, inclusion: { in: %w[SMS e_mail] }
  enum flow_type: %i[Join Visit]
  validates :flow_type, inclusion: { in: %w[Join Visit] }

  def update_current_conversation(to, body, media = [])
    i = conversation.keys.count
    conversation[i + 1] = {
      to: to,
      body: body,
      media: media,
      datetime: Time.zone.now
    }
    save!
  end
end
