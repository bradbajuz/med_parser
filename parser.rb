require 'csv'

PATIENT_PHONE = /(\d{3})(\d{3})(\d{4})/
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
  if patient_phone.match(PATIENT_PHONE)
    converted_data << patient_phone.gsub(PATIENT_PHONE, '(\1) \2-\3')
  elsif patient_phone.match('UNK')
    converted_data << patient_phone = '(UNK) - '
  else
    converted_data << patient_phone = '( ) - '
  end

  # Patient total
  patient_total = ''

  patient_total << o.slice(28)
  patient_total.gsub!(/^0+/, "")
  converted_data << patient_total.insert(-3, '.')

  # Next to fileds with eight digit numbers
  converted_data << o.slice(29)
  converted_data << o.slice(30)


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

# puts n << raw