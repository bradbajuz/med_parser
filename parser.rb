require 'csv'

ALPHA = /[A-Z a-z]/
MISSING_INITIAL = /[POpo]/

# Address Regex
ADDR_NUMBER = /^(\d+\W|[a-z]+)?(\d+)([a-z]?)\b/io
ADDR_STREET = /(?:\b(?:\d+\w*|[a-z'-]+)\s*)+/io
ADDR_CITY = /(?:\b[a-z][a-z'-]+\s*)+/io
ADDR_ZIP = /\b(\d{5})(?:-(\d{4}))?\b/o
ADDR_AT = /\s(at|@|and|&)\s/io
ADDR_PO_BOX = /[POpo]/
# ADDR_PO_BOX = /\b[p|p]*(ost|ost)*\.*\s*[o|o|0]*(ffice|ffice)*\.*\s*[b|b][o|o|0][x|x]\b/

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
  converted_data[2].slice!(0)
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