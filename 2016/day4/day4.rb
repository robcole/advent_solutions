require "byebug"

class Day4
  class << self
    def real_room?(room_hash)
      checksum = checksum_from(room_hash)
      letters = letters_from_room_hash(room_hash, checksum)
      ordered_letters = order_letters(letters)
      value = ordered_letters[0..4]
      checksum == "[#{value}]"
    end

    def input
      File.read("input.txt")
    end

    def decode_name(room_hash)
      checksum = checksum_from(room_hash)
      shift_amount = extract_sector_id(room_hash)
      encoded_name = room_hash
                       .gsub(checksum, "")
                       .gsub("-", " ")
                       .gsub(shift_amount.to_s, "")
                       .strip

      decoder_table = shifted_letters(shift_amount)
      encoded_name.gsub(/[a-z]/) { |letter| decoder_table[letter] }
    end

    def find_northpole_objects
      # had to manually find this, stupid instructions
      name = "northpole object storage"
      line = input.lines.detect { |room_hash| decode_name(room_hash) == name }
      extract_sector_id(line)
    end

    def shifted_letters(amount)
      letters = ("a".."z").to_a
      letters.map.with_index do |letter, curr_index|
        total_shift = amount % 26
        new_index = curr_index + total_shift
        new_letter = letters[new_index % 26]
        [letter, new_letter]
      end.to_h
    end

    def sum_real_rooms
      input.lines.inject(0) do |total, room_hash|
        sector_id = extract_sector_id(room_hash)
        real_room?(room_hash) ? (total + sector_id) : total
      end
    end

    def order_letters(letters)
      counted = letters.uniq.group_by do |letter|
        letters.count { |l| l == letter }
      end

      counted.each_with_object({}) do |(k, v), memo|
        memo[k] = v.sort
      end.sort.reverse.flat_map(&:last).join
    end

    def letters_from_room_hash(room_hash, checksum)
      room_hash.gsub(checksum, "").scan(/[a-z]+/).join.split("")
    end

    def checksum_from(room_hash)
      room_hash.match(/\[[a-z]+\]/).to_s
    end

    def extract_sector_id(room_hash)
      room_hash.match(/\d+/)[0].to_i
    end
  end
end
