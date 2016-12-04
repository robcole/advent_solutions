require "minitest/autorun"
require './day4'

class TestDay4 < Minitest::Test
  def test_day4_1
    #  is a real room because the most common letters
    # are a (5), b (3), and then a tie between x, y, and z, which are
    # listed alphabetically.
    assert_equal Day4.real_room?("aaaaa-bbb-z-y-x-123[abxyz]"), true
  end

  def test_day4_2
    # a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters
    # are all tied (1 of each), the first five are listed alphabetically.
    assert_equal Day4.real_room?("a-b-c-d-e-f-g-h-987[abcde]"), true
  end

  def test_day4_3
    assert_equal Day4.real_room?("not-a-real-room-404[oarel]"), true
  end

  def test_day4_4
    assert_equal Day4.real_room?("totally-real-room-200[decoy]"), false
  end

  def test_day4_5
    assert_equal Day4.decode_name("qzmt-zixmtkozy-ivhz-343"),
                 "very encrypted name"
  end
end
