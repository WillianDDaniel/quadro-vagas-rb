class RemoveStatusFromCompanyProfilesAndJobPostings < ActiveRecord::Migration[8.0]
  def change
    remove_column :company_profiles, :status
    remove_column :job_postings, :status
  end
end
