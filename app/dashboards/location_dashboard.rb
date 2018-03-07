require 'administrate/base_dashboard'

class LocationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    client: Field::BelongsTo,
    memberships: Field::HasMany,
    id: Field::String,
    customer_location_id: Field::String,
    name: Field::String,
    street_1: Field::String,
    street_2: Field::String,
    city: Field::String,
    state: Field::Select.with_options(collection: Location::STATES_BY_ABBR.values.insert(0, '')),
    zip_code: Field::String,
    latitude: Field::String,
    longitude: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    client
    id
    customer_location_id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    client
    id
    customer_location_id
    name
    street_1
    street_2
    city
    state
    zip_code
    latitude
    longitude
    created_at
    updated_at
    memberships
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    client
    customer_location_id
    name
    street_1
    street_2
    city
    state
    zip_code
    latitude
    longitude
  ].freeze

  # Overwrite this method to customize how locations are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(location)
    location.name
  end
end
