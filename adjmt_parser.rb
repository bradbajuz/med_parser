require 'csv'

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
  converted_data.insert(0, '501', 'Adjustment per client', '3')

  # BEGIN Check for nil in original data and replace with empty string
  o.map! { |x| x ? x : ''}

  # Add in account number
  converted_data << o.slice(0)

  # Remove leading zeros from account number
  # This will fail if imported file has more than two empty lines
  converted_data[3].slice!(0..1)
  if converted_data[3].slice(1) == '0'
    converted_data[3].slice!(1)
  end

  # Patient total - paid = owe
  patient_total = ''
  patient_paid = ''

  patient_total << o.slice(28)
  patient_total.gsub!(/^0+/, '')

  patient_paid << o.slice(26)

  patient_owe = patient_total.to_i.abs - patient_paid.to_i.abs

  if patient_owe.to_s[0] == '0'
    converted_data << patient_owe.to_s
  else
    converted_data << patient_owe.to_s.insert(-3, '.')
  end

  #Output data to final array
  final_data << converted_data
end

# For debugging
p final_data
puts #############################
p original_data

# Use for outputting main file
Dir.chdir '..'
Dir.chdir 'converted'
File.open('ADJUSTMENT DCH MEDICAID.csv', 'w') do |f|
  f.write(final_data.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join(''))
end