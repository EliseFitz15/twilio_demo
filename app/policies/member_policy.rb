class MemberPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # scope.clients.where(id: @client.id)
      scope.joins(memberships: [location: :client]).where(memberships: { locations: { client: @client } })
    end
  end

  def update?
    active_membership = @record.active_membership
    active_membership.present? && active_membership.location.client == @client
  end

  def create?
    @record.memberships.all? { |memberships| memberships.location.client == @client }
  end
end
