require 'minitest/autorun'
require './day1_part1'

class TestDay1 < Minitest::Test
  def test_first
    input = %w(R2 L3)
    assert_equal Day1.solve(input), 5
  end

  def test_second
    input = %w(R2 R2 R2)
    assert_equal Day1.solve(input), 2
  end

  def test_third
    input = %w(R5 L5 R5 R3)
    assert_equal Day1.solve(input), 12
  end
end
