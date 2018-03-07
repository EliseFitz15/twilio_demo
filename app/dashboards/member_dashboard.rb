require 'administrate/base_dashboard'

class MemberDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    memberships: Field::HasMany,
    id: Field::String,
    client_member_id: Field::String,
    first_name: Field::String,
    last_name: Field::String,
    email: Field::String,
    phone: Field::String,
    date_of_birth: Field::DateTime,
    gender: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    first_name
    last_name
    phone
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    client_member_id
    first_name
    last_name
    email
    phone
    date_of_birth
    gender
    created_at
    updated_at
    memberships
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    memberships
    client_member_id
    first_name
    last_name
    email
    phone
    date_of_birth
    gender
  ].freeze

  # Overwrite this method to customize how members are displayed
  # across all pages of the admin dashboard.

  def display_resource(member)
    member.full_name
  end
end
