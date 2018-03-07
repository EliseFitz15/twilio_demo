require 'administrate/base_dashboard'

class MembershipDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String,
    started_at: Field::DateTime,
    ended_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    member: Field::BelongsTo,
    location: Field::BelongsTo
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    member
    location
    id
    started_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    started_at
    ended_at
    created_at
    updated_at
    member
    location
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    member
    location
    started_at
    ended_at
  ].freeze

  # Overwrite this method to customize how memberships are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(membership)
  #   "Membership ##{membership.id}"
  # end
end
