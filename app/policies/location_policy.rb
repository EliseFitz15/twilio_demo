class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(client: @client)
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
    @record.client == @client
  end
end
