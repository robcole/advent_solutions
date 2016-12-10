require 'digest'
require 'byebug'
class Day5
  class << self
    def build_password(door_id, start_index = 0)
      (0..7).to_a.each_with_object(Hash.new) do |pos, memo|
        index = pos.zero? ? start_index : memo[pos - 1][:index] + 1
        memo[pos] = next_password_character(door_id, index)
      end.values.map { |v| v[:character] }.join
    end

    def number_or_nil(string)
      Integer(string || '')
    rescue ArgumentError
      nil
    end

    def build_part2_password(door_id, start_index = 0)
      password_data = (0..7).to_a.each_with_object([]) do |pos, arr|
        index = arr.empty? ? start_index : arr.last[:index] + 1
        arr << next_valid_char_and_pos(door_id, index, arr)
      end

      password_data
        .sort_by { |entry| entry[:position] }
        .map { |entry| entry[:character] }
        .join
    end

    def first_five_zero?(md5)
      md5[0..4] == "00000"
    end

    def valid_md5?(md5, arr)
      first_five_zero?(md5) && valid_position?(md5, arr)
    end

    def valid_position?(md5, arr)
      position = number_or_nil(md5[5])
      position.is_a?(Integer) &&
        position < 8 &&
        arr.detect { |h| h[:position] == position }.nil?
    end

    def next_valid_char_and_pos(door_id, index, arr)
      index.upto(Float::INFINITY) do |i|
        md5 = Digest::MD5.hexdigest("#{door_id}#{i}")
        result = {
          index: i,
          position: number_or_nil(md5[5]),
          character: md5[6]
        }

        return result if valid_md5?(md5, arr)
      end
    end

    def next_password_character(door_id, index)
      index.upto(Float::INFINITY) do |i|
        md5 = Digest::MD5.hexdigest("#{door_id}#{i}")
        return { index: i, character: md5[5] } if first_five_zero?(md5)
      end
    end
  end
end
