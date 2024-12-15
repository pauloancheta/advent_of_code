# rubocop:disable all

require 'pry'

test_input = "2333133121414131402"
actual_input = File.read('09_input.txt')

input = ENV['ACTUAL'].nil? ? test_input : actual_input
input = input.split("").map(&:to_i)

SPACE_CHAR = '.'

class Block
  attr_reader :id

  def initialize(id = SPACE_CHAR)
    @id = id
  end

  def space?
    @id == SPACE_CHAR
  end
end

def initialize_blocks(input)
  file_index = 0
  input.each_with_index.flat_map do |count, index|
    if index.even?
      blocks = count.times.map { Block.new(file_index) }
      file_index += 1
      blocks
    else
      count.times.map { Block.new }
    end
  end
end

def rearrange(blocks)
  index_of_last_file = blocks.rindex { !_1.space? }
  file_block = blocks[index_of_last_file]
  index_of_first_space = blocks.index { _1.space? }

  blocks[index_of_first_space] = file_block
  blocks[index_of_last_file] = Block.new
end

def add_blocks(blocks)
  checksum = blocks
    .filter_map { |b| b.id if !b.space? }
    .each_with_index
    .map { |i,index| i.to_i * index }

  checksum.sum
end

def run(input)
  blocks = initialize_blocks(input)
  rerun = true

  while(rerun) do
    puts blocks.map { _1.id }.join
    rearrange(blocks)
    index_of_last_file = blocks.rindex { !_1.space? }
    rerun = false if !blocks[0...index_of_last_file].any? { _1.space? }
  end

  add_blocks(blocks)
end

puts run(input)
# Part 1 6320029754031
