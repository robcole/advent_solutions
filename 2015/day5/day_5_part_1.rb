
class Rules
  attr_accessor :string, :bad_strings
  def initialize(string:, bad_strings:)
    puts "Checking #{string}..."
    @string = string
    @bad_strings = bad_strings
  end

  def chars
    @chars ||= string.chars
  end

  def valid?
    return three_vowels? && cons_duplicate_chars? && does_not_contain_bad_strings?
  end

  def three_vowels?
    chars.count { |char| char =~ /a|e|i|o|u/ } >= 3
  end

  def cons_duplicate_chars?(cons_chars = 2)
    chars.each_cons(cons_chars).count { |pair| pair[0] == pair[1] } >= 1
  end

  def does_not_contain_bad_strings?
    bad_strings.count { |str| string.include?(str) } == 0
  end
end

class FindValidStrings
  def self.run(strings:, bad_strings: nil)
    bad_strings ||= %w(ab cd pq xy)
    [*strings].count do |string|
      Rules.new(string: string, bad_strings: bad_strings).valid?
    end
  end
end

input = File.read('day5_input.txt').split("\n")
FindValidStrings.run(strings: input)
