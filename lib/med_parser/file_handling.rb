require_relative 'sanitize'

module MedParser
  class FileHandling < Sanitize
    attr_accessor :original_data,
                  :final_data,
                  :converted_data,
                  :before_line_total,
                  :line_total,
                  :last_line_total

    def initialize
      @original_data = []
      @final_data = []
      @converted_data = converted_data
      @before_line_total = before_line_total
      @line_total = ''
      @last_line_total = []
    end

    def import_csv(from_file = '*.csv')
      Dir.chdir '..'
      Dir.chdir 'import'
      Dir.glob(from_file).each do |f|
        CSV.foreach(f, skip_blanks: true) do |raw_file|
          original_data << raw_file
        end
      end
      @before_line_total = original_data.dup
    end

    def filename
      Dir.chdir '..'
      Dir.chdir 'import'
      Dir.glob('*.csv').join('')
    end

    def export_csv_file(to_file = filename.to_s)
      Dir.chdir '..'
      Dir.chdir 'export'
      File.open(to_file, 'w') do |f|
        f.write(final_data.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join(''))
      end
    end

    def export_adjmt_csv_file(to_file = filename.to_s)
      Dir.chdir '..'
      Dir.chdir 'export'
      File.open("ADJUSTMENT #{to_file}", 'w') do |f|
        f.write(final_data.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join(''))
      end
    end
  end
end