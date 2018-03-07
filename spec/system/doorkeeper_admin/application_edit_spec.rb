require 'rails_helper'

###
# We made some customizations to show the client in the index page.  Most of the testing
# of this page should be handled in the doorkeeper framework.  We're just trying to
# make sure our customizations work.
# ###
describe 'Applications Show', type: :system do
  let(:user) { create :user }
  let!(:application) { create :application }
  let!(:different_client) { create :client }
  let(:client_selector) { 'body > div.container > div.row > div.col-md-8' }

  describe 'when the user is not logged in' do
    before do
      visit edit_oauth_application_path(application)
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
      visit edit_oauth_application_path(application)
    end

    describe 'Creating an application' do
      before do
        within('form') do
          select(different_client.name, from: 'doorkeeper_application_owner_id')
          click_button 'Submit'
        end
      end

      it 'redirects to the show page of the created application' do
        expect(page).to have_current_path(oauth_application_path(Doorkeeper::Application.first))
      end

      it 'has the correct banner' do
        within 'body > div.container > div.alert.alert-info' do
          expect(page).to have_content('Application updated')
        end
      end

      it 'show\'s updated client as the application owner' do
        within(client_selector) do
          client = Doorkeeper::Application.first.owner
          expect(page).to have_content(client.name)
        end
      end
    end
  end
end
