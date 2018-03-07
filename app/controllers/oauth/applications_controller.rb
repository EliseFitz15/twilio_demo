# app/controllers/oauth/applications_controller.rb
module Oauth
  class ApplicationsController < Doorkeeper::ApplicationsController
    before_action :authenticate_user!

    def create
      @application = Doorkeeper::Application.new(application_params)
      if @application.save
        flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications create])
        redirect_to oauth_application_url(@application)
      else
        render :new
      end
    end

    private

    def application_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes, :owner_id, :owner_type)
    end
  end
end
