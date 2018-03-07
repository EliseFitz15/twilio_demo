class VcardsController < ApplicationController
  skip_before_action :authenticate_user!

  def atlas
    respond_to do |format|
      format.vcard { render vcard: 'atlas' }
    end
  end
end
