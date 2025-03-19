FactoryBot.define do
  factory :bulk_import do
    status { 0 }
    total_records { 0 }
    processed_records { 0 }
    success_records { 0 }
    error_records { 0 }
  end
end
