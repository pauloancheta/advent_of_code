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
actual_input = File.read('06_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("\n").map { |input| input.split('') }

@x, @y, @move_count, @loop, @run_count = 0, 0, 0, 0, 0
@pointer = ""
@visited = Hash.new { |k,v| v = 0 }
@block_history = Hash.new { |k,v| v = 0 }
@loop_history = Hash.new { |k,v| v = 0 }
@try_loop = true
@current_block = []

def vis(input)
  input.each do |row|
    row.each { |char| print char }
    puts
  end
  puts "#{@block_history.count} loop: #{@loop}" if @run_count % 100_000 == 0
end

def find_pointer(input)
  @input = input
  input.each_with_index do |row, y|
    row.each_with_index do |char, x|
      if %w[> < V ^].include?(char)
        @x = x
        @y = y
        @pointer = char
      end
    end
  end
end

def move_list
  return [1, 0] if @pointer == ">"
  return [-1, 0] if @pointer == "<"
  return [0, 1] if @pointer == "V"
  return [0, -1] if @pointer == "^"
end

def rotate_pointer
  case @pointer
  when ">"
    @pointer = 'V'
  when "V"
    @pointer = '<'
  when "<"
    @pointer = '^'
  when "^"
    @pointer = '>'
  end
end

def calculate_next_move
  change_x, change_y = move_list
  @next_x, @next_y = [@x + change_x, @y + change_y]
end

def step
  @visited[[@x, @y]] += 1
  return rotate_pointer if @input[@next_y][@next_x] == '#' || [@next_x, @next_y] == @current_block

  @x = @next_x
  @y = @next_y
end

def add_blocks
  return if !@current_block.empty?
  return if @input[@next_y][@next_x] == "#"

  if @block_history[[@next_x, @next_y]] == 0
    @current_block = [@next_x, @next_y]
    @block_history[@current_block] += 1
  end
end

def out_of_bounds?
  @input[@next_y].nil? || @input[@next_y][@next_x].nil? || @next_x.negative? || @next_y.negative?
end

def reset!
  return if @current_block.empty?

  @current_block = []
  @x, @y, @pointer = @orig_x, @orig_y, @orig_pointer
  @visited = Hash.new { |k,v| v = 0 }
end

def looped?
  @visited[[@x, @y]] > 3 # break from infinite loop
end

def run
  loop do
    @run_count += 1
    calculate_next_move
    if out_of_bounds?
      break if @current_block.empty?
      reset!
    elsif looped?
      @loop_history[@current_block] += 1
      @loop += 1
      reset!
    else
      add_blocks
      step
    end
    @input
  end

  # mark the last visited
  @visited[[@x, @y]] += 1
end

# initialize pointer values
find_pointer(input)
@orig_x, @orig_y, @orig_pointer = @x, @y, @pointer
@max_x, @max_y = @input.first.length, @input.length

run
puts @visited.count
puts "final loop count: #{@loop_history.count}"
puts "final block_history count: #{@block_history.count}"

@loop_history.each do |key, value|
  x, y = key
  @input[y][x] = "O"
end
