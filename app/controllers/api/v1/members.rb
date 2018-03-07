module API
  module V1
    class Members < Grape::API
      include API::V1::Defaults

      resource :members do
        desc 'Create new member'
        params do
          requires :client_member_id, desc: 'Your member ID', type: String, allow_blank: false
          requires :first_name, type: String, allow_blank: false
          requires :last_name, type: String, allow_blank: false
          requires :email, type: String, allow_blank: false
          requires :phone, type: String, allow_blank: false
          requires :date_of_birth, type: Date, allow_blank: false
          requires :gender, type: String, values: %w[M F], allow_blank: false
          requires :memberships,
                   type: Array,
                   desc: 'Membership begin and end dates and which of your locations a member belongs to.'\
                         'A membership with no ended_at is considered active and a member can only have one active membership' do
            requires :customer_location_id, type: String, desc: 'This is your location ID'
            requires :started_at, type: DateTime
            optional :ended_at, type: DateTime
          end
        end

        post '', root: :member do
          existing_members = Member.where(client_member_id: permitted_params[:client_member_id])
          existing_member = existing_members.present? ? policy_scope(existing_members) : nil
          error!({ error: :duplicate_record, detail: "Member with id #{permitted_params[:client_member_id]} already exists." }, 422) if existing_member && existing_member.count > 0

          member = Member.new(permitted_params.except(:memberships))
          permitted_params[:memberships].each do |membership_param|
            attrs = membership_param.except(:customer_location_id).merge(location: Location.find_by(customer_location_id: membership_param[:customer_location_id]))
            member.memberships << Membership.new(attrs)
          end
          authorize member, :create?
          member.save!

          member
        end

        desc 'Update member attributes.  Membership info cannot be changed with this endpoint'
        params do
          requires :client_member_id, type: String, allow_blank: false
          requires :first_name, type: String, allow_blank: false
          optional :last_name, type: String, allow_blank: false
          optional :email, type: String, allow_blank: false
          optional :phone, type: String, allow_blank: false
          optional :date_of_birth, type: Date, allow_blank: false
          optional :gender, type: String, values: %w[M F], allow_blank: false
        end

        put ':client_member_id' do
          member = Member.find_by(client_member_id: permitted_params[:client_member_id])
          error!({ error: :not_found, detail: "Member with id #{permitted_params[:client_member_id]} not found." }, 404) unless member

          authorize member, :update?
          member.attributes = permitted_params.to_hash.except('client_member_id')
          member.save!
        end

        desc 'Retrieve a member'
        params do
          requires :client_member_id, type: String, allow_blank: false, desc: 'Your member ID'
        end

        get ':client_member_id' do
          member = policy_scope(Member.includes(:memberships)).find_by(client_member_id: permitted_params[:client_member_id])
          error!({ error: :not_found, detail: "Member with id #{permitted_params[:client_member_id]} not found." }, 404) unless member
          member
        end
      end
    end
  end
end
