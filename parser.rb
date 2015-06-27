require 'csv'

raw = Array.new

Dir.chdir "convert"
File.foreach("DEM150601.DHA") do |raw_file|
  raw << raw_file.split()
end

raw.each do |r|
  r.insert(0, "Acvite", "ACT")
  
  r[2].slice!(0..1)
  if r[2].slice(1) == "0"
    r[2].slice!(1)
  end
end

# For debugging
puts raw

# # Use for outputting file
# Dir.chdir ".."
# Dir.chdir "converted"
# n = File.new("DEM DCH MEDICAID.csv", "w+")

# puts n << raw