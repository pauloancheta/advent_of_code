# rubocop:disable all

test_input = <<~INPUT
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
INPUT
actual_input = File.read('07_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("\n").map do |row|
  key, value = row.split(':')
  [key.to_i, value.split(" ").map(&:to_i)]
end

def permutations(digits, current = [], operators)
  return [current] if current.length == digits

  result = []
  operators.each do |i|
    result += permutations(digits, current + [i], operators)
  end
  result
end

def target_equal?(target, integers, comb)
  return false if comb.last == "||" && target.to_s[-1] != integers.last.to_s[-1]
  return false if comb.last == "*" && target % integers.last != 0

  initial = integers.shift
  result = integers.inject(initial) do |memo, i|
    break 0 if memo > target
    eq = comb.shift
    to_eval = eq == "||" ? [memo, i] : [memo, eq, i]
    memo = eval(to_eval.join)
  end

  target == result
end

def run(input, operators)
  Parallel.map(input, in_processes: 8) do |target, integers|
    comb = permutations(integers.length - 1, operators)
    if comb.any? { |c| target_equal?(target, integers.dup, c) }
      target
    else
      0
    end
  end.sum
end

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'parallel'
end

puts "Part 1: #{run(input, %w[* +])}"
puts "Part 2: #{run(input, %w[* + ||])}"
