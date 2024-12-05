require 'pry'

def string_to_a(array)
  array.split("\n").map { |line| line.split('') }
end

def vis(array)
  puts "----------------------------"
  array.each do |line|
    line.each { |char| print " #{char} " }
    puts
  end
  puts "----------------------------"
  nil
end

test_input = string_to_a <<~INPUT
  .M.S......
  ..A..MSMS.
  .M.S.MAA..
  ..A.ASMSM.
  .M.S.M....
  ..........
  S.S.S.S.S.
  .A.A.A.A..
  M.M.M.M.M.
  ..........
INPUT
actual_input = string_to_a(File.read('04_input.txt'))

@match = string_to_a <<~INPUT
  M.M
  .A.
  S.S
INPUT

def xmas_match(array, x, y)
  coord = array[x..(x + 2)].map { |line| line[y..(y + 2)] }
  score = 0
  [@match, @match.reverse, @match.transpose, @match.reverse.transpose].each do |match|
    coord.each_with_index do |line, index|
      score += 1 if line.join.match?(match[index].join)
    end
    if score == 3
      return true
    else
      score = 0
    end
  end
  false
end

def loop_array(array)
  count = 0
  y_max = array.length
  x_max = array.first.length

  (0..y_max).to_a.each do |y|
    (0..x_max).to_a.each do |x|
      count += 1 if xmas_match(array, x, y)
    end
  end

  count
end

puts "Part 1: #{loop_array(test_input)}"
puts "Part 2: #{loop_array(actual_input)}"
