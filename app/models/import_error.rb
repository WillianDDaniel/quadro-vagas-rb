class ImportError < ApplicationRecord
  belongs_to :bulk_import

  validates :line_number, :error_message, presence: true
  validates :line_number, numericality: { greater_than: 0 }

  after_commit :update_import_error, on: :create

  private

  def update_import_error
    broadcast_replace_to(
      "bulk_import_#{bulk_import.id}",
      target: "errors",
      partial: "bulk_imports/errors",
      locals: { bulk_import: bulk_import }
    )
  end
end
