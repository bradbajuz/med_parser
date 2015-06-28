require 'csv'

ALPHA = /[A-Za-z]/
MISSING_INITAL = /[pPoO]/

# filename = gets.chomp
original_data = Array.new
converted_data = Array.new
    
Dir.chdir "convert"
File.foreach("DEM150601.DHA") do |raw_file|
  original_data << raw_file.split()
end

converted_data.insert(0, "Acvite", "ACT")

original_data.each do |o|
  converted_data << o.slice(0)

  patient_name = ""
  inital = " "
  patient_name << o.slice(2..3).join(" ")

  if o.slice(4).match(MISSING_INITAL)
    inital ||= ""
  else o.slice(4).match(ALPHA)
    inital << o.slice(4)
  end
  patient_name << inital
  converted_data << patient_name
end

converted_data[2].slice!(0..1)
if converted_data[2].slice(1) == "0"
  converted_data[2].slice!(1)
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