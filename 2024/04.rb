require 'pry'

def right_diagonal(array)
  length = array.length
  array.each_with_index.map do |line, shift|
    to_append = ('_' * (length - shift)).split('')
    to_prepend = ('_' * shift).split('')

    line += to_append
    to_prepend += line
  end.transpose
end

def left_diagonal(array)
  length = array.length
  array.each_with_index.map do |line, shift|
    to_prepend = ('_' * (length - shift)).split('')
    to_append = ('_' * shift).split('')

    line += to_append
    to_prepend += line
  end.transpose
end

def line_match(array, word)
  instances = 0

  array.each do |line|
    instances += line.join.scan(word).count
  end

  instances
end

def array_match(array, word='XMAS')
  [
    array,
    array.map(&:reverse), # backwards
    array.map(&:reverse).transpose, # downwards
    array.transpose.map(&:reverse), # upwards
    left_diagonal(array),
    left_diagonal(array).map(&:reverse),
    right_diagonal(array),
    right_diagonal(array).map(&:reverse)
  ].inject(0) do |sum, direction|
    sum += line_match(direction, word)
  end
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

test_input = <<~INPUT
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
INPUT

test_input = test_input.split("\n").map { |line| line.split('') }
actual_input = File.read('04_input.txt').split("\n").map { |line| line.split('') }


puts "Part 1"
puts array_match(actual_input)
puts "Part 2"
puts array_match(test_input)



































