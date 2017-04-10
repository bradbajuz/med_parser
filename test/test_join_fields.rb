require 'minitest/autorun'
require_relative '../lib/med_parser/join_fields'

class TestJoinFields < Minitest::Test
  def setup
    @test_join = Object.new
    @test_join.extend(JoinFields)
    @two_fields = %w[WARREN MILES]
    @three_fields = ['SALT LAKE CITY', 'UT', '84130']
  end

  def test_two_fields_will_be_joined
    assert_equal 'WARREN MILES', @test_join.join_fields(@two_fields)
  end

  def test_three_fields_will_be_joined
    assert_equal 'SALT LAKE CITY UT 84130', @test_join.join_fields(@three_fields)
  end
end