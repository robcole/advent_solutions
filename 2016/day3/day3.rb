require 'byebug'
class Day3
  class << self
    def input
      File
        .read("input.txt")
        .split(/\s+/)
        .map(&:to_i)
        .each_slice(3)
        .to_a
    end

    def valid_triangles
      input.count { |triangle| valid_triangle?(triangle) }
    end

    def valid_triangle?(sides)
      sides.each_with_index.all? do |side, i|
        sum_other_sides(i, sides) > side
      end
    end

    def sum_other_sides(i, sides)
      [0, 1, 2]
        .reject { |n| n == i }
        .map { |index| sides[index] }
        .inject(&:+)
    end
  end
end
