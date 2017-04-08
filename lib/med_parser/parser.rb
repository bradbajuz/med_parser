require_relative 'fields'
require_relative 'file_handling'

module MedParser
  class Parser < FileHandling
    include Fields
    require 'csv'
    require 'tk'
    require 'money'
    I18n.enforce_available_locales = false

    def parser
      original_data.each do |o_data|
        converted_data = []

        empty_phone, empty_space, number_four = repeating_variables

        # Needed at beginning of array for each patient
        # Watch out for array that get inserted on last line that only includes below line of code
        beginning_fields(converted_data)

        # BEGIN Check for nil in original data and replace with empty string
        nil_check(o_data)

        patient_account_number(converted_data, o_data)

        # Remove leading zeros from account number
        # This will fail if imported file has more than two empty lines
        # Only needed if  there are two leading zeros before D
        # converted_data[2].slice!(0..1)
        remove_leading_zeros(converted_data)

        patient_name(o_data, converted_data)

        patient_address(o_data, converted_data)

        # Usually empty
        empty_field(converted_data, o_data)

        patient_city(converted_data, o_data)

        patient_state(converted_data, o_data)

        patient_zipcode(converted_data, o_data)

        eight_digit_string(converted_data, o_data)

        patient_ssn(converted_data, o_data)

        patient_phone_number(converted_data, empty_phone, o_data)

        patient_total(converted_data, o_data)

        eight_digit_numbers(converted_data, o_data)

        insert_four(converted_data, number_four)

        insurance_name(converted_data, o_data)

        insurance_address(converted_data, o_data)

        # Usually empty
        insurance_empty_field(converted_data, o_data)

        insurance_alt_address(converted_data, o_data)

        insurance_phone_number(converted_data, empty_phone, o_data)

        # Claim number? (Sometimes empty)
        claim_number_one(converted_data, o_data)

        # Second claim number or insurance number?
        claim_number_two(converted_data, o_data)

        insert_four(converted_data, number_four)

        secondary_insurance_name(converted_data, o_data)

        secondary_insurance_address(converted_data, o_data)

        secondary_insurance_empty_field(converted_data, o_data)

        secondary_alt_insurance_address(converted_data, o_data)

        secondary_insurance_phone(converted_data, empty_phone, o_data)

        other_number(converted_data, o_data)

        other_insurance_number(converted_data, o_data)

        insert_four(converted_data, number_four)

        # Other usually empty

        4.times do
          insert_four(converted_data, empty_space)
        end
        insert_four(converted_data, empty_phone)

        2.times do
          insert_four(converted_data, empty_space)
        end

        insert_four(converted_data, number_four)

        insert_dr_info(converted_data)

        dx_and_ailment(converted_data, o_data)

        hcpcs_codes(converted_data, o_data)

        doctors_name(converted_data, o_data)

        other_doctor_name(converted_data, o_data)

        numbered_data(converted_data, o_data)

        insurance_present(converted_data, o_data)

        # Output data to final array
        final_data << converted_data
      end
    end

    def run_parser
      import_csv
      filename
      total_debtors
      remove_total
      parser
      export_csv_file
    end
  end
end