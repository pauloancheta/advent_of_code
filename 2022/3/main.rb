require 'pry'

class Main
  def initialize(input, part = 1)
    @input = input.split("\n")
    @part = part
  end

  def call
    @part == 1 ? part_1 : part_2
  end

  private

  def part_1
    @input.map do |input|
      items = input.split("").each_slice(input.size / 2).map(&:to_a)

      GetPriority.new(items).call
    end.sum
  end

  def part_2
    collection = []
    @input.each_slice(3) do |items|
      split_items = items.map { _1.split("") }
      collection << GetPriority.new(split_items).call
    end
    collection.sum
  end
end

class GetPriority
  LOWER = ("a".."z").to_a
  UPPER = ("A".."Z").to_a

  attr_reader :first, :second, :third

  def initialize(items)
    @first, @second, @third = items
    @third = [] if @third.nil?
  end

  def call
    res = (first & second & third).first || (first & second).first
    get_point(res)
  end

  private

  def get_point(letter)
    res = LOWER.index(letter)
    return res + 1 if res

    UPPER.index(letter) + 27
  end
end

result_1 = Main.new(File.read('input.txt'), 1).call
result_2 = Main.new(File.read('input.txt'), 2).call

puts "result_1: #{result_1}"
puts "result_2: #{result_2}"
