require_relative 'join_fields'
require_relative 'repeating_variables'

module Fields
  include JoinFields
  include RepeatingVariables

  # Regex
  PHONE = /(\d{3})(\d{3})(\d{4})/.freeze
  INCOMPLETE_PHONE = /\d/.freeze
  PATIENT_SSN = /(\d{3})(\d{2})(\d{4})/.freeze
  DOCTOR_NAME = /[\s,]/.freeze

  def beginning_fields(converted_data)
    converted_data.insert(0, 'Acvite', 'ACT')
  end

  def adjmt_beginning_fields(converted_data)
    converted_data.insert(0, '501', 'Adjustment per client', '3')
  end

  def nil_check(o_data)
    o_data.map! { |x| x || '' }
  end

  def patient_account_number(converted_data, o_data)
    converted_data << o_data.slice(0)
  end

  def remove_leading_zeros(converted_data)
    converted_data[2].slice!(1) if converted_data[2].slice(1) == '0'
  end

  def adjmt_remove_leading_zeros(converted_data)
    converted_data[3].slice!(1) if converted_data[3].slice(1) == '0'
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
    converted_data << if patient_phone.match(PHONE)
                        patient_phone.gsub(PHONE, '(\1) \2-\3')
                      elsif patient_phone.match('UNK')
                        patient_phone = '(UNK) - '
                      else
                        patient_phone = empty_phone
                      end
  end

  def patient_total(converted_data, o_data)
    patient_total = ''

    patient_total << o_data.slice(28)
    patient_total.to_i.abs

    converted_data << Money.new(patient_total).format(with_currency: false,
                                                      symbol: false,
                                                      thousands_separator: false)
  end

  def patient_amount_owed(converted_data, o_data)
    patient_total = ''
    patient_paid = ''

    patient_total << o_data.slice(28)

    patient_paid << o_data.slice(26)

    patient_owe = patient_total.to_i.abs - patient_paid.to_i.abs

    converted_data << Money.new(patient_owe).format(with_currency: false,
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
    converted_data << if insurance_phone.match(PHONE)
                        insurance_phone.gsub(PHONE, '(\1) \2-\3')
                      elsif insurance_phone.match('UNK')
                        insurance_phone = '(UNK) - '
                      elsif insurance_phone.match(INCOMPLETE_PHONE)
                        insurance_phone.gsub(PHONE, '(\1) \2-\3')
                      else
                        insurance_phone = empty_phone
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
    converted_data << if other_insurance_phone.match(PHONE)
                        other_insurance_phone.gsub(PHONE, '(\1) \2-\3')
                      elsif other_insurance_phone.match('UNK')
                        other_insurance_phone = '(UNK) - '
                      else
                        other_insurance_phone = empty_phone
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
    converted_data << if o_data.slice(167) == 'Y'
                        join_fields(o_data.slice(166..167))
                      else
                        o_data.slice(167)
                      end
  end
end