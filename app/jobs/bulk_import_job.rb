class BulkImportJob < ApplicationJob
  queue_as :default

  def perform(bulk_import_id)
    bulk_import = BulkImport.find_by(id: bulk_import_id)

    bulk_import.update!(status: "processing")

    file = bulk_import.file.download
    lines = file.split("\n").map(&:strip).reject(&:empty?)

    total_lines = lines.size

    bulk_import.update!(total_records: total_lines, processed_records: 0, success_records: 0, error_records: 0)

    redis_key = "bulk_import_#{bulk_import.id}_progress"
    $redis.set(redis_key, 0)

    process_jobs = lines.map { |line| ProcessBulkImportJob.new(bulk_import, line, redis_key) }

    ActiveJob.perform_all_later(process_jobs)
  rescue StandardError => e
    bulk_import.update!(status: "failed")
  end
end
