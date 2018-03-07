require 'rails_helper'

describe 'Login', type: :system do
  let(:user) { create :user }

  describe 'sthe admin site should require login' do
    it 'makes you log in to access a proteccted page' do
      visit admin_users_path
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'shoulds allow you to access a protected page when you are signed in' do
      sign_in user
      visit admin_users_path
      expect(page).to have_current_path(admin_users_path)
    end
  end
  describe 'navigate directly to protected page' do
    before do
      sign_in user
      visit admin_users_path
    end

    it 'shows the user\'s email on the page' do
      expect(page).to have_content user.email
    end
  end
end
