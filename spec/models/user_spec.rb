require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    context "presence" do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:email_address) }
      it { should validate_presence_of(:password) }

      it "validates presence of password_confirmation only when password is present" do
        user = build(:user, password: "password", password_confirmation: nil)
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("não pode ficar em branco")
      end
    end

    context 'uniqueness' do
      subject { create(:user) }
      it { should validate_uniqueness_of(:email_address).case_insensitive }
    end

    context 'length' do
      it { should validate_length_of(:password).is_at_least(6) }
    end

    context 'format' do
      it { should allow_value('user@example.com').for(:email_address) }
      it { should_not allow_value('userexample').for(:email_address) }
      it { should_not allow_value('user@example').for(:email_address) }
    end

    context 'comparison with company emails' do
      it "should not be equal to any company's contact email" do
        company_owner = create(:user)
        a_company_with_a_specific_email = create(:company_profile, contact_email: 'specific@email.com', user: company_owner)
        invalid_user = build(:user, email_address: a_company_with_a_specific_email.contact_email)

        expect(invalid_user).not_to be_valid
      end
    end
  end

  describe 'enum' do
    it { should define_enum_for(:role).with_values(regular: 0, admin: 10) }
    it { should define_enum_for(:status).with_values(active: 0, inactive: 1) }

    it "has default role as costumer" do
      user = User.new
      expect(user.role).to eq("regular")
    end

    it "has default status as active" do
      user = User.new
      expect(user.status).to eq("active")
    end
  end

  describe "#toggle_active!" do
  it "deactivates an active user" do
    user = build(:user)

    user.toggle_status!
    expect(user.reload.status).to eq "inactive"
  end

  it "activates a deactivated user" do
    user = build(:user)
    user.status = :inactive

    user.toggle_status!
    expect(user.reload.status).to eq "active"
  end
end
end
