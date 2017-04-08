require_relative 'med_parser/parser'
require_relative 'med_parser/adjmt_parser'


new_import = MedParser::Parser.new
new_import.run_parser

new_adjmt_import = MedParser::AdjmtParser.new
new_adjmt_import.run_adjmt_parser