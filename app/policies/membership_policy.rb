class MembershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(location: :client).where(locations: { client: @client })
    end
  end

  def update?
    writable?
  end

  def create?
    writable?
  end

  private

  def writable?
    @record.location.client == @client
  end
end
