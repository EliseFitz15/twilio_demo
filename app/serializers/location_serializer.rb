class LocationSerializer < ActiveModel::Serializer
  attributes :id, :customer_location_id, :name, :street_1, :street_2,
             :city, :state, :zip_code, :latitude, :longitude,
             :client_id
end
