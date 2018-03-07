module API
  module V1
    class Locations < Grape::API
      include API::V1::Defaults

      resource :locations do
        desc 'Return all locations'
        get '', root: :locations do
          policy_scope(Location.all)
        end

        desc 'Create new location'
        params do
          requires :customer_location_id, type: String, allow_blank: false, desc: 'Your location ID'
          requires :name, type: String, allow_blank: false, desc: 'The name of the location'
          requires :street_1, type: String, allow_blank: false
          optional :street_2, type: String, allow_blank: true
          requires :city, type: String, allow_blank: false
          requires :state, type: String, allow_blank: false, values: Location::STATES_BY_ABBR.values
          requires :zip_code, type: String, allow_blank: false
          requires :latitude, type: Float, allow_blank: false
          requires :longitude, type: Float, allow_blank: false
        end
        post '', root: :locations do
          Location.create!(
            customer_location_id: params[:customer_location_id],
            name: params[:name],
            street_1: params[:street_1],
            street_2: params[:street_2],
            city: params[:city],
            state: params[:state],
            zip_code: params[:zip_code],
            latitude: params[:latitude],
            longitude: params[:longitude],
            client: current_client
          )
        end

        desc 'Updates location information'
        params do
          requires :customer_location_id
          optional :state, type: String, values: Location::STATES_BY_ABBR.values
        end
        put '', root: :locations do
          location = Location.find_by(customer_location_id: params[:customer_location_id])
          location.update!(
            customer_location_id: params[:customer_location_id],
            name: params[:name],
            street_1: params[:street_1],
            street_2: params[:street_2],
            city: params[:city],
            state: params[:state],
            zip_code: params[:zip_code],
            latitude: params[:latitude],
            longitude: params[:longitude],
            client: current_client
          )
        end
      end
    end
  end
end
