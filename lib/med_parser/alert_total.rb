module AlertTotal
  def alert_total
    if final_data.length.to_i == line_total.to_i
      puts '### SUCCESS! ###'
      puts "Total patients: #{final_data.length}"
    else
      puts '### ERROR ###'
      puts "Before total = #{before_line_total.length} vs after total = #{final_data.length}"
      puts 'How to fix:'
      puts "The last line with account# #{line_total} is being removed and doesn't match patient total #{final_data.length}"
      puts "Add a new line at end of original file with the number '#{before_line_total.length}' and run converter again."
    end
    puts '### END ###'
  end
end
