require 'byebug'

class Day2
  class << self
    def part1_input
      File.read("part1.txt")
    end

    def add_direction
      {
        D: ->(pos) { next_number(pos, :row, -1) },
        U: ->(pos) { next_number(pos, :row, 1) },
        L: ->(pos) { next_number(pos, :column, -1) },
        R: ->(pos) { next_number(pos, :column, 1) }
      }
    end

    def key_coordinate(key)
      direction_table.each_with_index.map do |row, index|
        column = row.detect { |input| input == key }
        next unless column

        [row.index(key), -index]
      end.compact.flatten
    end

    def next_number(key, type, amount)
      next_coordinates = next_coordinates(key, type, amount)
      number_at(next_coordinates)
    end

    def next_coordinates(key, type, amount)
      current_coords = key_coordinate(key)
      index = (type == :row) ? 1 : 0
      new_pos = current_coords[index] + amount

      new_coords = if type == :row
        [current_coords[0], new_pos]
      else
        [new_pos, current_coords[1]]
      end

      apply_boundaries(new_coords, current_coords)
    end

    def exceeds_row?(row)
      row > 0 || row < -4
    end

    def exceeds_column?(column)
      column < 0 || column > 4
    end

    def exceeds_boundaries?(new_coords)
      exceeds_row?(new_coords[1]) ||
        exceeds_column?(new_coords[0]) ||
        keypad_empty_at?(new_coords)
    end

    def number_at(coords)
      direction_table[-coords[1]][coords[0]]
    end

    def keypad_empty_at?(coords)
      number_at(coords).nil?
    end

    def apply_boundaries(new_coords, old_coords)
      exceeds_boundaries?(new_coords) ? old_coords : new_coords
    end

    def direction_table
      [
        [nil, nil, 1, nil, nil],
        [nil, 2, 3, 4, nil],
        [5, 6, 7, 8, 9],
        [nil, "A", "B", "C", nil],
        [nil, nil, "D", nil, nil]
      ]
    end

    def build_history(input)
      input.each_line.inject([]) do |arr, instructions|
        first_button = arr.last&.last || 5
        line_history = history_for(instructions.delete("\n"), first_button)
        arr << line_history
      end
    end

    def history_for(instructions, first_button)
      instructions.each_char.inject([first_button]) do |arr, instruction|
        position = arr.last
        new_position = add_direction[instruction.to_sym].(position)
        arr << new_position
      end
    end

    def part2(input = part1_input)
      build_history(input).map(&:last).join
    end
  end
end
