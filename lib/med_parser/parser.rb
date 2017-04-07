class MedParser
  require 'csv'
  require 'tk'
  require 'money'
  I18n.enforce_available_locales = false

  attr_accessor :original_data, :converted_data, :final_data

  def initialize
    @original_data = []
    @final_data = []
    @converted_data = converted_data
  end

# Regex
  PHONE = /(\d{3})(\d{3})(\d{4})/
  INCOMPLETE_PHONE = /\d/
  PATIENT_SSN = /(\d{3})(\d{2})(\d{4})/
  DOCTOR_NAME = /[\s,]/

  def import_csv(from_file = '*.csv')
    Dir.chdir '..'
    Dir.chdir 'convert'
    Dir.glob(from_file).each do |f|
      CSV.foreach(f, skip_blanks: true) do |raw_file|
        original_data << raw_file
      end
    end
  end

  def filename
    Dir.chdir '..'
    Dir.chdir 'convert'
    Dir.glob('*.csv').join('')
  end

  def total_debtors
    last_line_total = []
    line_total = ''

    last_line_total << original_data.last.slice(0)
    line_total << last_line_total.slice(0).to_s
  end

  def remove_total
    # Remove last element in array that has total
    original_data.pop
  end

  def join_fields(data)
    data.join(' ')
  end

  def reoccurring_variables
    empty_space = ' '
    number_four = '4'
    empty_phone = '( ) - '
    return empty_phone, empty_space, number_four
  end

  def beginning_fields(converted_data)
    converted_data.insert(0, 'Acvite', 'ACT')
  end

  def nil_check(o_data)
    o_data.map! { |x| x ? x : '' }
  end

  def patient_account_number(converted_data, o_data)
    converted_data << o_data.slice(0)
  end

  def remove_leading_zeros(converted_data)
    converted_data[2].slice!(1) if converted_data[2].slice(1) == '0'
  end

  def patient_name(o_data, converted_data)
    patient_name_array = []

    patient_name_array << o_data.slice(3..4)
    converted_data << join_fields(patient_name_array)
  end

  def patient_address(o_data, converted_data)
    patient_address_array = []

    patient_address_array << o_data.slice(5)
    converted_data << join_fields(patient_address_array)
  end

  def empty_field(converted_data, o_data)
    converted_data << o_data.slice(6)
  end

  def patient_city(converted_data, o_data)
    converted_data << o_data.slice(8)
  end

  def patient_state(converted_data, o_data)
    converted_data << o_data.slice(9)
  end

  def patient_zipcode(converted_data, o_data)
    converted_data << o_data.slice(10)
  end

  def eight_digit_string(converted_data, o_data)
    converted_data << o_data.slice(11)
  end

  def patient_ssn(converted_data, o_data)
    patient_ssn = ''

    patient_ssn << o_data.slice(12)
    if patient_ssn.empty?
      converted_data << patient_ssn = ' - - '
    elsif patient_ssn.length == 8
      patient_ssn.insert(0, '0')
      converted_data << patient_ssn.gsub(PATIENT_SSN, '\1-\2-\3')
    else
      converted_data << patient_ssn.gsub(PATIENT_SSN, '\1-\2-\3')
    end
  end

  def patient_phone_number(converted_data, empty_phone, o_data)
    patient_phone = ''

    patient_phone << o_data.slice(13)
    if patient_phone.match(PHONE)
      converted_data << patient_phone.gsub(PHONE, '(\1) \2-\3')
    elsif patient_phone.match('UNK')
      converted_data << patient_phone = '(UNK) - '
    else
      converted_data << patient_phone = empty_phone
    end
  end

  def patient_total(converted_data, o)
    patient_total = ''

    patient_total << o.slice(28)
    patient_total.to_i.abs

    converted_data << Money.new(patient_total).format(with_currency: false,
                                                      symbol: false,
                                                      thousands_separator: false)
  end

  def eight_digit_numbers(converted_data, o_data)
    converted_data << o_data.slice(29)
    converted_data << o_data.slice(30)
  end

  def insert_four(converted_data, number_four)
    converted_data.insert(-1, number_four)
  end

  def insurance_name(converted_data, o_data)
    converted_data << o_data.slice(48)
  end

  def insurance_address(converted_data, o_data)
    converted_data << o_data.slice(49)
  end

  def insurance_empty_field(converted_data, o_data)
    converted_data << o_data.slice(50)
  end

  def insurance_alt_address(converted_data, o_data)
    insurance_address = []

    insurance_address << o_data.slice(51..53)
    converted_data << join_fields(insurance_address)
  end

  def insurance_phone_number(converted_data, empty_phone, o_data)
    insurance_phone = ''

    insurance_phone << o_data.slice(54)
    if insurance_phone.match(PHONE)
      converted_data << insurance_phone.gsub(PHONE, '(\1) \2-\3')
    elsif insurance_phone.match('UNK')
      converted_data << insurance_phone = '(UNK) - '
    elsif insurance_phone.match(INCOMPLETE_PHONE)
      converted_data << insurance_phone.gsub(PHONE, '(\1) \2-\3')
    else
      converted_data << insurance_phone = empty_phone
    end
  end

  def claim_number_one(converted_data, o_data)
    converted_data << o_data.slice(56)
  end

  def claim_number_two(converted_data, o_data)
    converted_data << o_data.slice(57)
  end

  def secondary_insurance_name(converted_data, o_data)
    converted_data << o_data.slice(59)
  end

  def secondary_insurance_address(converted_data, o_data)
    converted_data << o_data.slice(60)
  end

  def secondary_insurance_empty_field(converted_data, o_data)
    converted_data << o_data.slice(61)
  end

  def secondary_alt_insurance_address(converted_data, o_data)
    insurance_address = []

    insurance_address << o_data.slice(62..64)
    converted_data << join_fields(insurance_address)
  end

  def secondary_insurance_phone(converted_data, empty_phone, o_data)
    other_insurance_phone = ''

    other_insurance_phone << o_data.slice(65)
    if other_insurance_phone.match(PHONE)
      converted_data << other_insurance_phone.gsub(PHONE, '(\1) \2-\3')
    elsif other_insurance_phone.match('UNK')
      converted_data << other_insurance_phone = '(UNK) - '
    else
      converted_data << other_insurance_phone = empty_phone
    end
  end

  def other_number(converted_data, o_data)
    converted_data << o_data.slice(67)
  end

  def other_insurance_number(converted_data, o_data)
    converted_data << o_data.slice(68)
  end

  def insert_dr_info(converted_data)
    converted_data << 'Dr Info'
  end

  def dx_and_ailment(converted_data, o_data)
    converted_data << join_fields(o_data.slice(132..133))
  end

  def hcpcs_codes(converted_data, o_data)
    converted_data << join_fields(o_data.slice(134..143)).strip
  end

  def doctors_name(converted_data, o_data)
    converted_data << o_data.slice(144).gsub(DOCTOR_NAME, ' ')

    doctor_name = ''
    doctor_name << o_data.slice(146..147).join('')
    converted_data << doctor_name.gsub(DOCTOR_NAME, ' ')
  end

  def other_doctor_name(converted_data, o_data)
    converted_data << o_data.slice(149)
  end

  def numbered_data(converted_data, o_data)
    numbered_data = []
    numbered_data << join_fields(o_data.slice(152..159))
    converted_data.concat(numbered_data)
  end

  def insurance_present(converted_data, o_data)
    if o_data.slice(167) == 'Y'
      converted_data << join_fields(o_data.slice(166..167))
    else
      converted_data << o_data.slice(167)
    end
  end

  def parser_script
    original_data.each do |o_data|
      converted_data = []

      empty_phone, empty_space, number_four = reoccurring_variables

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

  def export_csv_file(to_file="#{filename}")
    Dir.chdir '..'
    Dir.chdir 'converted'
    File.open(to_file, 'w') do |f|
      f.write(final_data.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join(''))
    end
  end

  def launch_adjmt_parser
    # Bring in adjustment script and run
    Dir.chdir '..'
    Dir.chdir 'lib'
    load 'med_parser/adjmt_parser.rb'
  end

  def run_convert
    import_csv
    filename
    total_debtors
    remove_total
    parser_script
    export_csv_file
    launch_adjmt_parser
  end
end

new_convert = MedParser.new
new_convert.run_convert