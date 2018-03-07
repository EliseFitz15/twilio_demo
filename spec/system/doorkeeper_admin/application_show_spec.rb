require 'rails_helper'

###
# We made some customizations to show the client in the index page.  Most of the testing
# of this page should be handled in the doorkeeper framework.  We're just trying to
# make sure our customizations work.
# ###
describe 'Applications Show', type: :system do
  let(:user) { create :user }
  let!(:application) { create :application }
  let(:client_selector) { 'body > div.container > div.row > div.col-md-8' }

  describe 'when the user is not logged in' do
    before do
      visit oauth_application_path(application)
    end

    it 'redirects you to the signin page' do
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'shows an error message on the page' do
      within('#root > div.alert.alert-danger') do
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end
  describe 'when user logged in' do
    before do
      sign_in user
      visit oauth_application_path(application)
    end

    it 'shows the client ' do
      within(client_selector) do
        expect(page).to have_content('Client')
      end
    end

    it 'shows the client name ' do
      within(client_selector) do
        expect(page).to have_content(application.owner.name)
      end
    end
  end
end
