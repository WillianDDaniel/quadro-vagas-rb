require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  context "#Valid?" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:salary) }
    it { should validate_presence_of(:salary_currency) }
    it { should validate_presence_of(:salary_period) }
    it { should validate_presence_of(:work_arrangement) }
    it { should validate_presence_of(:description) }
    it { should belong_to :company_profile }
    it { should belong_to :job_type }
    it { should belong_to :experience_level }
  end

  context 'status' do
    it "should be active if company is active" do
      user = create(:user, status: :active)
      company = create(:company_profile, user: user)
      job_posting = create(:job_posting, company_profile: company)
      expect(job_posting.status).to eq("active")
    end

    it "should be inactive if company is inactive" do
      user = create(:user, status: :inactive)
      company = create(:company_profile, user: user)
      job_posting = create(:job_posting, company_profile: company)
      expect(job_posting.status).to eq("inactive")
    end
  end
end
