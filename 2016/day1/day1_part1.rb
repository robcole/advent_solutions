class Day1
  class << self
    def solve(input)
      final_coords = input.inject({ position: coords }) do |memo, instruction|
        current_orientation = memo.fetch(:current_orientation, nil)

        amount = find_amount(instruction)
        direction = find_direction(instruction)
        new_orientation = new_orientation(current_orientation, direction)
        build_new_coords = orientations.fetch(new_orientation.to_sym)
        old_coords = memo.fetch(:position)

        new_coords = build_new_coords.(old_coords, amount)

        memo.merge({ position: new_coords,
                     current_orientation: new_orientation })
      end

      final_coords[:position][:x].abs + final_coords[:position][:y].abs
    end

    def find_amount(instruction)
      instruction.match(/\d+/)[0].to_i
    end

    def find_direction(instruction)
      instruction.match(/^\w/)[0]
    end

    def coords
      {
        x: 0,
        y: 0
      }
    end

    def orientations
      {
        R: ->(pos, amt) { pos.merge({ x: pos[:x] + amt })},
        D: ->(pos, amt) { pos.merge({ y: pos[:y] - amt })},
        L: ->(pos, amt) { pos.merge({ x: pos[:x] - amt })},
        U: ->(pos, amt) { pos.merge({ y: pos[:y] + amt })}
      }
    end

    def new_index_amount(index, direction)
      direction == "R" ? (index + 1) : (index - 1)
    end

    def new_orientation(current_orientation = nil, direction)
      return direction unless current_orientation

      curr_index = orientations.keys.index(current_orientation.to_sym)
      new_index = new_index_amount(curr_index, direction)

      # prevent having an index of 4 when we reach the 3rd element and
      # go right one more time (which should be reset to 0), so we "wrap"
      orientations.keys[new_index % 4]
    end
  end
end
