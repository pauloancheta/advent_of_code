require 'pry'

PAPER = '@'.freeze

def get_adjacent(position)
  x, y = position

  return false unless @floor[y][x] == PAPER

  x_max = @floor[0].size - 1
  y_max = @floor.size - 1

  l = x - 1
  r = x + 1
  u = y - 1
  d = y + 1

  around = [
    [l, y], [r, y], # horizontal
    [x, d], [x, u], # vertical
    [l, u], [l, d], [r, u], [r, d] # diagonal
  ]

  all = around.map do |x_index, y_index|
    next if x_index.negative? || y_index.negative?
    next if x_index > x_max
    next if y_index > y_max
    next if position == [x_index, y_index]

    @floor[y_index][x_index]
  end.compact

  all.count(PAPER) < 4
end

def run(recurse: false)
  papers = []
  @floor.each_with_index do |y, y_index|
    y.each_with_index do |x, x_index|
      if get_adjacent([x_index, y_index])
        papers << [x_index, y_index]
        @count += 1
      end
    end
  end
  return if papers.empty?

  papers.each do |paper_coords|
    x, y = paper_coords
    @floor[y][x] = 'x'
  end

  run(recurse:)
end

# import and clean test data
input_file_name = ARGV.empty? ? 'test' : ARGV.first
@floor = File.read("04_#{input_file_name}.txt")
             .split("\n")
             .map { _1.chars }
@count = 0
run(recurse: true) # do not recurse for part 1
puts @count

# test1: 13
# test2: 43
#
# part1: 1551
# part2: 9784
