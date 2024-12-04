actual_input = File.read('02_input.txt')
test_input = <<~INPUT
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
INPUT

is_actual = ENV['ACTUAL']
input = is_actual ? actual_input : test_input

# transform input to integers
parsed_input = input.split("\n").map { |line| line.split(' ').map(&:to_i) }

# safe if direction does not change
def sorted?(line)
  sorted = line.sort
  sorted == line || sorted.reverse == line
end

# safe if gap between numbers are 1..3
def safe_from_gap?(line)
  last_num = line.first
  line[1..].each do |num|
    return false unless (last_num - num).abs.between?(1, 3)

    last_num = num
  end
  true
end

def safe?(line)
  sorted?(line) && safe_from_gap?(line)
end

# PART 1
result = parsed_input.map { |line| safe?(line) }
puts "Part 1: #{result.count(true)}"

# PART 2
result = parsed_input.map do |line|
  partial = safe?(line)

  # if dropping one is fine, then it should return true
  unless partial
    line.each_with_index do |_, index|
      line_dup = line.dup
      line_dup.delete_at(index)

      if safe?(line_dup)
        partial = true
        break
      end
    end
  end

  partial
end

puts "Part 2: #{result.count(true)}"
