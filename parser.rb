require 'csv'

ALPHA = /[A-Z a-z]/

# Address Regex
ADDR_NUMBER = /^(\d+\W|[a-z]+)?(\d+)([a-z]?)\b/io
ADDR_STREET = /(?:\b(?:\d+\w*|[a-z'-]+)\s*)+/io
ADDR_CITY = /(?:\b[a-z][a-z'-]+\s*)+/io
ADDR_ZIP = /\b(\d{5})(?:-(\d{4}))?\b/o
ADDR_AT = /\s(at|@|and|&)\s/io
ADDR_PO_BOX = /\b[p|p]*(ost|ost)*\.*\s*[o|o|0]*(ffice|ffice)*\.*\s*[b|b][o|o|0][x|x]\b/

# filename = gets.chomp
original_data = Array.new
converted_data = Array.new
    
Dir.chdir 'convert'
File.foreach('DEM150601.DHA') do |raw_file|
  original_data << raw_file.split
end

# Needed at beginning of array for each patient
converted_data.insert(0, 'Acvite', 'ACT')

# Start processing fields
original_data.each do |o|
  converted_data << o.slice(0)

  # Remove leading zeros from account number
  converted_data[2].slice!(0..1)
  if converted_data[2].slice(1) == '0'
    converted_data[2].slice!(1)
  end

  # Setup patient name to be processed
  patient_name = ''
  initial = ' '
  patient_name << o.slice(2..3).join(' ')

  # If there is a missing initial, don't bring in 'P' or 'PO'
  if o.slice(4).match(ADDR_PO_BOX)
    initial ||= ''
  else o.slice(4).match(ALPHA)
    initial << o.slice(4)
  end
  patient_name << initial
  converted_data << patient_name
end



# For debugging
p converted_data
puts #############################
p original_data

# # Use for outputting file
# Dir.chdir ".."
# Dir.chdir "converted"
# n = File.new("DEM DCH MEDICAID.csv", "w+")

# puts n << raw