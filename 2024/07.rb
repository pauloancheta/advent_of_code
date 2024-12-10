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


def guess_operators(result, integers, comb)
  eq = integers.zip(comb).flatten.compact

  slow_result = eq.shift
  eq.each do |int|
    is_integer = int.is_a?(Integer)

    slow_result = "#{slow_result} #{int}"
    slow_result = if is_integer && slow_result.include?("||")
                    eval(slow_result.delete(" || "))
                  elsif is_integer
                    eval(slow_result)
                  else
                    slow_result
                  end
  end

  result == slow_result
end

def permutations(digits, current = [], operators)
  return [current] if current.length == digits

  result = []
  operators.each do |i|
    result += permutations(digits, current + [i], operators)
  end
  result
end

def run(input, operators)
  keys = []

  input.each_with_index do |(result, integers), index|
    comb = permutations(integers.length - 1, operators)
    still_finding = true

    comb.each do |c|
      next unless still_finding
      if still_finding && guess_operators(result, integers, c)
        keys << result
        still_finding = false
      end
    end
  end

  keys.sum
end

part_1 = %w[* +]
part_2 = %w[* + ||]

puts "Part 1: #{run(input, part_1)}"
puts "Part 2: #{run(input, part_2)}"
