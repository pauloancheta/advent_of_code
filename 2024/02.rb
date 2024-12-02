require 'pry'

actual_input = File.read("01_input.txt")
test_input = <<~INPUT
3   4
4   3
2   5
1   3
3   9
3   3
INPUT

is_actual = ENV["ACTUAL"]
input = is_actual ? actual_input : test_input

# transform input to strings
parsed_input = input.split("\n").map do |string|
  matches = string.match(/(\d+)\s+(\d+)/)
  [matches[1].to_i, matches[2].to_i]
end

# sort
left, right = parsed_input.transpose

# compute
ans = left.sum do |a|
  right.select { |b| a==b }.count * a
end
puts ans
