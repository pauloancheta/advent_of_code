require 'pry'

PART_1 = 2
PART_2 = 12

def max(cells, compare)
  return compare.join.to_i if cells.empty?

  next_int = cells.shift
  left, *right = compare

  new_compare = reject_lowest([left], right, next_int)

  max(cells, new_compare)
end

def reject_lowest(left, right, next_int)
  if right.empty?
    if left.last < next_int
      left.pop
      left << next_int
    end

    return left
  end

  if left.last < right.first
    left.pop
    return [*left, *right, next_int]
  end

  left << right.shift
  reject_lowest(left, right, next_int)
end

# import and clean test data
input_file_name = ARGV.empty? ? 'test' : ARGV.first
batteries = File.read("03_#{input_file_name}.txt")
                .split("\n")
                .map do |string|
                  string.chars.map(&:to_i)
                end

# main
sum = batteries.sum do |cells|
  compare = cells.shift(PART_2) # use PART_2 for part 2
  max(cells, compare)
end
puts sum

# test1: 357
# test2: 3121910778619
#
# part1: 17445
# part2: 173229689350551
