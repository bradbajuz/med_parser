original_data = Array.new
final_data = Array.new

Dir.chdir '..'
Dir.chdir 'import'
filename = Dir.glob('*.csv').each do |f|
  CSV.foreach(f, skip_blanks: true) do |raw_file|
    original_data << raw_file
  end
end

# Get last line total before it's removed
before_line_total = original_data.dup

last_line_total = Array.new
line_total = ''

last_line_total << original_data.last.slice(0)
line_total << last_line_total.slice(0).to_s

# Remove last element in array that has total
original_data.pop

# Start processing fields
original_data.each do |o|
  converted_data = Array.new

  # Needed at beginning of array for each patient
  # Watch out for array that get inserted on last line that only includes below line of code
  converted_data.insert(0, '501', 'Adjustment per client', '3')

  # BEGIN Check for nil in original data and replace with empty string
  o.map! { |x| x ? x : '' }

  # Add in account number
  converted_data << o.slice(0)

  # Remove leading zeros from account number
  # This will fail if imported file has more than two empty lines

  # Only needed if  there are two leading zeros before D
  # converted_data[3].slice!(0..1)

  if converted_data[3].slice(1) == '0'
    converted_data[3].slice!(1)
  end

  patient_total = ''
  patient_paid = ''

  patient_total << o.slice(28)

  patient_paid << o.slice(26)

  patient_owe = patient_total.to_i.abs - patient_paid.to_i.abs

  converted_data << Money.new(patient_owe).format(with_currency: false,
                                                  symbol: false,
                                                  thousands_separator: false)

  #Output data to final array
  final_data << converted_data
end

# # For debugging
# p final_data
# puts "#############################""
# p original_data

# Compare total patients before and after to make sure
# patient line didn't get removed during pop on line 24
if final_data.length.to_i == line_total.to_i
  p "Total patients: #{final_data.length}"
else
  p "Error in total patients. Please check last line in data and add in line with total lines."
  p "Before total = #{before_line_total.length} and after total = #{final_data.length}"
  p "Last line with account #{line_total} is being removed doesn't match total of #{final_data.length}"
end

# Use for outputting adjustment file
Dir.chdir '..'
Dir.chdir 'export'
filename.each do |new_file|

  File.open("ADJUSTMENT #{new_file}", 'w') do |f|
    f.write(final_data.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join(''))
  end
end

root = TkRoot.new
root.withdraw

if final_data.length.to_i == line_total.to_i
  Tk.messageBox(
      'type' => 'ok',
      'icon' => 'info',
      'title' => "DCH, FAY and Medicaid Parser",
      'message' => "Success!\nTotal patients: #{final_data.length}"
  )
  root.destroy
  Tk.mainloop
else
  Tk.messageBox(
      'type' => 'ok',
      'icon' => 'warning',
      'title' => 'Incorrect Patient Total',
      'message' => "Before total = #{before_line_total.length} vs after total = #{final_data.length}
      \nHow to fix:
  \nThe last line with account# #{line_total} is being removed and doesn't match patient total #{final_data.length}
      \nAdd a new line at end of original file with the number '#{before_line_total.length}' and run converter again."
  )
  root.destroy
  Tk.mainloop
end
