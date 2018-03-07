class Member < ApplicationRecord
  has_many :memberships, dependent: :destroy, inverse_of: :member
  has_many :interactions, dependent: :destroy, inverse_of: :member
  has_many :locations, through: :memberships, inverse_of: :member
  has_many :clients, through: :locations, inverse_of: :member

  validates :client_member_id,
            :first_name,
            :last_name,
            :email,
            :phone,
            :date_of_birth,
            :gender,
            :memberships,
            presence: true

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :phone, length: { minimum: 10 }
  validates :gender, inclusion: { in: %w[M F] }
  validate :one_active_membership

  def active_membership
    memberships.select { |membership| membership.ended_at.blank? }.first
  end

  def current_interaction
    interactions.order(:updated_at).last
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_time_gym_goer
    interaction = interactions.find_by(flow_type: 'Join')
    if !interaction.nil?
      response = interaction.conversation['2']
      !response.nil? ? read_response(response) : false
    else
      false
    end
  end

  def read_response(r)
    r['body'].downcase.start_with? 'y'
  end

  private

  def one_active_membership
    errors.add(:member, 'can\'t have more than one active membership') if memberships.where(ended_at: nil).count > 1
  end
end
