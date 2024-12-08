# rubocop:disable all

require 'pry'
test_input = <<~INPUT
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ....0.....
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
@loop = 0
@maybe_loop = 0
@looped = true
@block_blacklist = []
@runlist = []

def vis(input)
  system "clear"
  input.each do |row|
    row.each { |char| print char }
    puts
  end

  print "maybe_loop #{@maybe_loop}\n"
  print "loop #{@loop}\n"
  print "block_blacklist #{@block_blacklist}\n"
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

def next_move(x, y, guard)
  return [x, y - 1] if guard == '^'
  return [x, y + 1] if guard == 'V'
  return [x - 1, y] if guard == '<'
  return [x + 1, y] if guard == '>'
end

def should_move?(char)
  return false if char == "#" || char == "O"
  true
end

def replace_guard(guard)
  return '>' if guard == '^'
  return 'V' if guard == '>'
  return '<' if guard == 'V'
  return '^' if guard == '<'
end

def terminate(input, x, y)
  if input[y].nil? || input[y][x].nil? || x.negative? || y.negative?
    @can_move = false
    return true
  end

  if @maybe_loop == 2
    @can_move = false
    @loop += 1
    return true
  end

  false
end

def add_block(input, x, y, guard)
  block_x, block_y = next_move(x, y, guard)
  return if input[block_y].nil? || input[block_y][block_x] == "#"
  return if has_loop?(input)

  if !@block_blacklist.include?([block_x, block_y])
    input[block_y][block_x] = "O"
    @block_blacklist << [block_x, block_y]
  else
    # add_block(input, block_x, block_y, guard)
  end
end

def move(input)
  x, y, guard = find_guard_coordinates(input)
  next_x, next_y = next_move(x, y, guard)

  return input if terminate(input, next_x, next_y)

  next_char = input[next_y][next_x]

  if should_move?(next_char)
    add_block(input, next_x, next_y, guard)
    input[y][x] = "X"
    input[next_y][next_x] = guard

  elsif next_char == "#" || next_char == "O"
    input[y][x] = replace_guard(guard)

    @maybe_loop += 1 if next_char == "O"
  end

  input
end

def has_loop?(input)
  input.flatten.join.include?("O")
end

def restart!(input, x, y, guard)
  new_x, new_y, _guard = find_guard_coordinates(input)
  input[new_y][new_x] = "."

  input.each_with_index do |row, y|
    row.each_with_index do |char, x|
      input[y][x] = "." if char == "O" || char == "X"
    end
  end

  input[y][x] = guard
  @can_move = true
  @maybe_loop = 0
end

def run(input)
  original_x, original_y, original_guard = find_guard_coordinates(input)
  while @can_move
    if ENV["ACTUAL"]
      move(input)
    else
      vis move(input)
    end

    restart!(input, original_x, original_y, original_guard) if has_loop?(input) && !@can_move
  end
end

run(input)
puts "Part 1: #{input.flatten.join.count("X") + 1}"
puts "Part 2: #{@loop}"
