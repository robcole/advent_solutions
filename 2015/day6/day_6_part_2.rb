require 'byebug'
class Grid
  attr_accessor :lights
  def initialize(lights: initialize_lights)
    @lights = lights
  end

  def initialize_lights
    boundary = (0..999999).to_a
    Hash[boundary.map { |i| [i, 0] }]
  end

  def build_lights(instruction_text, existing_lights)
    return existing_lights if instruction_text.nil?
    parse!(instruction_text)
  end

  def parse!(instruction_text)
    regex = /(turn on|turn off|toggle) (\d+,\d+) through (\d+,\d+)/
    instr = instruction_text.match regex
    coords1, coords2 = coordinates(instr[2], instr[3])
    methodname = command_for(instr[1])
    new_lights = send(methodname, coords1, coords2)
    self.class.new(lights: new_lights)
  end

  def coordinates(*coords)
    [*coords].
      map { |coord| coord.split(',') }.
      map { |coord| { x: coord[0].to_i, y: coord[1].to_i } }
  end

  def command_for(instruction)
    instruction.gsub(" ", "_").to_sym
  end

  def turn_on(coords1, coords2)
    lights.tap do
      elements_in_grid(coords1, coords2).each do |id|
        lights[id] = lights[id] + 1
      end
    end
  end

  def toggle(coords1, coords2)
    lights.tap do
      elements_in_grid(coords1, coords2).each do |id|
        lights[id] = lights[id] + 2
      end
    end
  end

  def turn_off(coords1, coords2)
    lights.tap do
      elements_in_grid(coords1, coords2).each do |id|
        lights[id] = (lights[id] > 0) ? (lights[id] -1) : 0
      end
    end
  end

  def elements_in_grid(coords1, coords2)
    x_arr = (coords1[:x]..coords2[:x]).to_a
    y_arr = (coords1[:y]..coords2[:y]).to_a
    x_arr.product(y_arr).map { |x, y| (y * 1000) + x }
  end

  def total_brightness
    lights.inject(0) { |result, (k, v)| result += v }
  end
end

class Solution
  def self.solve
    input = File.read('input.txt').split("\n")
    input.inject(Grid.new) do |result, instruction|
      result.parse!(instruction)
    end.total_brightness
  end
end
