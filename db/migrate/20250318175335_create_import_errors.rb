class CreateImportErrors < ActiveRecord::Migration[8.0]
  def change
    create_table :import_errors do |t|
      t.text :error_message
      t.integer :line_number
      t.text :line_content
      t.references :bulk_import, null: false, foreign_key: true

      t.timestamps
    end
  end
end
