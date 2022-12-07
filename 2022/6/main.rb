require 'pry'

class Main
  def initialize(input, part = 1)
    @input = input.split("")
    @marker_length = part == 1 ? 4 : 14
  end

  def call
    markers = []
    @input.each_with_index do |letter, index|
      markers << letter
      markers.shift if markers.count > @marker_length
      return index + 1 if markers.uniq.count == @marker_length
    end
  end
end

test_string = <<~TEXT
bvwbjplbgvbhsrlpgdmjqwftvncz
TEXT

puts Main.new(test_string, 1).call

result_1 = Main.new(File.read('input.txt'), 1).call
result_2 = Main.new(File.read('input.txt'), 2).call

puts "result_1: #{result_1}"
puts "result_2: #{result_2}"
