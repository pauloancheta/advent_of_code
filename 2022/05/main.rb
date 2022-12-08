require 'pry'

class Main
  def initialize(input, part = 1)
    @stacks_string, @moves_string = input.split("\n\n")
    @part = part
  end

  def call
    stacks = Stacks.new(@stacks_string).call
    moves.each do |amount, from, to|
      stacks.each(&:compact!)
      popped = stacks[from - 1].pop(amount)

      new_pop = if @part == 1 || (@part == 2 && amount < 3)
                  popped.reverse
                else
                  popped
                end

      stacks[to - 1].push(*new_pop)
    end

    stacks.map(&:last).join('')
  end

  # [amount, from, to]
  def moves
    @moves_string.split("\n").map do |move|
      move.scan(/\d+/).map(&:to_i)
    end
  end
end

class Stacks
  def initialize(stacks_string)
    @stacks_by_line = stacks_string.split("\n")
  end

  def call
    @stacks_by_line.map do |line|
      parse_line(line)
    end[0..-2].transpose.map(&:reverse)
  end

  private

  def parse_line(line)
    new_line = initialize_array

    line.split('').each_slice(4).with_index do |slice, index|
      match = slice.join.match(/[A-Z]/)
      new_line[index] = match.to_s if match
    end

    new_line
  end

  def initialize_array
    amount_in_array = @stacks_by_line.last[-1].to_i
    Array.new(amount_in_array)
  end
end

test_string = <<~TEXT
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
TEXT

# puts Main.new(test_string, 2).call

result_1 = Main.new(File.read('input.txt'), 1).call
result_2 = Main.new(File.read('input.txt'), 2).call

puts "result_1: #{result_1}"
puts "result_2: #{result_2}"
