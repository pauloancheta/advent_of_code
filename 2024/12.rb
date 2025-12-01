# rubocop:disable all

require 'pry'

test_input = <<~INPUT
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
INPUT

actual_input = File.read('12_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("\n").map { |input| input.split('') }

MAX_X = input.first.length
MAX_Y = input.length

class Point
  attr_reader :x, :y, :value

  def initialize(x, y, value)
    @x, @y, @value = x, y, value
  end

  def coords
    [x, y]
  end

  def inspect
    "#<Point (#{x}, #{y}) @value=#{value}>"
  end
end

class Cluster
  attr_reader :points, :map_points
  attr_accessor :value

  def initialize(point, map_points)
    @points = [point]
    @value = point.value
    @map_points = map_points
  end

  def empty?
    points.empty?
  end

  def <<(point)
    points << point if point.value == value
  end

  def surrounding_coordinates(bounded = true)
    points.flat_map do |point|
      cross(point).map do |x, y|
        if bounded && within_bounds?(x, y) && find(x, y).value == value
          find(x, y)
        elsif !points.any? { |po| po.x == x && po.y == y }
          point
        end
      end
    end.compact
  end

  def price
    binding.pry
    perimeter = surrounding_coordinates(false).count
    area = points.count
    area * perimeter
  end

  def price_2
    # count the vertices
    #   is a vertix if the point does not include a diagonal
    vertices = points.flat_map do |point|
    end
    area * vertices.count
  end

  private

  def cross(point)
    x, y = point.x, point.y
    # left       right       down        up
    [[x - 1, y], [x + 1, y], [x, y + 1], [x, y - 1]]
  end

  def diagonal(point)
    x, y = point.x, point.y
    # upper left     upper right     lower left      lower right
    [[x - 1, y - 1], [x + 1, y - 1], [x - 1, y + 1], [x - 1, y - 1]]
  end

  def within_bounds?(x, y)
    x >= 0 && y >= 0 && x < MAX_X && y < MAX_Y
  end

  def find(x, y)
    map_points.find { |point| point.x == x && point.y == y}
  end
end

class Map
  attr_reader :points, :part, :clusters

  def initialize(input, part)
    @points = []
    @part = part
    @clusters = []
    @cache = {}

    initialize_points(input)
    initialize_clusters
  end

  def all_cluster_price
    clusters.sum { |c| part == 1 ? c.price : c.price_2 }
  end

  private

  def initialize_points(input)
    input.each_with_index do |row, y|
      row.each_with_index do |value, x|
        points << Point.new(x, y, value)
      end
    end
  end

  def recursive_cluster(cluster)
    cluster.surrounding_coordinates.each do |point|
      next if @cache[point.coords]

      cluster.points << point
      @cache[point.coords] = true
      recursive_cluster(cluster)
    end

    cluster
  end

  def find(x, y)
    points.find { |point| point.x == x && point.y == y}
  end

  def initialize_clusters
    points.each do |point|
      next if @cache[point.coords]

      cluster = Cluster.new(point, points)
      @cache[point.coords] = true
      clusters << recursive_cluster(cluster)
    end
  end
end

puts Map.new(input, 1).all_cluster_price
