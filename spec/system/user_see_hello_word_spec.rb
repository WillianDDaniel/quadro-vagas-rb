require 'rails_helper'

describe 'User see hello word', type: :system, js: true do
  it 'successfully' do
    visit root_path
    sleep(1)
    expect(page).to have_content('Hello World!')
  end
end
