require_relative 'log_total'

module MedParser
  class Sanitize
    include LogTotal

    def total_debtors
      last_line_total << original_data.last.slice(0)
      line_total << last_line_total.slice(0).to_s
    end

    def remove_total
      # Remove last element in array that has total
      original_data.pop
    end
  end
end
