require 'minitest/autorun'
require_relative '../lib/med_parser/fields'

class FieldsTest < Minitest::Test
  def setup
    @test_fields = Object.new
    @test_fields.extend(Fields)
    @parser_first_columns = []
    @adjmt_parser_first_columns = []
    @o_data_nil = ['Acvite', 'ACT', nil]
  end

  def test_first_two_columns_get_inserted
    assert_equal %w[Acvite ACT], @test_fields.beginning_fields(@parser_first_columns)
  end

  def test_first_three_columns_get_inserted
    assert_equal ['501', 'Adjustment per client', '3'], @test_fields.adjmt_beginning_fields(@adjmt_parser_first_columns)
  end

  def test_for_nil
    assert_equal ['Acvite', 'ACT', ''], @test_fields.nil_check(@o_data_nil)
  end
end