require 'pry'

INPUT_FILE = "input.txt"

class Main
  attr_reader :elves

  def initialize(input)
    @elves = []
    input.split("\n\n").each_with_index do |calories, index|
      @elves << Elf.new(index, calories)
    end
    self
  end

  def sort_by_calories
    @elves.sort { |a,b| b.total_calories <=> a.total_calories }
  end
end

class Elf
  attr_reader :id, :total_calories

  def initialize(id, calories_string)
    @id = id
    @total_calories = calories_string.split("\n").map(&:to_i).sum
  end
end

input = File.read(INPUT_FILE)
elves = Main.new(input).sort_by_calories

# answer_1
puts elves.first.total_calories

# answer 2
puts elves[0..2].map(&:total_calories).sum
