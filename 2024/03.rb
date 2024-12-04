is_actual = ENV['ACTUAL']
test_input = 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))'
actual_input = File.read('03_input.txt')

input = is_actual ? actual_input : test_input

def mul(x, y)
  x * y
end

matches = input.scan(/mul\(\d{1,3},\d{1,3}\)/)
result =  matches.sum { |a| self.eval(a) }
puts "part 1: #{result}"

test_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
input = is_actual ? actual_input : test_input

matches = input.scan(/(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/).flatten
should = true

result = matches.inject(0) do |sum, a|
  case a
  when 'do()'
    should = true
  when "don't()"
    should = false
  else
    sum += self.eval(a) if should
  end
  sum
end

puts "part 2: #{result}"
