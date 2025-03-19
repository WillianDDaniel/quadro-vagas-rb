require 'rails_helper'

RSpec.describe ImportError, type: :model do
  describe "#Valid?" do
    context "presence" do
      it { should validate_presence_of(:line_number) }
      it { should validate_presence_of(:error_message) }
    end

    context "numericality" do
      it { should validate_numericality_of(:line_number).is_greater_than(0) }
    end

    context "associations" do
      it { should belong_to(:bulk_import) }
    end
  end
end
