require 'rails_helper'

RSpec.describe BulkImportJob, type: :job do
  it 'should perform a job after create a bulk import and enqueue jobs for each line' do
    file_content = <<~TXT
      U, lana@mckenzie.example, Stepanie, Beer
      U, arminda_kohler@schowalter-bernier.example, Esmeralda, Reichert
      E, Business Company, https://websitesss.com, business252@website.com, 1
      V, Desenvolvedor Frontend, some description, 6000, BRL, Mensal, Remoto, 2, Remoto, 1, 2
      U, jonathan@donnelly.example, Jonathan, Donnelly
    TXT

    bulk_import = build(:bulk_import)

    bulk_import.file.attach(io: StringIO.new(file_content), filename: 'text.txt', content_type: 'text/plain')
    bulk_import.save!

    file = bulk_import.file.download
    lines = file.split("\n").map(&:strip).reject(&:empty?)

    total_lines = lines.size

    bulk_import.update!(total_records: total_lines, processed_records: 0, success_records: 0, error_records: 0)

    redis_key = "bulk_import_#{bulk_import.id}_progress"
    $redis.set(redis_key, 0)

    process_jobs = lines.map { |line| ProcessBulkImportJob.new(bulk_import, line, redis_key) }

    ActiveJob.perform_all_later(process_jobs)

    expect {
      perform_enqueued_jobs
    }.to have_performed_job(ProcessBulkImportJob).exactly(5).times
  end
end
