require 'pry'

# import and clean test data
input_file_name = ARGV.empty? ? 'test' : ARGV.first
ranges, ingredients = File.read("05_#{input_file_name}.txt").split("\n\n")

ranges = ranges.split("\n").map do |range|
  min, max = range.split('-')
  Range.new(min.to_i, max.to_i)
end
ingredients = ingredients.split("\n").map(&:to_i)

part1 = ingredients.sum { |ingredient|
  res = ranges.any? { |range| range.include?(ingredient) }
  res ? 1 : 0
}

puts part1
# test1: 3
# part1: 761

@cache = ranges
@old_cache = @cache.dup

def merge_range(range)
  min, max = [range.min, range.max]

  rejected = []
  @cache.reject! do |cached_range|
    res = cached_range.cover?(min) || cached_range.cover?(max)
    rejected << cached_range if res
    res
  end

  rejected_min = rejected.min { |a, b| a.min <=> b.min }&.min || min
  rejected_max = rejected.max { |a, b| a.max <=> b.max }&.max || max

  @cache << Range.new([min, rejected_min].min, [max, rejected_max].max)
end

loop do
  # the resulting range may still have overlap from previous resulting range
  ranges.each { merge_range _1 }
  break if @old_cache.count == @cache.count

  @old_cache = @cache.dup
end

part2 = @cache.sum(&:size)
pp part2

# test2: 14
# part2: 345755049374932
