class Day1
  class << self

    def part1(input)
      history = process_instruction_history(input)
      final_coords = history[:coord_history].last
      calculate_distance(final_coords)
    end

    def part2(input)
      history = process_instruction_history(input)
      full_history = interpolate_visits(history[:coord_history])

      first_double_visit = full_history
                             .group_by { |x| x }
                             .select { |_k, v| v.size > 1 }
                             .map(&:first).first

      return 0 if first_double_visit.nil?
      calculate_distance(first_double_visit)
    end

    def starting_coords
      { x: 0, y: 0 }
    end

    # output:
    # memo = {
    #   coord_history: [array of coordinates visited in order],
    #   current_orientation: direction most recently moving in (R/D/L/U)
    # }
    def process_instruction_history(input)
      input.inject({ coord_history: [starting_coords] }) do |memo, instruction|
        current_orientation = memo.fetch(:current_orientation, nil)
        coord_history = memo.fetch(:coord_history)

        amount = find_amount(instruction)
        direction = find_direction(instruction)

        next unless amount && direction

        new_orientation = new_orientation(current_orientation, direction)
        build_new_coords = orientations.fetch(new_orientation.to_sym)
        new_coords = build_new_coords.(coord_history.last, amount)

        memo.merge({
          coord_history: coord_history << new_coords,
          current_orientation: new_orientation
        })
      end
    end

    # builds a list of coordsinates, not including the last coordinate (to
    # prevent accidentally repeating coordinates when interpolating)
    #
    # coords1: { x: 0, y: 0 }, coords2: { x: 4, y: 0 } =>
    #   { x: 0, y: 0 }, { x: 1, y: 0 }, { x: 2, y: 0 }, { x: 3, y: 0 }
    def coords_between(coords1:, coords2: nil)
      return [coords1] if coords2.nil?

      changed_sym = (coords1.to_a - coords2.to_a).map(&:first).first
      return [coords1, coords2] unless changed_sym

      build_replacement_coords(coords1, coords2, changed_sym)
    end

    # builds up coordinates to interpolate between two coord pairs, based
    # on which axis changed and whether we should subtract or add to
    # move from point 1 to point 2
    def build_replacement_coords(coords1, coords2, changed_sym)
      point_one = coords1[changed_sym]
      point_two = coords2[changed_sym]
      greater_than = point_one > point_two

      new_values = if greater_than
        point_one.downto(point_two + 1).to_a
      else
        point_one.upto(point_two - 1).to_a
      end

      new_values.map { |value| coords1.merge({changed_sym => value}) }
    end

    def calculate_distance(final_coords)
      final_coords[:x].abs + final_coords[:y].abs
    end

    # takes a coordinate history, and builds an interpolated history of all
    # points in between each pair of the coordinates, including the first
    # and last coordinates
    #
    # { x: 0, y: 0 }, { x: 0, y: 2 }, { x: 2, y: 0 } =>
    #   { x: 0, y: 0 }, { x: 0, y: 1 }, { x: 0, y: 2 }, { x: 1, y: 2 },
    #   { x: 2:, y: 2}
    def interpolate_visits(coord_history)
      coord_history.each_with_index.map do |coords, i|
        next_coords = coord_history[i + 1]
        coords_between(coords1: coords, coords2: next_coords)
      end.compact.flatten
    end

    def find_amount(instruction)
      instruction.match(/\d+/)[0].to_i
    end

    def find_direction(instruction)
      instruction.match(/^\w/)[0]
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

      # modulo allows us to prevent having an index of 4 when we reach the 3rd
      # element and go right one more time (which would result in a nil value),
      # so we're effectively treating this as a wraparound array
      orientations.keys[new_index % 4]
    end
  end
end
