class House
  attr_accessor :x, :y
  def initialize(x:, y:)
    @x = x
    @y = y
  end
end

class Santa
  attr_accessor :x, :y, :houses, :direction
  def initialize(x: 0, y: 0, houses:[], direction: nil)
    @x = x
    @y = y
    @houses = houses.push(new_house_unless_visited(houses)).compact
    @direction = direction
  end

  def new_house
    House.new(x: x, y: y)
  end

  def new_house_unless_visited(all_houses)
    house_visited?(new_house, all_houses) ? nil : new_house
  end

  def house_visited?(house, all_houses)
    all_houses.
      map { |v_house| [v_house.x, v_house.y] }.
      include?([house.x, house.y])
  end

  def move!
    case direction
    when "^"
      self.class.new({ x: x, y: y+1, houses: houses, direction: direction })
    when ">"
      self.class.new({ x: x + 1, y: y, houses: houses, direction: direction })
    when "v"
      self.class.new({ x: x, y: y - 1, houses: houses, direction: direction })
    when "<"
      self.class.new({ x: x - 1, y: y, houses: houses, direction: direction })
    else
      self
    end
  end
end

class Solution
  def self.run(text)
    text.split('').each_with_index.inject([Santa.new.move!]) do |arr, (dir, i)|
      last_santa = arr[i]
      new_santa = Santa.new(x: last_santa.x,
                            y: last_santa.y,
                            direction: dir,
                            houses: last_santa.houses)
      arr.push(new_santa.move!)
    end.last.houses.size
  end
end
