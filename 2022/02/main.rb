require 'pry'

class Main
  SANITIZED_MOVES_1 = {
    'A' => :rock, 'B' => :paper, 'C' => :scissors,
    'X' => :rock, 'Y' => :paper, 'Z' => :scissors
  }
  SANITIZED_MOVES_2 = {
    'A' => :rock, 'B' => :paper, 'C' => :scissors
  }
  OUTCOME = { 'X' => :lose, 'Y' => :draw, 'Z' => :win }

  def initialize(input, part = 1)
    @input = input.split("\n")
    @part = part
  end

  def call
    @input.map do |match|
      left, right = match.split
      if @part == 1
        Wrong.new(sanitize(left), sanitize(right)).call
      else
        GetPoint.new(sanitize(left), OUTCOME.fetch(right)).call
      end
    end
  end

  private

  def sanitize(move)
    return SANITIZED_MOVES_1.fetch(move) if @part == 1
    SANITIZED_MOVES_2.fetch(move)
  end
end

class Wrong
  MOVE_SCORE = { rock: 1, paper: 2, scissors: 3 }.freeze
  WIN_POINT = { lose: 0, draw: 3, win: 6 }.freeze
  attr_reader :opponent_move, :my_move

  def initialize(opponent_move, my_move)
    @opponent_move = opponent_move
    @my_move = my_move
  end

  def call
    MOVE_SCORE.fetch(my_move) + WIN_POINT.fetch(outcome)
  end

  private

  def outcome
    return :draw if opponent_move == my_move

    case opponent_move
    when :rock
      return :lose if my_move == :scissors
      return :win if my_move == :paper
    when :paper
      return :lose if my_move == :rock
      return :win if my_move == :scissors
    else
      return :lose if my_move == :paper
      return :win if my_move == :rock
    end
  end
end

class GetPoint
  MOVE_SCORE = { rock: 1, paper: 2, scissors: 3 }.freeze
  WIN_POINT = { lose: 0, draw: 3, win: 6 }.freeze

  attr_reader :opponent_move, :outcome

  def initialize(opponent_move, outcome)
    @opponent_move = opponent_move
    @outcome = outcome
  end

  def call
    MOVE_SCORE.fetch(my_move) + WIN_POINT.fetch(outcome)
  end

  private

  def my_move
    return opponent_move if outcome == :draw

    if outcome == :win
      return :paper if opponent_move == :rock
      return :scissors if opponent_move == :paper
      return :rock if opponent_move == :scissors
    else
      return :scissors if opponent_move == :rock
      return :rock if opponent_move == :paper
      return :paper if opponent_move == :scissors
    end
  end
end

result_1 = Main.new(File.read('input.txt'), 1).call.sum
result_2 = Main.new(File.read('input.txt'), 2).call.sum
puts "total_point for part 1: #{result_1}"
puts "total_point for part 2: #{result_2}"
