require 'byebug'

class Day2
  class << self
    def part1_input
      File.read("part1.txt")
    end

    def add_direction
      {
        D: ->(pos) { pos > 6 ? pos : pos + 3 },
        U: ->(pos) { pos < 4 ? pos : pos - 3 },
        L: ->(pos) { [1, 4, 7].include?(pos) ? pos : pos - 1 },
        R: ->(pos) { [3, 6, 9].include?(pos) ? pos : pos + 1 },
      }
    end

    # []
    def build_history(input)
      asdf = input.each_line.inject([]) do |arr, instructions|
        first_button = arr.last&.last || 5
        line_history = history_for(instructions.delete("\n"), first_button)
        arr << line_history
      end
    end

    def history_for(instructions, first_button)
      asdf = instructions.each_char.inject([first_button]) do |arr, instruction|
        position = arr.last
        new_position = add_direction[instruction.to_sym].(position)
        arr << new_position
      end
    end

    def part1
      build_history(part1_input).map(&:last).join
    end
  end
end
