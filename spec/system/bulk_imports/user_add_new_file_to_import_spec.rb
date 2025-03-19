require 'rails_helper'

describe 'User adds new file to import', type: :system do
  it 'if user is not a admin should redirect to root path' do
    user = create(:user, role: :regular)
    login_as user

    visit new_bulk_import_path

    expect(current_path).to eq root_path
  end

  it 'should fail if user does not select a file' do
    user = create(:user, role: :admin)
    login_as user

    visit new_bulk_import_path

    click_on 'Importar'

    expect(page).to have_content 'Erro ao importar arquivo'
  end

  it 'succesfully' do
    user = create(:user, role: :admin)
    login_as user

    visit new_bulk_import_path

    attach_file "bulk_import[file]", Rails.root.join("spec/support/files/text.txt")

    click_on 'Importar'

    expect(page).to have_content 'Arquivo importado com sucesso'
  end
end
