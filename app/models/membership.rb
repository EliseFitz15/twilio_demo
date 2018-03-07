class Membership < ApplicationRecord
  belongs_to :member
  belongs_to :location

  validates :location, :member, :started_at, presence: true
  validate :ended_at_comes_after_started_at, :one_active_membership

  def active?
    ended_at.nil?
  end

  def cancel(dt = nil)
    dt ||= Time.now.utc
    update_attributes(ended_at: dt) if active?
  end

  private

  def ended_at_comes_after_started_at
    errors.add(:ended_at, 'can\'t come before started_at') if ended_at.present? && started_at.present? && ended_at < started_at
  end

  def one_active_membership
    errors.add(:ended_at, 'can\'t be null for more than one record') if ended_at.blank? && member.memberships.where(ended_at: nil).count > 1
  end
end
