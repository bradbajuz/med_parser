require_relative 'alert_gui'

module LogTotal
  include AlertGui

  def before_line_total
    if final_data.length.to_i == line_total.to_i
      p "Total patients: #{final_data.length}"
    else
      p 'Error in total patients. Please check last line in data and add in line with total lines.'
      p "Before total = #{before_line_total.length} and after total = #{final_data.length}"
      p "Last line with account #{line_total} is being removed doesn't match total of #{final_data.length}"
    end
  end
end