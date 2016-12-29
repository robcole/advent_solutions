defmodule Day1 do
  @doc """
    Calculates the distance away after following directions.

  ## Examples

    iex> Day1.distance_away(["R2", "L3"])
    5

    iex> Day1.distance_away(["R2", "R2", "R2"])
    2

    iex> Day1.distance_away(["R5", "L5", "R5", "R3"])
    12
  """
  def distance_away(instructions) do
    instructions
    |> build_stops
    |> find_final_stop
    |> sum_distance
  end

  @doc """
    Calculates the first duplicate stop in a set of instructions.

  ## Examples

    iex> Day1.first_duplicate_distance(["R8", "R4", "R4", "R8"])
    4
  """
  def first_duplicate_distance(instructions) do
    instructions
    |> build_stops
    |> group_duplicate_stops
    |> find_first_duplicate_distance
    |> sum_distance
  end

  def sum_distance({x, y}) do
    abs(x) + abs(y)
  end

  def find_final_stop(all_stops) do
    [final_stop] = Enum.take(all_stops.stops, -1)
    final_stop
  end

  def build_stops(instructions) do
    default = %{ orientation: nil, current_pos: { 0, 0 }, stops: [{ 0, 0 }] }

    Enum.reduce(instructions, default, fn(instruction, acc) ->
      next_stop = Day1.next_stop(acc.orientation, acc.current_pos, instruction)
      [ _head | tail ] = Enum.reverse(acc.stops)
      %{ next_stop | stops: Enum.reverse(tail) ++ next_stop.stops }
    end)
  end

  def find_first_duplicate_distance(grouped_stops) do
    { pos, _count } = Enum.find grouped_stops, fn(x) ->
      value = List.to_tuple(elem(x, 1))
      tuple_size(value) > 1
    end

    pos
  end

  def group_duplicate_stops(parsed_instructions) do
    Enum.group_by parsed_instructions.stops, fn(x) -> x end
  end

  @doc """
    Calculates stops visited given a starting and ending coordinate pair.

  ## Examples

    iex> Day1.stops_visited({ 0, 0 }, { 2, 0 })
    [ { 0, 0 }, { 1, 0 }, { 2, 0 } ]
  """
  def stops_visited(start_point, end_point) do
    for x_coord <- elem(start_point, 0)..elem(end_point, 0),
        y_coord <- elem(start_point, 1)..elem(end_point, 1),
        do: { x_coord, y_coord }
  end

  @doc """
    Calculates next point given previous direction, current position,
    and instruction.

  ## Examples

    iex> Day1.next_stop(nil, {0, 0}, "R2")
    %{ orientation: "R",
       current_pos: { 2, 0 },
       stops: [{0, 0}, {1, 0}, {2, 0}] }

    iex> Day1.next_stop("R", {2, 0}, "R2")
    %{ orientation: "D",
       current_pos: { 2, -2 },
       stops: [{2, 0}, {2, -1}, {2, -2}] }
  """
  def next_stop(orientation, { x, y } = prev_coords, instruction) do
    { direction, distance } = parse_instruction(instruction)
    new_orientation = new_orientation(orientation, direction)

    next_stop = case new_orientation do
      "R" -> { x + distance, y }
      "L" -> { x - distance, y }
      "U" -> { x, y + distance }
      "D" -> { x, y - distance }
    end

    %{ orientation: new_orientation,
       current_pos: next_stop,
       stops: stops_visited(prev_coords, next_stop)}
  end

  @doc """
    Calculates next orientation given current orientation and next direction.

  ## Examples

    iex> Day1.new_orientation(nil, "R")
    "R"

    iex> Day1.new_orientation("R", "R")
    "D"

    iex> Day1.new_orientation("D", "R")
    "L"

    iex> Day1.new_orientation("L", "R")
    "U"
  """
  def new_orientation(orientation, direction) do
    case orientation do
      nil -> direction
        _ -> calculate_orientation(orientation, direction)
    end
  end

  def calculate_orientation(orientation, direction) do
    orientations = [ "R", "D", "L", "U" ]
    curr_index = Enum.find_index(orientations, fn(x) -> x == orientation end)

    new_index = case direction do
      "R" -> curr_index + 1
      "L" -> curr_index - 1
    end

    Enum.at(orientations, rem(new_index, 4))
  end

  @doc """
    Converts instructions into an amount and a direction.

  ## Examples

    iex> Day1.parse_instruction("R2")
    { "R", 2 }

    iex> Day1.parse_instruction("L17")
    { "L", 17 }
  """
  def parse_instruction(instruction) do
    [ _, direction, distance ] = Regex.run(~r/(\D+)(\d+)/, instruction)
    { direction, String.to_integer distance }
  end
end
