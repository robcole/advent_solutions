require 'minitest/autorun'
require './day1'

class TestDay1Part1 < Minitest::Test
  def test_first
    input = %w(R8 R4 R4 R8)
    assert_equal Day1.part2(input), 4
  end
end
