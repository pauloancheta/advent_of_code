# rubocop:disable all

require 'pry'
test_input = <<~INPUT
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
INPUT
test_input = test_input
actual_input = File.read('06_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("\n").map { |input| input.split('') }

@can_move = true

def vis(input)
  system "clear"
  input.each do |row|
    row.each { |char| print char }
    puts
  end
  sleep 0.01
end

def guard?(char)
  %w|^ > < V|.include?(char)
end

def find_guard_coordinates(input)
  input.each_with_index do |row, y|
    row.each_with_index do |char, x|
      return [x, y, char] if guard?(char)
    end
  end
end

def move(input)
  x, y, guard = find_guard_coordinates(input)
  next_x, next_y = next_move(x, y, guard)

  if input[next_y].nil? || input[next_x].nil?
    @can_move = false
    input[y][x] = "X"
    return input
  end

  next_char = input[next_y][next_x]
  if should_move?(next_char)
    input[y][x] = "X"
    input[next_y][next_x] = guard
  elsif next_char == "#"
    input[y][x] = replace_guard(guard)
  end

  input
end

def next_move(x, y, guard)
  return [x, y - 1] if guard == '^'
  return [x, y + 1] if guard == 'V'
  return [x - 1, y] if guard == '<'
  return [x + 1, y] if guard == '>'
end

def should_move?(char)
  return false if char == "#"
  true
end

def replace_guard(guard)
  return '>' if guard == '^'
  return 'V' if guard == '>'
  return '<' if guard == 'V'
  return '^' if guard == '<'
end

def run(input)
  while @can_move
    vis move(input)
  end
end


run(input)
puts "Part 1: #{input.flatten.join.count("X")}"
