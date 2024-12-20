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

# There's only 2 distinct ways to go to a coordinate horizontal, and vertical
# because we only turn to one direction (right). We can therefore say if we
# reached a coordinate the 3rd time, that guarantees a loop
MAX_VISIT_BEFORE_LOOP = 3

@x, @y, @move_count, @loop = 0, 0, 0, 0
@visited = Hash.new { |k,v| v = 0 }
@block_history = Hash.new { |k,v| v = 0 }
@try_loop = true
@current_block = []

def vis(input)
  input.each do |row|
    row.each { |char| print char }
    puts
  end
  puts "#{@block_history.count} loop: #{@loop}"
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

def run
  loop do
    calculate_next_move
    if out_of_bounds?
      break if @current_block.empty?
      reset!
    elsif @visited[[@x, @y]] > MAX_VISIT_BEFORE_LOOP
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

start = Time.now

# initialize pointer values
find_pointer(input)
@orig_x, @orig_y, @orig_pointer = @x, @y, @pointer
@max_x, @max_y = @input.first.length, @input.length

run
puts "Visited count #{@visited.count}"
puts "Loop count: #{@loop}"
end_time = Time.now
puts "Time elapsed: #{end_time - start} seconds"
