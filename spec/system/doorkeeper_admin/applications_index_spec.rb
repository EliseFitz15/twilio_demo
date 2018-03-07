require 'rails_helper'

###
# We made some customizations to show the client in the index page.  Most of the testing
# of this page should be handled in the doorkeeper framework.  We're just trying to
# make sure our customizations work.
# ###
describe 'Applications Index', type: :system do
  let(:user) { create :user }
  let!(:application) { create :application }
  let(:application_row_selector) { "#application_#{application.id}" }

  describe 'when the user is not logged in' do
    before do
      visit oauth_applications_path
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
      visit oauth_applications_path
    end

    it 'has the application name in the first column' do
      within(application_row_selector) do
        expect(all('td')[0].text).to eq(application.name)
      end
    end

    it 'shows the client name in the second column' do
      within(application_row_selector) do
        expect(all('td')[1].text).to eq(application.owner.name)
      end
    end
  end
end
