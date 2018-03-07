require 'administrate/field/base'

class ConversationUrlField < Administrate::Field::Base
  include Rails.application.routes.url_helpers
  def url
    conversation_path(@resource)
  end
end
