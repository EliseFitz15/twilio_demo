require 'rails_helper'

describe InteractionsController, type: :system do
  let(:user) { create :user }

  before do
    sign_in user
    visit root_path

    fill_in 'first_name', with: 'First'
    fill_in 'last_name', with: 'Last'
    fill_in 'phone', with: '+11234567890'
  end

  it 'user does not fill in form properly' do
    fill_in 'first_name', with: ''
    fill_in 'last_name', with: ''
    fill_in 'phone', with: ''

    click_on 'Join'

    expect(page).to have_content('First name can\'t be blank. Last name can\'t be blank. Phone can\'t be blank. Phone is too short (minimum is 10 characters)')
  end

  it 'user fills in form and initiates join flow' do
    click_on 'Join'

    expect(page).to have_content('Join SMS sent to +11234567890')
  end

  it 'expects the following join message was sent' do
    click_on 'Join'

    expect(FakeSMS.messages.last.body).to start_with(
      "You rock First. Welcome to the Rockland Club. My name is Atlas. I'm here to help you get the most out of your gym membership."
    )
  end

  it 'expects the following message had a vcard attached' do
    click_on 'Join'

    expect(FakeSMS.messages.last.media_url[1]).to match(/.vcard/)
  end

  it 'expects the following message had a gif attached' do
    click_on 'Join'

    expect(FakeSMS.messages.last.media_url[0]).to match(/.gif/)
  end

  it 'user fills in form and initiates visit flow' do
    click_on 'Visit'

    expect(page).to have_content('Visit SMS sent to +11234567890')
  end

  it 'expects the following visit message was sent if not first timer or we no join flow was completed' do
    click_on 'Visit'

    expect(FakeSMS.messages.last.body).to eql(
      "Strong work at the gym today, First! \n \nI'll keep track of your visits for you. How many days a week do you plan on going to the gym?"
    )
  end

  it 'when first time gym goer visits expects visit message to start with' do
    member = create(:member, :with_active_membership, phone: '+11234567890')
    create(:interaction, :with_full_conversation, member: member)
    click_on 'Visit'

    expect(FakeSMS.messages.last.body).to start_with("Getting started in the gym can be an intimidating experience, so your're a rock star just for showing up! 💪 ")
  end
end
