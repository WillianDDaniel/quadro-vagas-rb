require 'rails_helper'

RSpec.describe "BulkImport", type: :system do
  it "if user is not a admin should redirect to root path" do
    user = create(:user, role: :regular)
    bulk_import = build(:bulk_import,
      total_records: 100,
      processed_records: 52,
      success_records: 30,
      error_records: 22,
      status: :processing
    )
    bulk_import.file.attach(io: File.open('spec/support/files/text.txt'), filename: 'text.txt', content_type: 'text/plain')
    bulk_import.save

    login_as user

    visit bulk_import_path(bulk_import)

    expect(current_path).to eq root_path
  end

  it "user sees the bulk import", js: true do
    user = create(:user, role: :admin)

    bulk_import = build(:bulk_import,
      total_records: 100,
      processed_records: 52,
      success_records: 30,
      error_records: 22,
      status: :processing
    )
    bulk_import.file.attach(io: File.open('spec/support/files/text.txt'), filename: 'text.txt', content_type: 'text/plain')
    bulk_import.save

    login_as user
    visit bulk_import_path(bulk_import)

    within("#progress_bar") do
      expect(page).to have_content("100")
      expect(page).to have_content("52")
      expect(page).to have_content("30")
      expect(page).to have_content("22")
      expect(page).to have_content("48")
      expect(page).to have_content("52.0% Concluido")
      expect(page).to have_content("52 de 100")
    end
  end
end
