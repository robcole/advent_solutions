class Rule
  attr_accessor :string
  def initialize(string: nil)
    @string = string
  end

  def chars
    @chars ||= string.chars
  end

  def repeated_non_overlapping_pairs?
    repeated_nonoverlapping_pair_counts.select { |k, v| v >= 2 }.any?
  end

  def repeated_nonoverlapping_pair_counts
    counted_pairs = pairs.
                      chunk { |x| x }.
                      map { |pair, pair_arr| [pair, pair_arr.size] }
    counted_pairs.inject({}) do |result, (pair, count)|
      result[pair] ||= 0
      non_overlapping_count = (count == 1) ? count : count - 1
      result[pair] += non_overlapping_count
      result
    end
  end

  def pairs
    chars.each_cons(2).map(&:join)
  end

  def repeated_pairs
    pairs.group_by { |a| a }.select { |k, v| v.size > 1 }.values.flatten.uniq
  end

  def repeated_pair?
    repeated_pairs.size > 1
  end

  def three_vowels?
    chars.count { |char| char =~ /a|e|i|o|u/ } >= 3
  end

  def cons_duplicate_chars?(cons_chars = 2)
    chars.each_cons(cons_chars).to_a.flatten.uniq.size == 1
  end

  def does_not_contain_bad_strings?
    bad_strings.count { |str| string.include?(str) } == 0
  end

  def repeating_letter_with_separator?
    chars.each_cons(3).count { |group| group[0] == group[2] } > 0
  end
end

class FindValidStrings
  attr_accessor :rules
  def self.run(strings:, rules:)
    [*strings].count do |string|
      valid_string?(rules, string) == true
    end
  end

  def self.valid_string?(rules, string)
    rules.map do |rule|
      Rule.new(string: string).send(rule)
    end.flatten.uniq == [true]
  end
end

# Solution
# rules = [ :repeated_non_overlapping_pairs?, :repeating_letter_with_separator? ]
# input = File.read('day5_input.txt').split("\n")
# FindValidStrings.run(strings: input, rules: rules)
