module AlertGui
  def alert_gui
    root = TkRoot.new
    root.withdraw

    if final_data.length.to_i == line_total.to_i
      Tk.messageBox(type: 'ok',
                    icon: 'info',
                    title: 'DCH, FAY and Medicaid Parser',
                    message: "Success!\nTotal patients: #{final_data.length}")
    else
      Tk.messageBox(type: 'ok',
                    icon: 'warning',
                    title: 'Incorrect Patient Total',
                    message: "Before total = #{before_line_total.length} vs after total = #{final_data.length}
                    \nHow to fix:
                    \nThe last line with account# #{line_total} is being removed and doesn't match patient total #{final_data.length}
                    \nAdd a new line at end of original file with the number '#{before_line_total.length}' and run converter again.")
    end
    root.destroy
    Tk.mainloop
  end
end
