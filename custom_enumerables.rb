# frozen_string_literal: true

# Custom Enumerables
module Enumerable
  # rubocop:disable Style/For
  def my_each
    return unless block_given?

    for value in self do
      yield(value)
    end
  end
  # rubocop:enable Style/For

  def my_each_with_index
    return unless block_given?

    index = 0
    my_each do |value|
      yield(value, index)
      index += 1
    end
  end

  def my_select
    return unless block_given?

    array = []
    my_each do |value|
      array << value if yield(value)
    end
    array
  end

  def my_all?
    return unless block_given?

    bool = true
    my_each do |value|
      return false unless yield(value)
    end
    bool
  end

  def my_any?
    return unless block_given?

    bool = false
    my_each do |value|
      return true if yield(value)
    end
    bool
  end

  def my_none?
    return unless block_given?

    bool = true
    my_each do |value|
      return false if yield(value)
    end
    bool
  end

  def my_count
    return unless block_given?

    count = 0
    my_each do |value|
      count += 1 if yield(value)
    end
    count
  end

  def my_map
    return unless block_given?

    array = []
    my_each do |value|
      array << yield(value)
    end
    array
  end

  # rubocop:disable Metrics/MethodLength
  def my_inject(*accumulator)
    return unless block_given?

    if accumulator.empty?
      accumulator = first
      array = to_a.slice(1..-1)
    else
      accumulator = accumulator.first
      array = to_a
    end
    array.my_each do |value|
      accumulator = yield(accumulator, value)
    end
    accumulator
  end
  # rubocop:enable Metrics/MethodLength
end

def multiply_els(array)
  array.my_inject { |a, b| a * b }
end

# ############################################################
# Very sloppy testing, it was just added to as I created the methods.
# Probably not going to clean it up atm.
# ############################################################

numbers = [1, 2, 3, 4, 5]
words = %w[one two three four five]

puts '(1) ---------- each :VS: my_each ----------'
numbers.each { |value| puts "Value: #{value}" }
puts '--------------------'
numbers.my_each { |value| puts "Value: #{value}" }

puts '(2) ---------- each_with_index :VS: my_each_with_index ----------'
words.each_with_index do |value, index|
  puts "Value: #{value.to_s.ljust(5)} Index: #{index}"
end
puts '--------------------'
words.my_each_with_index do |value, index|
  puts "Value: #{value.to_s.ljust(5)} Index: #{index}"
end

puts '(3) --------- select :VS: my_select ----------'
puts(numbers.select(&:even?))
puts(words.select { |word| word == 'one' })
puts '--------------------'
puts(numbers.my_select(&:even?))
puts(words.my_select { |word| word == 'one' })

puts '(4) ---------- all? :VS: my_all? ----------'
puts numbers.all?(&:positive?)
puts(words.all? { |word| word == 'one' })
# puts numbers.all?(Numeric)
puts '--------------------'
puts numbers.my_all?(&:positive?)
puts(words.my_all? { |word| word == 'one' })
# puts numbers.my_all?(Numeric) # Doesn't work

puts '(5) ---------- any? :VS: my_any? ----------'
puts(words.any? { |word| word.length < 4 })
puts numbers.any?(&:negative?)
puts '--------------------'
puts(words.my_any? { |word| word.length < 4 })
puts numbers.my_any?(&:negative?)

puts '(6) ---------- none? :VS: my_none? ----------'
puts(words.none? { |word| word == 'three' })
puts(words.none? { |word| word == 'six' })
puts(numbers.none? { |number| number > 5 })
puts(numbers.none? { |number| number < 5 })
puts '--------------------'
puts(words.my_none? { |word| word == 'three' })
puts(words.my_none? { |word| word == 'six' })
puts(numbers.my_none? { |number| number > 5 })
puts(numbers.my_none? { |number| number < 5 })

puts '(7) ---------- count :VS: my_count ----------'
puts(numbers.count { |number| number > 2 })
puts numbers.count(&:even?)
puts(words.count { |word| word.length > 3 })
puts '--------------------'
puts(numbers.my_count { |number| number > 2 })
puts numbers.my_count(&:even?)
puts(words.my_count { |word| word.length > 3 })

puts '(8) ---------- map :VS: my_map ----------'
puts(numbers.map { |number| number * 2 })
puts(numbers.map { |number| number * number })
print 'Returns >> ', numbers.map, ' <<', "\n" # Returns Enumerator
puts '--------------------'
puts(numbers.my_map { |number| number * 2 })
puts(numbers.my_map { |number| number * number })
print 'Returns >> ', numbers.my_map, ' <<', "\n" # Returns nothing

puts '(9) ---------- inject :VS: my_inject ----------'
# puts(numbers.inject(:+))
puts(numbers.inject { |sum, n| sum + n })
puts(numbers.inject(10) { |sum, n| sum + n })
puts((5..10).inject { |sum, n| sum + n })
puts((5..10).inject(10) { |sum, n| sum + n })
puts
puts(numbers.inject { |sum, n| sum * n })
puts(numbers.inject(10) { |sum, n| sum * n })
puts((5..10).inject { |sum, n| sum * n })
puts((5..10).inject(10) { |sum, n| sum * n })
puts '--------------------'
# puts(numbers.my_inject(:+))
puts(numbers.my_inject { |sum, n| sum + n })
puts(numbers.my_inject(10) { |sum, n| sum + n })
puts((5..10).my_inject { |sum, n| sum + n })
puts((5..10).my_inject(10) { |sum, n| sum + n })
puts
puts(numbers.my_inject { |sum, n| sum * n })
puts(numbers.my_inject(10) { |sum, n| sum * n })
puts((5..10).my_inject { |sum, n| sum * n })
puts((5..10).my_inject(10) { |sum, n| sum * n })

puts '(10) --------- Test my_inject with method -----------'
print 'Testing multiply_els([2, 4, 5]) => 40 >>> '
puts multiply_els([2, 4, 5])

puts '(11) --------- Mod my_map to take proc -----------'
a_proc = proc { |number| number * 2 }
print 'map to take a proc', "\n"
puts numbers.map(&a_proc)
print 'my_map to take a proc...', "\n"
puts numbers.my_map(&a_proc)
print '...turns out it worked that way already.', "\n"

puts '(12) ---------- Pass Proc and Block ----------'
# puts(numbers.map(&a_proc) { |number| number * 2 })
# puts(numbers.my_map(&a_proc) { |number| number * 2 })
puts 'Both map and my_map throw an error in the IDE (VSCode), so cannot even run code'
