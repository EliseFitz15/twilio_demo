require 'rails_helper'

describe InteractionsController, type: :system do
  let(:user) { create :user }
  let!(:interaction) { create :interaction, :with_full_conversation }

  before do
    sign_in user
    visit admin_interactions_path
  end

  it 'has a view link on the admin interactions page' do
    expect(page).to have_link('View')
  end

  describe 'View Conversation Page' do
    before do
      click_link 'View'
    end

    it 'brings you to the view conversation page when you click the view link' do
      expect(page).to have_current_path(conversation_path(Interaction.first))
    end

    it 'has a title that reflects the type of coversations' do
      within('h2') do
        expect(page).to have_content('SMS Join Conversation with MyString')
      end
    end

    it 'shows the correct first message' do
      within('.conversation > div:nth-child(1)') do
        expect(page).to have_content(interaction.conversation['1']['body'])
      end
    end

    it 'shows the first message as coming from us' do
      text_bubble = find('.conversation > div:nth-child(1)')
      expect(text_bubble['class']).to include('ours')
    end

    it 'shows the correct second message' do
      within('.conversation > div:nth-child(2)') do
        expect(page).to have_content(interaction.conversation['2']['body'])
      end
    end

    it 'shows the second message as coming from the member' do
      text_bubble = find('.conversation > div:nth-child(2)')
      expect(text_bubble['class']).to include('theirs')
    end

    it 'shows the correct third message' do
      within('.conversation > div:nth-child(3)') do
        expect(page).to have_content(interaction.conversation['3']['body'])
      end
    end

    it 'shows the third message as coming from us' do
      text_bubble = find('.conversation > div:nth-child(3)')
      expect(text_bubble['class']).to include('ours')
    end
  end
end
