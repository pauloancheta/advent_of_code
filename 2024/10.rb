# rubocop:disable all

require 'pry'

test_input = <<~INPUT
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
INPUT

actual_input = File.read('10_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("\n").map { |input| input.split('') }

class Point
  attr_reader :x, :y, :value

  def initialize(x, y, value)
    @x, @y, @value = x, y, Integer(value)
  end

  def start?
    value.zero?
  end

  def peak?
    value == 9
  end

  def next_value
    if !peak?
      value + 1
    else
      nil
    end
  end

  def inspect
    "#<Point (#{@x}, #{@y}) @value=#{@value}>"
  end
end

class Map
  attr_reader :points, :max_x, :max_y, :part

  def initialize(input, part)
    @points = []
    input.each_with_index do |row, y|
      row.each_with_index do |value, x|
        @points << Point.new(x, y, value)
      end
    end

    @max_x = input.first.length
    @max_y = input.length
    @part = part
  end

  def count_paths
    starting_points.map do |point|
      if part == 1
        paths(point).uniq.count
      else
        paths(point).count
      end
    end.sum
  end

  def paths(point, result = [])
    result << point if point.peak?

    surrounding_points(point).each do |next_point|
      result = paths(next_point, result)
    end

    result
  end

  def starting_points
    @points.select(&:start?)
  end

  def surrounding_points(point)
    x, y, next_value = point.x, point.y, point.next_value
    # left       right       down        up
    [[x - 1, y], [x + 1, y], [x, y + 1], [x, y - 1]]
      .filter { |x, y| within_bounds?(x, y) }
      .map { |x, y| find(x, y) }
      .select { |point| point.value == next_value }
  end

  def find(x, y)
    @points.find { |point| point.x == x && point.y == y}
  end

  def within_bounds?(x, y)
    x >= 0 && y >= 0 && x < max_x && y < max_y
  end
end

part_1 = Map.new(input, 1).count_paths
puts "Part 1: #{part_1}"

part_2 = Map.new(input, 2).count_paths
puts "Part 2: #{part_2}"
