module API
  module V1
    class Memberships < Grape::API
      include API::V1::Defaults

      resource :members do
        desc 'Create a membership for a member.  A member can only have one membership record that is active (null ended_at)'
        params do
          requires :client_member_id, desc: 'Your member ID', type: String, allow_blank: false
          requires :customer_location_id, type: String, desc: 'This is your location ID that the member belongs to'
          requires :started_at, type: DateTime, desc: 'The date the membership started'
          optional :ended_at, type: DateTime, desc: 'The date the membership ended'
        end
        post ':client_member_id/memberships', root: :member do
          member = Member.find_by(client_member_id: permitted_params[:client_member_id])
          error!({ error: :not_found, detail: "Member with id #{permitted_params[:client_member_id]} not found." }, 404) unless member

          location = Location.find_by(customer_location_id: permitted_params[:customer_location_id])
          error!({ error: :not_found, detail: "Location with id #{permitted_params[:customer_location_id]} not found." }, 404) unless location

          params = permitted_params.except(:client_member_id, :customer_location_id).merge(member: member, location: location)
          membership = Membership.new(params)
          authorize membership, :create?
          membership.save!
          membership
        end

        desc 'Cancels the active membership of the specified member'
        params do
          requires :client_member_id, desc: 'Your member ID', type: String, allow_blank: false
        end
        put ':client_member_id/memberships/cancel', root: :member do
          member = Member.includes(:memberships).find_by(client_member_id: permitted_params[:client_member_id])
          error!({ error: :not_found, detail: "Member with id #{permitted_params[:client_member_id]} not found." }, 404) unless member
          active_membership = member.active_membership
          error!({ error: :no_active_membership, detail: "Member with id #{permitted_params[:client_member_id]} does not have an active membership to cancel." }, 422) unless active_membership
          authorize active_membership, :update?
          active_membership.cancel
          active_membership # that is now canceled
        end

        desc 'Retrieves the memberships for member'
        params do
          requires :client_member_id, desc: 'Your member ID', type: String, allow_blank: false
        end
        get ':client_member_id/memberships', root: :member do
          member = policy_scope(Member.includes(:memberships)).find_by(client_member_id: permitted_params[:client_member_id])
          error!({ error: :not_found, detail: "Member with id #{permitted_params[:client_member_id]} not found." }, 404) unless member
          policy_scope(member.memberships)
        end
      end
    end
  end
end
