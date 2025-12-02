class Clock
  MIN, MAX = [0, 99]

  attr_reader :zero_pass, :position

  def initialize(position)
    @position = position
    @zero_pass = 0
  end

  def move(step)
    step.abs.times do
      @zero_pass += 1 if @position.zero?
      stepper(clockwise: step.positive?)
    end
  end

  def stepper(clockwise: true)
    if clockwise
      @position < MAX ? @position += 1 : @position = MIN
    else
      @position > MIN ? @position -= 1 : @position = MAX
    end
  end
end

# import and clean test data
input_file_name = ARGV.empty? ? 'test' : ARGV.first
input = File.read("01_#{input_file_name}.txt")
            .gsub('R', '')
            .gsub('L', '-')
            .split("\n")

# main
clock = Clock.new(50)

result = input.map do |step|
  clock.move(step.to_i)
  clock.position
end

# test_1: 3
# test_2: 6
#
# actual_1: 1139
# actual_2: 6684
puts result.count(0)
puts clock.zero_pass
