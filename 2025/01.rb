class Clock
  MIN, MAX = [0, 99]

  attr_reader :zero_pass, :position

  def initialize(position)
    @position = position
    @zero_pass = 0
  end

  def move(step)
    is_clockwise = step.positive?
    step.abs.times do
      @zero_pass += 1 if @position.zero?
      stepper(clockwise: is_clockwise)
    end
  end

  def stepper(clockwise: true)
    @position = if clockwise
                  @position < MAX ? @position + 1 : MIN
                else
                  @position > MIN ? @position - 1 : MAX
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
