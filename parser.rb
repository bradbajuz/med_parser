require 'csv'

raw = Array.new

Dir.chdir "convert"
dch = File.open("DEM150601.DHA")

dch.each do |df|
  raw << df.split()
end

# For debugging
puts raw

# # Use for outputting file
# Dir.chdir ".."
# Dir.chdir "converted"
# n = File.new("DEM DCH MEDICAID.csv", "w+")

# puts n << raw
