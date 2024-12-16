# rubocop:disable all

require 'pry'

test_input = %w[125 17]
actual_input = %w[0 7 198844 5687836 58 2478 25475 894]

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.map(&:to_i)

def apply_rules(stone)
  return 1 if stone.zero?

  stone_string = stone.to_s.split('')
  if stone_string.count.even?
    slice_count = stone_string.count / 2

    return stone_string.each_slice(slice_count).flat_map do |merp|
      merp.join.to_i
    end
  end

  stone * 2024
end

def blink(int, count, result = 0)
  return 1 if count.zero?

  @cache[[int, count]] ||= [apply_rules(int)].flatten.sum { blink(_1, count - 1, result) }
end

def run(input, count)
  start_time = Time.now
  answer = input.sum { blink(_1, count) }
  end_time = Time.now

  puts "Count #{count}: #{answer}"
  puts "Time elapsed: #{end_time - start_time}"
end

@cache = {}

run input, 25
# Count 25: 216996
# Time elapsed: 0.004866

run input, 75
# Count 75: 257335372288947
# Time elapsed: 0.249056
