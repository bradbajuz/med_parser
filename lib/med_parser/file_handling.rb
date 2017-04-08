require_relative 'sanitize.rb'

module MedParser
  class FileHandling < Sanitize
    attr_accessor :original_data, :final_data, :converted_data

    def initialize
      @original_data = []
      @final_data = []
      @converted_data = converted_data
    end

    def import_csv(from_file = '*.csv')
      Dir.chdir '..'
      Dir.chdir 'import'
      Dir.glob(from_file).each do |f|
        CSV.foreach(f, skip_blanks: true) do |raw_file|
          original_data << raw_file
        end
      end
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

    def launch_adjmt_parser
      # Bring in adjustment script and run
      Dir.chdir '..'
      Dir.chdir 'lib'
      load 'med_parser/adjmt_parser.rb'
    end
  end
end