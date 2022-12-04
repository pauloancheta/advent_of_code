require 'pry'

class Main
  def initialize(input, part = 1)
    @input = input.split("\n")
    @part = part
  end

  def call
    @input.map do |input|
      first, second = input.split(',').map { Range.new(*range.split('-')) }

      method = @part == 1 ? :all? : :any?

      first.send(method) { second.include?(_1) } || second.send(method) { first.include?(_1) }
    end.count(true)
  end
end

test_string = <<~TEXT
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
TEXT

puts Main.new(test_string).call

result_1 = Main.new(File.read('input.txt'), 1).call
result_2 = Main.new(File.read('input.txt'), 2).call

puts "result_1: #{result_1}"
puts "result_2: #{result_2}"
