# frozen_string_literal: true

# rubocop:disable Style/For
# Custom Enumerables
module Enumerable
  def my_each
    return unless block_given?

    for value in self do
      yield(value)
    end
  end

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

  # first = self.first 'first element of enumerable'
  def my_inject(accumulator = first)
    return unless block_given?

    # if acc arg given, then start loop at second item...?
    my_each do |value|
      accumulator = yield(accumulator, value)
    end
    accumulator
  end
end
# rubocop:enable Style/For

numbers = [1, 2, 3, 4, 5]
words = %w[one two three four five]

# I wanted to know how this works.
# num_intp = %W[#{numbers[0]} #{numbers[1]} #{numbers[2]} #{numbers[3]} #{numbers[4]}]
# puts 'array interpolation'
# num_intp.each { |value| puts "Value: #{value}" }

puts '---------- each :VS: my_each ----------'
numbers.each { |value| puts "Value: #{value}" }
puts '--------------------'
numbers.my_each { |value| puts "Value: #{value}" }

puts '---------- each_with_index :VS: my_each_with_index ----------'
words.each_with_index do |value, index|
  puts "Value: #{value.to_s.ljust(5)} Index: #{index}"
end
puts '--------------------'
words.my_each_with_index do |value, index|
  puts "Value: #{value.to_s.ljust(5)} Index: #{index}"
end

puts '---------- select :VS: my_select ----------'
puts(numbers.select(&:even?))
puts(words.select { |word| word == 'one' })
puts '--------------------'
puts(numbers.my_select(&:even?))
puts(words.my_select { |word| word == 'one' })

puts '---------- all? :VS: my_all? ----------'
puts numbers.all?(&:positive?)
puts(words.all? { |word| word == 'one' })
# puts numbers.all?(Numeric)
puts '--------------------'
puts numbers.my_all?(&:positive?)
puts(words.my_all? { |word| word == 'one' })
# puts numbers.my_all?(Numeric) # Doesn't work

puts '---------- any? :VS: my_any? ----------'
puts(words.any? { |word| word.length < 4 })
puts numbers.any?(&:negative?)
puts '--------------------'
puts(words.my_any? { |word| word.length < 4 })
puts numbers.my_any?(&:negative?)

puts '---------- none? :VS: my_none? ----------'
puts(words.none? { |word| word == 'three' })
puts(words.none? { |word| word == 'six' })
puts(numbers.none? { |number| number > 5 })
puts(numbers.none? { |number| number < 5 })
puts '--------------------'
puts(words.my_none? { |word| word == 'three' })
puts(words.my_none? { |word| word == 'six' })
puts(numbers.my_none? { |number| number > 5 })
puts(numbers.my_none? { |number| number < 5 })

puts '---------- count? :VS: my_count? ----------'
puts(numbers.count { |number| number > 2 })
puts numbers.count(&:even?)
puts(words.count { |word| word.length > 3 })
puts '--------------------'
puts(numbers.my_count { |number| number > 2 })
puts numbers.my_count(&:even?)
puts(words.my_count { |word| word.length > 3 })

puts '---------- map :VS: my_map ----------'
puts(numbers.map { |number| number * 2 })
puts(numbers.map { |number| number * number })
puts numbers.map # Returns Enumerator
puts '--------------------'
puts(numbers.my_map { |number| number * 2 })
puts(numbers.my_map { |number| number * number })
puts numbers.my_map # Returns nothing

puts '---------- inject :VS: my_inject ----------'
# puts(numbers.inject(:+))
puts(numbers.inject { |sum, n| sum + n })
puts(numbers.inject(10) { |sum, n| sum + n })
puts((5..10).inject { |sum, n| sum + n })
puts((5..10).inject(10) { |sum, n| sum + n })
puts '--------------------'
# puts(numbers.my_inject(:+))
puts(numbers.my_inject { |sum, n| sum + n })
puts(numbers.my_inject(10) { |sum, n| sum + n })
puts((5..10).my_inject { |sum, n| sum + n })
puts((5..10).my_inject(10) { |sum, n| sum + n })
