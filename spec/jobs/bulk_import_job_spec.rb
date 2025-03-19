require 'rails_helper'

RSpec.describe BulkImportJob, type: :job do
  it 'should perform a job after create a bulk import and enqueue jobs for each line' do
    file_content = <<~TXT
      U, arminda_kohler@schowalter-bernier.example, Esmeralda, Reichert
      U, lana@mckenzie.example, Stepanie, Beer
      U, lyndon@torphy-crooks.example, Eddy, Torphy
      U, morton.berge@pagac.example, Mandi, Prohaska
      U, cindy@stoltenberg-wilderman.example, Francesco, Purdy
      U, arminda_kohler@schowalter-bernier.example, Esmeralda, Reichert
    TXT

    bulk_import = build(:bulk_import)

    bulk_import.file.attach(io: StringIO.new(file_content), filename: 'text.txt', content_type: 'text/plain')
    bulk_import.save!

    expect {
      perform_enqueued_jobs
    }.to have_performed_job(BulkImportJob).exactly(1).times

    expect {
      perform_enqueued_jobs
    }.to have_performed_job(ProcessBulkImportJob).exactly(6).times
  end

  it 'should not enqueue jobs if the file is empty' do
    file_content = <<~TXT

    TXT

    bulk_import = build(:bulk_import)

    bulk_import.file.attach(io: StringIO.new(file_content), filename: 'text.txt', content_type: 'text/plain')
    bulk_import.save!

    expect {
      perform_enqueued_jobs
    }.to have_performed_job(BulkImportJob).exactly(1).times

    expect {
      perform_enqueued_jobs
    }.to have_performed_job(ProcessBulkImportJob).exactly(0).times
  end
end
