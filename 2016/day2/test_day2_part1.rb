require "minitest/autorun"
require './day2'

class TestDay2 < Minitest::Test
  def test_part1_one
    instructions = ["ULL","RRDDD", "LURDL", "UUUUD"].join("\n")
    assert_equal Day2.part1(instructions), 1985
  end
end
