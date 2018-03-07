class MemberSerializer < ActiveModel::Serializer
  attributes :id,
             :client_member_id,
             :first_name,
             :last_name,
             :email,
             :phone,
             :date_of_birth,
             :gender

  has_many :memberships
end
