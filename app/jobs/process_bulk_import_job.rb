class ProcessBulkImportJob < ApplicationJob
  queue_as :low_priority

  def perform(bulk_import, line_data, redis_key)
    current_count = $redis.incr(redis_key)
    bulk_import.update!(processed_records: current_count)

    begin
      process_records(line_data)

      bulk_import.increment!(:success_records)
    rescue StandardError => e
      bulk_import.increment!(:error_records)

      ImportError.create!(
        bulk_import: bulk_import,
        error_message: e.message,
        line_content: line_data,
        line_number: current_count
      )
    end
  end

  private

  def process_records(line_data)
    parts = line_data.split(",").map(&:strip)
    record_indicator = parts.shift.downcase

    case record_indicator
    when "u"
      data = prepare_user_data(parts)
      User.create!(data)
    when "e"
      data = prepare_company_data(parts)
      CompanyProfile.create!(data)
    when "v"
      data = correct_data(parts)
      prepared_data = prepare_job_posting_data(data)
      JobPosting.create!(prepared_data)
    else
      raise StandardError, I18n.t(".process_bulk_imports.unknown_type", record_indicator: record_indicator)
    end
  end

  def prepare_user_data(data)
    raise StandardError, I18n.t(".process_bulk_imports.invalid_user_format") unless data.size == 3

    password = SecureRandom.alphanumeric(6)

    {
      email_address: data[0],
      name: data[1],
      last_name: data[2],
      password: password,
      password_confirmation: password
    }
  end

  def prepare_company_data(data)
    raise StandardError, I18n.t(".process_bulk_imports.invalid_company_format") unless data.size == 4
    {
      name: data[0],
      website_url: data[1],
      contact_email: data[2],
      user_id: data[3].to_i
    }
  end

  def prepare_job_posting_data(data)
    raise StandardError, I18n.t(".process_bulk_imports.invalid_job_format") unless data.size == 9 || data.size == 10
    {
      title: data[0],
      description: data[1],
      salary: data[2].to_i,
      salary_currency: data[3].to_i,
      salary_period: data[4].to_i,
      work_arrangement: data[5].to_i,
      job_type_id: data[6].to_i,
      job_location: data[6] == 0 ? nil : data[7],
      experience_level_id: data[8].to_i,
      company_profile_id: data[9].to_i
    }
  end

  def correct_data(fields)
    fields[3] = case fields[3].downcase
    when "brl" then "20"
    when "usd" then "0"
    when "eur" then "10"
    else fields[3]
    end

    fields[4] = case fields[4].downcase
    when "diário" then "0"
    when "diario" then "0"
    when "semanal" then "10"
    when "mensal" then "20"
    when "anual" then "30"
    else fields[4]
    end

    fields[5] = case fields[5].downcase
    when "presencial" then "20"
    when "remoto" then "0"
    when "híbrido" then "10"
    when "hibrido" then "10"
    else fields[5]
    end

    fields
  end
end
