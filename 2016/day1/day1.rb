class Day1
  class << self
    def part1(input)
      history = input.inject(coord_history) do |memo, instruction|
        current_orientation = memo.fetch(:current_orientation, nil)
        coord_history = memo.fetch(:coord_history)

        amount = find_amount(instruction)
        direction = find_direction(instruction)
        new_orientation = new_orientation(current_orientation, direction)
        build_new_coords = orientations.fetch(new_orientation.to_sym)
        new_coords = build_new_coords.(coord_history.last, amount)

        memo.merge({
          coord_history: coord_history << new_coords,
          current_orientation: new_orientation
        })
      end

      final_coords = history[:coord_history].last

      calculate_distance(final_coords)
    end

    def coord_history
      { coord_history: [coords] }
    end

    # coords1: { x: 0, y: 0 }, coords2: { x: 4, y: 0 } =>
    #   { x: 0, y: 0 }, { x: 1, y: 0 }, { x: 2, y: 0 }, { x: 3, y: 0 },
    #   { x: 4, y: 0 }...
    def coords_between(coords1:, coords2:)
      changed_sym = (coords1.to_a - coords2.to_a).map(&:first).first

      return [coords1, coords2] unless changed_sym

      changed_1 = coords1[changed_sym]
      changed_2 = coords2[changed_sym]

      greater_than = changed_1 > changed_2

      new_values = if greater_than
        changed_1.downto(changed_2 + 1).to_a
      else
        changed_1.upto(changed_2 - 1).to_a
      end

      new_values.map do |value|
        coords1.merge({changed_sym => value})
      end
    end

    def calculate_distance(final_coords)
      final_coords[:x].abs + final_coords[:y].abs
    end

    def part2(input)
      history = input.inject(coord_history) do |memo, instruction|
        current_orientation = memo.fetch(:current_orientation, nil)
        coord_history = memo.fetch(:coord_history)

        amount = find_amount(instruction)
        direction = find_direction(instruction)
        new_orientation = new_orientation(current_orientation, direction)
        build_new_coords = orientations.fetch(new_orientation.to_sym)
        new_coords = build_new_coords.(coord_history.last, amount)

        memo.merge({
          coord_history: coord_history << new_coords,
          current_orientation: new_orientation
        })
      end

      full_history = interpolate_visits(history[:coord_history])

      first_double_visit = full_history
                             .group_by { |x| x }
                             .select { |_k, v| v.size > 1 }
                             .map(&:first).first

      calculate_distance(first_double_visit)
    end

    def interpolate_visits(coord_history)
      coord_history.each_with_index.map do |coords, i|
        next_coords = coord_history[i + 1]
        next if next_coords.nil?

        coords_between(coords1: coords, coords2: next_coords)
      end.compact.flatten
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
