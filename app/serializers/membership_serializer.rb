class MembershipSerializer < ActiveModel::Serializer
  attributes :id,
             :started_at,
             :ended_at,
             :client_member_id,
             :customer_location_id

  def client_member_id
    object.member.client_member_id
  end

  def customer_location_id
    object.location.customer_location_id
  end
end
