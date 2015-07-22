require 'csv'

#Regex
PHONE = /(\d{3})(\d{3})(\d{4})/
PATIENT_SSN = /(\d{3})(\d{2})(\d{3})/

# filename = gets.chomp
original_data = Array.new
final_data = Array.new
    
Dir.chdir 'convert'
CSV.foreach('CAREPRODEMO.CSV') do |raw_file|
  original_data << raw_file
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
  converted_data[2].slice!(0..1)
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
  else
    converted_data << insurance_phone = empty_phone
  end

  # Usually empty
  converted_data << o.slice(57)

  # Insurance number
  converted_data << o.slice(58)

  # Insert a 4
  converted_data.insert(-1, number_four)

  # Other is ,4, , , , ,( ) - , , ,4, , , , ,( ) - , , ,4,

  # Other Insurance name (sometimes empty)
  converted_data << o.slice(60)

  # Other Insurance address (sometimes empty)
  converted_data << o.slice(61)

  # Other Usually empty (sometimes empty)
  converted_data << o.slice(62)

  # Other Insurance address (sometimes empty)
  insurance_address = Array.new
  
  insurance_address << o.slice(63..65)
  converted_data << insurance_address.join(' ')

  # Other Insurance phone number (sometimes empty)
  other_insurance_phone = ''

  other_insurance_phone << o.slice(66)
  if other_insurance_phone.match(PHONE)
    converted_data << other_insurance_phone.gsub(PHONE, '(\1) \2-\3')
  elsif other_insurance_phone.match('UNK')
    converted_data << other_insurance_phone = '(UNK) - '
  else
    converted_data << other_insurance_phone = empty_phone
  end

  # Other usually empty

  2.times do
    converted_data.insert(-1, empty_space)
  end

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
  converted_data << ' Dr Info'

  # Ailment
  converted_data << o.slice(134..135).join('')

  # String of numbers
  converted_data << o.slice(136..143).join(' ')


  # END Check for nil in converted data and replace with empty string
  converted_data.map! { |x| x ? x : ''}

  final_data << converted_data

end

# For debugging
p final_data
puts #############################
p original_data

# # Use for outputting file
# Dir.chdir ".."
# Dir.chdir "converted"
# n = File.new("DEM DCH MEDICAID.csv", "w+")

# puts n << final_data