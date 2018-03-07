require 'rails_helper'

###
# We made some customizations to show the client in the index page.  Most of the testing
# of this page should be handled in the doorkeeper framework.  We're just trying to
# make sure our customizations work.
# ###
describe 'Applications Show', type: :system do
  let(:user) { create :user }
  let!(:client) { create :client }
  let(:client_selector) { 'body > div.container > div.row > div.col-md-8' }

  describe 'when the user is not logged in' do
    before do
      visit new_oauth_application_path
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
      visit new_oauth_application_path
    end

    describe 'Creating an application' do
      before do
        within('form') do
          fill_in('Name', with: 'Test App')
          fill_in('Redirect URI', with: 'urn:ietf:wg:oauth:2.0:oob')
          select(client.name, from: 'doorkeeper_application_owner_id')
          click_button 'Submit'
        end
      end

      it 'redirects to the show page of the created application' do
        expect(page).to have_current_path(oauth_application_path(Doorkeeper::Application.first))
      end

      it 'has the correct banner' do
        within 'body > div.container > div.alert.alert-info' do
          expect(page).to have_content('Application created')
        end
      end

      it 'shows the created application\'s name' do
        within('h1') do
          expect(page).to have_content(Doorkeeper::Application.first.name)
        end
      end

      it 'show\'s the client as the application owner' do
        within(client_selector) do
          client = Doorkeeper::Application.first.owner
          expect(page).to have_content(client.name)
        end
      end
    end

    describe 'Error handling' do
      before do
        fill_in('Name', with: 'Test App')
        fill_in('Redirect URI', with: 'urn:ietf:wg:oauth:2.0:oob')
        click_button 'Submit'
      end

      it 'does not create the application' do
        expect(Doorkeeper::Application.all).to be_empty
      end

      it 'stays on the create page' do
        expect(page).to have_current_path(oauth_applications_path)
      end

      it 'has an error banner at the top of the page' do
        within '#new_doorkeeper_application > div.alert.alert-danger > p' do
          expect(page).to have_content('Whoops! Check your form for possible errors')
        end
      end

      it 'has an error message associated with the control' do
        within '#fg_owner' do
          expect(page).to have_content('Can\'t be blank')
        end
      end
    end
  end
end
