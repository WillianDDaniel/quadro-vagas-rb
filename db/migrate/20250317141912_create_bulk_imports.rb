class CreateBulkImports < ActiveRecord::Migration[8.0]
  def change
    create_table :bulk_imports do |t|
      t.integer :status, default: 0
      t.integer :total_records, default: 0
      t.integer :processed_records, default: 0
      t.integer :success_records, default: 0
      t.integer :error_records, default: 0

      t.timestamps
    end
  end
end
