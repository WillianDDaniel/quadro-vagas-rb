class BulkImport < ApplicationRecord
  has_one_attached :file
  has_many :import_errors

  validates :file, presence: true
  validates :total_records, :processed_records, :success_records, :error_records, numericality: { greater_than_or_equal_to: 0 }

  validate :accept_only_csv_and_txt

  enum :status, { pending: 0, processing: 10, completed: 20, failed: 30 }, default: :pending

  after_commit :update_progress, on: :update
  after_create_commit :start_import

  def generate_report
    <<~REPORT
      #{I18n.t("bulk_imports.report.title", id: id)}
      #{'=' * 37}
      #{I18n.t("bulk_imports.report.creation_date", created_at: created_at.strftime("%d/%m/%Y %H:%M:%S"))}
      #{I18n.t("bulk_imports.report.file_name", file_name: file.filename)}

      #{I18n.t("bulk_imports.report.total_records", total_records: total_records)}
      #{I18n.t("bulk_imports.report.success_records", success_records: success_records)}
      #{I18n.t("bulk_imports.report.error_records", error_records: error_records)}
      #{I18n.t("bulk_imports.report.processed_records", processed_records: processed_records)}

      #{I18n.t("bulk_imports.report.final_status", status: human_status)}

      #{I18n.t("bulk_imports.report.errors_header")}
      #{import_errors.limit(10).map { |e| "#{I18n.t('bulk_imports.report.line', line_number: e.line_number)}: #{e.error_message}" }.join("\n")}
    REPORT
  end

  def human_status
    I18n.t("bulk_imports.statuses.#{status}")
  end

  private

  def update_progress
    broadcast_replace_to(
      "bulk_import_#{id}",
      target: "progress_bar",
      partial: "bulk_imports/progress",
      locals: { bulk_import: self }
    )
  end

  def accept_only_csv_and_txt
    return if file.blank? || file.content_type.blank?

    allowed_types = [ "text/csv", "text/plain" ]
    unless allowed_types.include?(file.content_type)
      errors.add(:file, "Only CSV and TXT files are allowed.")
    end
  end

  def start_import
    BulkImportJob.perform_later(id)
  end
end
