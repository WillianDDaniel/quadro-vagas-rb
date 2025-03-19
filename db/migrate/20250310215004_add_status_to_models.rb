class AddStatusToModels < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :status, :integer, default: 0, null: false
    add_column :company_profiles, :status, :integer, default: 0, null: false
    add_column :job_postings, :status, :integer, default: 0, null: false
  end
end
