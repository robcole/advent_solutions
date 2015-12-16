require 'byebug'
require 'set'
class Grid
  attr_accessor :lights, :coords1, :coords2

  def initialize(instruction_text: nil, lights: { on: Set.new, off: Set.new })
    @lights = build_lights(instruction_text: instruction_text, lights: lights)
  end

  def build_lights(instruction_text:, lights:)
    return lights if instruction_text.nil?
    parse!(instruction_text, lights)
  end

  def parse!(instruction_text, lights)
    regex = /(turn on|turn off|toggle) (\d+,\d+) through (\d+,\d+)/
    instr = instruction_text.match regex
    args = coords_to_arr(instr[2], instr[3]).push(lights)
    methodname = command_for(instr[1])
    send(methodname, *args)
  end

  def elements_in_grid(c1, c2)
    x_arr = (c1[0]..c2[0]).to_a
    y_arr = (c1[1]..c2[1]).to_a
    x_arr.product(y_arr).map { |x, y| (y * 1000) + x }.to_set
  end

  def coords_to_arr(*coords)
    [*coords].map { |coord| coord.split(',').map(&:to_i) }
  end

  def turn_on(c1, c2, lights)
    light_layer = elements_in_grid(c1, c2)
    on_lights = lights[:on].merge(light_layer)
    off_lights = lights[:off] - light_layer
    lights.merge({on: on_lights, off: off_lights})
  end

  def turn_off(c1, c2, lights)
    light_layer = elements_in_grid(c1, c2)
    off_lights = lights[:off].merge(light_layer)
    on_lights = lights[:on] - off_lights
    lights.merge({on: on_lights, off: off_lights})
  end

  def toggle(c1, c2, lights)
    light_layer = elements_in_grid(c1, c2)
    on_to_off = lights[:on] & light_layer
    off_to_on = light_layer - on_to_off
    on_lights = off_to_on + lights[:on] - on_to_off
    off_lights = on_to_off + lights[:off] - off_to_on
    lights.merge({on: on_lights, off: off_lights})
  end

  def command_for(instruction)
    instruction.gsub(" ", "_").to_sym
  end
end

class Solution
  def self.solve
    input = File.read('input.txt').split("\n")
    input.inject(Grid.new) do |result, instruction|
      print "."
      Grid.new(instruction_text: instruction, lights: result.lights)
    end.lights
  end
end
