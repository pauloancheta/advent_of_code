# rubocop:disable all

require 'pry'

class Main
  def initialize(input, part = 1)
    @input = input.split("\n").map.with_index do |row, row_index|
      row.split("").map.with_index do |height, col_index|
        Tree.new(height.to_i, row_index, col_index)
      end
    end
    @row_count = @input.count
    @col_count = @input.first.count
    @part = part
  end

  def call
    @input.each_with_index do |row, row_index|
      row.each_with_index do |tree, col_index|
        visible_from_top(tree, row_index, col_index)
        visible_from_right(tree, row_index, col_index)
        visible_from_bottom(tree, row_index, col_index)
        visible_from_left(tree, row_index, col_index)
      end
    end

    if @part == 1
      @input.flatten.map(&:visible?).count(true)
    else
      sorted = @input.flatten.select(&:visible?).sort_by { _1.scenic_score }
      sorted.last.scenic_score
    end
  end

  def visible_from_top(tree, row_index, col_index)
    return if row_index == 0

    score = 0
    (row_index - 1).downto(0).each do |row|
      height = @input[row][col_index].height
      score += 1

      if height >= tree.height
        tree.v_top = false
        tree.s_top += score
        return
      end
    end

    tree.s_top += score
  end

  def visible_from_right(tree, row_index, col_index)
    edge = @col_count - 1
    score = 0

    return 0 if col_index == edge

    ((col_index + 1)..edge).each do |col|
      height = @input[row_index][col].height
      score += 1

      if height >= tree.height
        tree.v_right = false
        tree.s_right += score
        return
      end
    end

    tree.s_right += score
  end

  def visible_from_bottom(tree, row_index, col_index)
    edge = @row_count - 1
    return 0 if row_index == @row_count - 1

    score = 0
    edge.downto(row_index + 1).each do |row|
      height = @input[row][col_index].height
      score += 1

      if height >= tree.height
        tree.v_bottom = false
        tree.s_bottom += score
        return
      end
    end

    tree.s_bottom += score
  end

  def visible_from_left(tree, row_index, col_index)
    return 0 if col_index == 0

    score = 0
    (col_index - 1).downto(0).each do |col|
      height = @input[row_index][col].height
      score += 1

      if height >= tree.height
        tree.v_left = false
        tree.s_left += score
        return
      end
    end

    tree.s_left += score
  end
end

class Tree
  attr_accessor :v_top, :v_right, :v_left, :v_bottom,
                :s_top, :s_right, :s_left, :s_bottom
  attr_reader :height, :row, :col

  def initialize(height, row, col)
    @height = height
    @row = row
    @col = col

    @v_top = true
    @v_right = true
    @v_left = true
    @v_bottom = true

    @s_top = 0
    @s_right = 0
    @s_left = 0
    @s_bottom = 0
  end

  def visible?
    [v_top, v_right, v_bottom, v_left].any?(true)
  end

  def scenic_score
    s_top * s_right * s_left * s_bottom
  end

  def inspect
    "#<Tree @height=#{height} @visible=#{visible?} @scenic_score=#{scenic_score} @s_top=#{s_top} @s_right=#{s_right} @s_bottom=#{s_bottom} @s_left=#{s_left}>"
  end

  def where
    [row, col]
  end
end

test_string = <<~TEXT
  30373
  25512
  65332
  33549
  35390
TEXT

test_string_2 = <<~TEXT
  00000
  08760
  00000
  00000
TEXT

puts Main.new(test_string, 1).call
puts Main.new(test_string_2, 2).call

result_1 = Main.new(File.read('input.txt'), 1).call
result_2 = Main.new(File.read('input.txt'), 2).call

puts "result_1: #{result_1}"
puts "result_2: #{result_2}"
