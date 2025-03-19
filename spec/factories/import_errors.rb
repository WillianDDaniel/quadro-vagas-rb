FactoryBot.define do
  factory :import_error do
    error_message { "Validation error" }
    line_number { 1 }
    line_content { "Line content" }
    association :bulk_import
  end
end
