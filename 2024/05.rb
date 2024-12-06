require 'pry'

test_input = <<~INPUT
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
INPUT
actual_input = File.read('05_input.txt')
input = ENV['ACTUAL'].nil? ? test_input : actual_input

rules, to_sort = input.split("\n\n")

@rules = rules.split("\n").map { |rule| rule.split('|') }
to_sort = to_sort.split("\n").map { |line| line.split(',') }

def applied_rules(string)
  @rules.select do |a, b|
    [a, b] if string.include?(a) && string.include?(b)
  end
end

def ordered?(to_sort)
  rules = applied_rules(to_sort)

  rules.each do |a, b|
    return false if to_sort.index(a) > to_sort.index(b)
  end

  true
end

def fix_page_ordering(to_sort)
  return to_sort if ordered?(to_sort)

  rules = applied_rules(to_sort)
  to_sort.each_with_index do |char, index|
    next_index = index + 1
    next_char = to_sort[next_index]

    next if next_char.nil?

    if !ordered?([char, next_char])
      to_sort[index] = next_char
      to_sort[next_index] = char
    end
  end

  fix_page_ordering(to_sort)
end

part1, part2 = 0, 0
to_sort.each do |sort|
  if ordered?(sort)
    page = sort[(sort.length / 2)].to_i
    part1 += page
  else
    sort = fix_page_ordering(sort)
    page = sort[(sort.length / 2)].to_i
    part2 += page
  end
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
