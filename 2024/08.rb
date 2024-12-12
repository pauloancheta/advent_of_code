# rubocop:disable all

require 'pry'

test_input = <<~INPUT
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
INPUT

actual_input = File.read('08_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("\n").map { |input| input.split('') }

@points = []
@lines = []
@max_length = input.length - 1

class Point
  attr_reader :x, :y, :node

  def initialize(x, y, node)
    @x = x.to_f
    @y = y.to_f
    @node = node
  end

  def point?
    @node.match?(/[a-z|A-Z|\d]/)
  end

  def empty?
    !@node.match?(/[a-z|A-Z|\d]/)
  end

  def inspect
    "#<Point (#{@x}, #{@y})>"
  end
end

class Line
  attr_reader :point_1, :point_2
  attr_accessor :antinodes

  def initialize(point_1, point_2)
    @point_1, @point_2 = point_1, point_2
    @antinodes = []
  end

  def slope
    run = point_2.x - point_1.x
    rise = point_2.y - point_1.y
    return 0 if run.zero?
    rise / run
  end

  def distance(a, b)
    x = (b.x - a.x) ** 2
    y = (b.y - a.y) ** 2
    Math.sqrt( x + y )
  end

  def add(point, part: 1)
    return if (point == point_1 || point == point_2) && part == 1
    return unless has_point?(point)

    initial_distance = distance(point_1, point_2)
    p1_dist = distance(point_1, point)
    p2_dist = distance(point_2, point)
    equidistant = p1_dist == initial_distance || p2_dist == initial_distance

    if part == 1
      @antinodes << point if equidistant
    else
      @antinodes << point
    end
  end

  def has_point?(point)
    left = point.y - point_1.y
    right = slope * ( point.x - point_1.x )

    left == right
  end
end

def initialize_grid(input)
  input.each_with_index do |row, y|
    row.each_with_index do |char, x|
      @points << Point.new(x, y, char)
    end
  end
  @lines = @points.select(&:point?).combination(2).map do |line|
    p_1, p_2 = line
    Line.new(p_1, p_2) if p_1.node == p_2.node
  end.compact
end

def find_antinodes(input, part: 1)
  antinodes = Hash.new([])

  @points.each do |point|
    @lines.each do |line|
      line.add(point, part:)
    end
  end

  antinodes
end

def draw(input, antinodes)
  antinodes.each do |point|
    input[@max_length - point.y][point.x] = 'O'
  end

  input.each_with_index do |row, index|
    row.each { |char| print char }
    puts
  end
end

# part 1
initialize_grid(input.reverse)
find_antinodes(input, part: 1)
antinodes = @lines.flat_map(&:antinodes).uniq

puts "Part 1: #{antinodes.count}"

# part 2
@lines, @points = [], [] # reset state

initialize_grid(input.reverse)
find_antinodes(input, part: 2)
antinodes = @lines.flat_map(&:antinodes).uniq

puts "Part 2: #{antinodes.count}"
