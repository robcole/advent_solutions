require "minitest/autorun"
require './day2_part2'

class TestDay2 < Minitest::Test
  def test_part_two
    instructions = ["ULL","RRDDD", "LURDL", "UUUUD"].join("\n")
    assert_equal Day2.part2(instructions), "5DB3"
  end
end
