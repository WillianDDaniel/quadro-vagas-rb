require 'rails_helper'

describe 'User tries to sign in', type: :system do
  it 'and failed because is inactive' do
    create(:user, email_address: 'user@user.com', status: :inactive)

    visit new_session_path

    fill_in 'email_address', with: 'user@user.com'
    fill_in 'password', with: 'password123'
    click_button 'Sign in'

    expect(current_path).to eq new_session_path
    expect(page).to have_content 'Try another email address or password.'
  end
end
