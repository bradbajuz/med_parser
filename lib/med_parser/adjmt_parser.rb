require_relative 'fields'
require_relative 'file_handling'

module MedParser
  class AdjmtParser < FileHandling
    include Fields

    def adjmt_parser
      begingio
        original_data.each do |o_data|
          converted_data = []

          # Needed at beginning of array for each patient
          # Watch out for array that get inserted on last line that only includes below line of code
          adjmt_beginning_fields(converted_data)

          # BEGIN Check for nil in original data and replace with empty string
          nil_check(o_data)

          patient_account_number(converted_data, o_data)

          # Remove leading zeros from account number
          # This will fail if imported file has more than two empty lines

          # Only needed if  there are two leading zeros before D
          # converted_data[3].slice!(0..1)
          adjmt_remove_leading_zeros(converted_data)

          patient_amount_owed(converted_data, o_data)

          #Output data to final array
          final_data << converted_data
        end
      rescue => e
        puts '### ERROR ###'
        puts "Message:\n\t#{e.message}"
        puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        puts '### END ###'
        exit
      end
    end

    def run_adjmt_parser
      import_csv
      total_debtors
      remove_total
      adjmt_parser
      before_line_total
      export_adjmt_csv_file
      alert_gui
    end
  end
end