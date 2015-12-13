require 'digest'
SECRET = "ckczppom"

def first_valid_index(starting_index = 0, matching_rule)
  until matching_rule.call(starting_index)
    starting_index += 1
  end
  starting_index
end

# Solution
# rule = ->(index) { Digest::MD5.hexdigest("#{SECRET}#{index}")[0..5] == "000000" }
# first_valid_index(0, rule)
