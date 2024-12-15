# rubocop:disable all

require 'pry'

test_input = "2333133121414131402"
actual_input = File.read('09_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("").map(&:to_i)

SPACE_CHAR = '.'

class Block
  attr_reader :id
  attr_accessor :size, :skip

  def initialize(id, size = 0, skip = false)
    @id = id
    @size = size
    @skip = skip
  end

  def space?
    @id == SPACE_CHAR
  end

  def to_s
    id.to_s * size
  end

  def print
    size.times.map { self }
  end
end

def initialize_blocks(input)
  file_index = 0
  input.each_with_index.flat_map do |count, index|
    if index.even?
      blocks = Block.new(file_index, count)
      file_index += 1
      blocks
    else
      Block.new('.', count) if count > 0
    end
  end.compact
end

def rearrange(blocks, offset = 0)
  index_of_last_file = blocks.rindex { !_1.space? && !_1.skip }
  file_block = blocks[index_of_last_file]
  file_block.skip = true

  index_of_first_space = blocks[0..index_of_last_file].index do |block|
    block.space? && block.size >= file_block.size
  end

  if !index_of_first_space.nil?
    space_block = blocks[index_of_first_space]

    if file_block.size < space_block.size
      space_block.size = space_block.size - file_block.size
      blocks[index_of_first_space] = space_block
      blocks[index_of_last_file] = Block.new('.', file_block.size)
      blocks.insert(index_of_first_space, file_block)
    else
      blocks.delete_at(index_of_first_space)
      blocks.insert(index_of_first_space, file_block)
      blocks[index_of_last_file] = Block.new('.', file_block.size)
    end
  end
end

def add_blocks(blocks)
  blocks
    .flat_map(&:print)
    .each_with_index
    .sum { |i,index| i.id.to_i * index }
end

def run(input)
  blocks = initialize_blocks(input)
  rerun = true

  while(rerun) do
    rearrange(blocks)
    rerun = false if blocks.select { !_1.space? }
                           .all? { _1.skip }
  end

  add_blocks(blocks)
end

puts run(input)
# Part 2
# 6347435485773
