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

class Point
  attr_reader :x, :y, :node

  def initialize(x, y, node)
    @x = x.to_f
    @y = y.to_f
    @node = node
  end

  def empty?
    !point?
  end

  def point?
    @node.match?(/[a-z|A-Z|\d]/)
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

  def add(point, part: 1)
    return unless has_point?(point)
    return @antinodes << point if part == 2
    return if point == point_1 || point == point_2

    @antinodes << point if equidistant?(point)
  end

  private

  def equidistant?(point)
    initial_distance = distance(point_1, point_2)
    p1_dist = distance(point_1, point)
    p2_dist = distance(point_2, point)

    p1_dist == initial_distance || p2_dist == initial_distance
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

  def has_point?(point)
    left = point.y - point_1.y
    right = slope * ( point.x - point_1.x )

    left == right
  end
end

class Run
  def initialize(input, part)
    @part = part
    @points = []

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

  def call
    find_antinodes
    @lines.flat_map(&:antinodes).uniq.count
  end

  private

  def find_antinodes
    antinodes = Hash.new([])

    @points.each do |point|
      @lines.each do |line|
        line.add(point, part: @part)
      end
    end

    antinodes
  end
end

puts "Part 1: #{Run.new(input, 1).call}"
puts "Part 2: #{Run.new(input, 2).call}"

# ANSWERS
# Part 1: 14
# Part 2: 34
#
# Part 1: 327
# Part 2: 1233
