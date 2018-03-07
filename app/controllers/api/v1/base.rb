require 'grape-swagger'
require 'doorkeeper/grape/helpers'

module API
  module V1
    class Base < Grape::API
      include Pundit

      helpers Doorkeeper::Grape::Helpers
      helpers Pundit
      helpers do
        def current_client
          doorkeeper_token.application.owner
        end

        def current_user
          current_client
        end
      end

      before do
        doorkeeper_authorize!
      end

      mount API::V1::Locations
      mount API::V1::Members
      mount API::V1::Memberships

      add_swagger_documentation(
        title: 'Atlas API',
        description: 'API endpoints to push data into the Atlas platform',
        format: :json,
        api_version: 'v1',
        hide_documentation_path: true,
        mount_path: '/api/v1/swagger_doc',
        hide_format: true
      )

      def pundit_user
        current_client
      end
    end
  end
end
