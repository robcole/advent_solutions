# Part 1

class Instructions
  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def total_floors_up
    text.split('').count { |e| e == "(" }
  end

  def total_floors_down
    text.split('').count { |e| e == ")" }
  end

  def floor
    total_floors_up - total_floors_down
  end
end

instructions = '((((()(()((('
Instructions.new(instructions).floor
