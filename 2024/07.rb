# rubocop:disable all

require 'pry'

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

def guess_operators(target, integers, comb)
  initial = integers.shift
  result = integers.inject(initial) do |memo, i|
    eq = comb.shift
    to_eval = if eq == "||"
                [memo, i].join
              else
                [memo, eq, i].join(' ')
              end
    memo = eval(to_eval)
  end

  target == result
end

def run(input, operators)
  keys = []

  input.each do |target, integers|
    comb = permutations(integers.length - 1, operators)
    still_finding = true

    comb.each do |c|
      break unless still_finding
      if still_finding && guess_operators(target, integers.dup, c.dup)
        keys << target
        still_finding = false
      end
    end
  end

  keys.sum
end

part_1 = %w[* +]
part_2 = %w[* + ||]

# puts "Part 1: #{run(input, part_1)}"

start_time = Time.now
puts "Part 2: #{run(input, part_2)}"
end_time = Time.now
puts "time: #{ end_time - start_time }"

# 328790210468594
# 296
