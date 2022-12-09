require 'pry'

class Main
  UPDATE_SIZE = 30_000_000
  TOTAL_SPACE = 70_000_000

  def initialize(input, part = 1)
    @input = input.split("$ ")
    @part = part
  end

  def call
    root = Folder.new("root")
    current_folder = root

    @input.each do |full_command|
      next if full_command.empty?

      com, *output = full_command.split("\n")
      output = Command.new(current_folder, com, output).call

      current_folder = output if com.include?('cd')
    end

    new_root = root.children.first
    rfolders = new_root.rfolders

    if @part == 1
      rfolders.select { _1.size < 100_000 }.sum(&:size)
    else
      free_space = TOTAL_SPACE - new_root.size
      needed_space = UPDATE_SIZE - free_space
      rfolders.select { _1.size > needed_space }
              .min_by(&:size)
              .size
    end
  end
end

class Command
  attr_reader :command, :args, :folder

  def initialize(folder, command, output = nil)
    @folder = folder
    @command, @args = command.split(' ')
    @output = output
  end

  def call
    case command.to_sym
    when :cd
      find_or_create_folder(args)
    when :ls
      @output.each { |child| create_child(child) }
    end
  end

  def create_child(child)
    child_type, arg = child.split(' ')
    folder.children << case child_type
                       when 'dir'
                         Folder.new(arg, parent: folder)
                       else
                         ElfFile.new(arg, size: child_type)
                       end
  end

  def find_or_create_folder(name)
    return folder.parent if name == ".."

    found = folder.children.select { |file| file.is_a?(Folder) && name == file.name }.first

    if found.nil?
      new_folder = Folder.new(name, parent: folder)
      folder.children << new_folder

      return new_folder
    end

    found
  end
end

class Folder
  attr_reader :name, :parent, :children

  def initialize(name, parent: nil, children: [])
    @name = name
    @parent = parent
    @children = children
  end

  def create_child(child)
    @children << child
    self
  end

  def file_children
    @children.select { |child| child.is_a? ElfFile }
  end

  def folder_children
    @children.select { |child| child.is_a? Folder }
  end

  def inspect
    "\"#{name} @size=#{size} @children=#{ children.map { "#{_1.name} size: #{_1.size}" } }\""
  end

  def size
    rfiles.map(&:size).sum
  end

  def rfiles(folder=self, all=[])
    all += file_children

    folder.folder_children.each { all += _1.rfiles(_1, all) } if folder.folder_children.any?

    all.uniq
  end

  def rfolders(folder = self, all = [])
    all += folder_children

    folder.folder_children.each { all += _1.rfolders(_1, all) } if folder.folder_children.any?

    all.uniq
  end
end

class ElfFile
  attr_reader :name, :size

  def initialize(name, size:)
    @name = name
    @size = size.to_i
  end
end

test_string = <<~TEXT
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
TEXT

puts Main.new(test_string, 1).call

result_1 = Main.new(File.read('input.txt'), 1).call
result_2 = Main.new(File.read('input.txt'), 2).call

puts "result_1: #{result_1}"
puts "result_2: #{result_2}"
