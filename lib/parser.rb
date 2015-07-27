require 'csv'

#Regex
PHONE = /(\d{3})(\d{3})(\d{4})/
INCOMPLETE_PHONE = /\d/
PATIENT_SSN = /(\d{3})(\d{2})(\d{3})/
DOCTOR_NAME = /[\s,]/

original_data = Array.new
final_data = Array.new

Dir.chdir '..'
Dir.chdir 'convert'
filename = Dir.glob('*.csv').each do |f|
  CSV.foreach(f) do |raw_file| 
    original_data << raw_file
  end
end

# Remove last element in array that has unneded data
# Expecting up to 1 blank line and last line with total or just line with total
# Broken if not meeting above rquirements.
if original_data.last.empty?
  original_data.pop(2)
else
  original_data.pop
end

# Start processing fields
original_data.each do |o|
  converted_data = Array.new

  # Setup reoccurring variables
  empty_space = ' '
  number_four = '4'
  empty_phone = '( ) - '

  # Needed at beginning of array for each patient
  # Watch out for array that get inserted on last line that only includes below line of code
  converted_data.insert(0, 'Acvite', 'ACT')

  # BEGIN Check for nil in original data and replace with empty string
  o.map! { |x| x ? x : ''}

  # Add in account number
  converted_data << o.slice(0)

  # Remove leading zeros from account number
  # This will fail if imported file has more than two empty lines

  # Only needed if  there are two leading zeros before D
  # converted_data[2].slice!(0..1)

  if converted_data[2].slice(1) == '0'
    converted_data[2].slice!(1)
  end

  # Setup patient name to be processed
  patient_name = Array.new
  
  patient_name << o.slice(3..4)
  converted_data << patient_name.join(' ')

  # Setup patient address to be processed
  patient_address = Array.new

  patient_address << o.slice(5)
  converted_data << patient_address.join(' ')

  # Usually empty
  converted_data << o.slice(6)

  # City
  converted_data << o.slice(8)

  # State
  converted_data << o.slice(9)

  # Zip
  converted_data << o.slice(10)

  # 8 digit string
  converted_data << o.slice(11)

  # SSN
  patient_ssn = ''

  patient_ssn << o.slice(12)
  if patient_ssn.empty?
    converted_data << patient_ssn = ' - - '
  else
    converted_data << patient_ssn.gsub(PATIENT_SSN, '\1-\2-\3')
  end
  
  # Phone number
  patient_phone = ''

  patient_phone << o.slice(13)
  if patient_phone.match(PHONE)
    converted_data << patient_phone.gsub(PHONE, '(\1) \2-\3')
  elsif patient_phone.match('UNK')
    converted_data << patient_phone = '(UNK) - '
  else
    converted_data << patient_phone = empty_phone
  end

  # Patient total
  patient_total = ''

  patient_total << o.slice(28)
  patient_total.gsub!(/^0+/, '')
  converted_data << patient_total.insert(-3, '.')

  # Next two fileds with eight digit numbers
  converted_data << o.slice(29)
  converted_data << o.slice(30)

  # Insert a 4
  converted_data.insert(-1, number_four)

  # Insert insurance
  converted_data << o.slice(48)

  # Insurance address
  converted_data << o.slice(49)

  # Usually empty
  converted_data << o.slice(50)

  # Insurance address
  insurance_address = Array.new
  
  insurance_address << o.slice(51..53)
  converted_data << insurance_address.join(' ')

  # Insurance phone number
  insurance_phone = ''

  insurance_phone << o.slice(54)
  if insurance_phone.match(PHONE)
    converted_data << insurance_phone.gsub(PHONE, '(\1) \2-\3')
  elsif insurance_phone.match('UNK')
    converted_data << insurance_phone = '(UNK) - '
  elsif insurance_phone.match(INCOMPLETE_PHONE)
    converted_data << insurance_phone.gsub(PHONE, '(\1) \2-\3')
  else
    converted_data << insurance_phone = empty_phone
  end

  # Claim number? (Sometimes empty) 
  converted_data << o.slice(56)

  # Second claim number or insurance number?
  converted_data << o.slice(57)

  # Insert a 4
  converted_data.insert(-1, number_four)

  # Other Insurance name (sometimes empty)
  converted_data << o.slice(59)

  # Other Insurance address (sometimes empty)
  converted_data << o.slice(60)

  # Other Usually empty (sometimes empty)
  converted_data << o.slice(61)

  # Other Insurance address (sometimes empty)
  insurance_address = Array.new
  
  insurance_address << o.slice(62..64)
  converted_data << insurance_address.join(' ')

  # Other Insurance phone number (sometimes empty)
  other_insurance_phone = ''

  other_insurance_phone << o.slice(65)
  if other_insurance_phone.match(PHONE)
    converted_data << other_insurance_phone.gsub(PHONE, '(\1) \2-\3')
  elsif other_insurance_phone.match('UNK')
    converted_data << other_insurance_phone = '(UNK) - '
  else
    converted_data << other_insurance_phone = empty_phone
  end

  # Other number
  converted_data << o.slice(67)

  # Other insurance number
  converted_data << o.slice(68)

  # Other usually empty

  converted_data.insert(-1, number_four)

  4.times do
    converted_data.insert(-1, empty_space)
  end
  converted_data.insert(-1, empty_phone)

  2.times do
    converted_data.insert(-1, empty_space)
  end
  converted_data.insert(-1, number_four)

  # Dr Info
  converted_data << 'Dr Info'

  # Diagnostic code and ailment
  converted_data << o.slice(132..133).join(' ')

  # Hick picks (HCPCS Codes)
  converted_data << o.slice(134..143).join(' ').strip

  # Doctors name
  converted_data << o.slice(144).gsub(DOCTOR_NAME,' ')

  doctor_name = ''
  doctor_name << o.slice(146..147).join('')
  converted_data << doctor_name.gsub(DOCTOR_NAME,' ')

  # Other name
  converted_data << o.slice(149)

  # Numbered data
  numbered_data = Array.new
  numbered_data << o.slice(152..159).join(' ')
  converted_data.concat(numbered_data)

  # Insurance
  if o.slice(167) == 'Y'
    converted_data << o.slice(166..167).join(' ')
  else
    converted_data << o.slice(167)
  end

  # Output data to final array
  final_data << converted_data

end

# For debugging
# p final_data
# puts "#############################"
# p original_data

p "Total patients: #{final_data.length}"

# Use for outputting main file
Dir.chdir '..'
Dir.chdir 'converted'
filename.each do |new_file|
  
  File.open(new_file, 'w') do |f|
    f.write(final_data.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join(''))
  end
end




# Bring in adjustment script and run
Dir.chdir '..'
Dir.chdir 'lib'
load 'adjmt_parser.rb'
