class ID
  def initialize(range)
    @range = range
  end

  def sum_palindrome
    @range.sum do |num|
      palindrome?(num.to_s) ? num : 0
    end
  end

  def sum_repeating
    @range.sum do |num|
      string = num.to_s

      if palindrome?(string) || repeating?(string[0], string[1..])
        num
      else
        0
      end
    end
  end

  def palindrome?(string)
    return false if string.size.odd?

    chars = string.chars
    half_index = chars.size / 2

    chars[0...half_index] == chars[half_index..]
  end

  def repeating?(one, two)
    return false if one.size >= two.size
    return true if two.chars.each_slice(one.chars.size).all? { |char| char.join == one }

    repeating?("#{one}#{two[0]}", two[1..])
  end
end

# import and clean test data
input_file_name = ARGV.empty? ? 'test' : ARGV.first
input_ranges = File.read("02_#{input_file_name}.txt")
                   .split(',')
                   .map do |string|
                     min, max = string.split('-')
                     Range.new(min.to_i, max.to_i)
                   end

# main
part1 = input_ranges.sum do |id|
  ID.new(id).sum_palindrome
end
puts part1

part2 = input_ranges.sum do |id|
  ID.new(id).sum_repeating
end
puts part2

# test_1: 1227775554
# test_2: 4174379265
#
# actual_1: 35367539282
# actual_2: 45814076230
