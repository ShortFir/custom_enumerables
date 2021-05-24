# frozen_string_literal: true

# rubocop:disable Style/For
# Custom Enumerables
module Enumerable
  def my_each
    for value in self do
      yield(value)
    end
  end

  def my_each_with_index
    index = 0
    for value in self do
      yield(value, index)
      index += 1
    end
  end

  def my_select
    yield
  end

  def my_all?
    yield
  end

  def my_any?
    yield
  end

  def my_none?
    yield
  end

  def my_count
    yield
  end

  def my_map
    yield
  end

  def my_inject
    yield
  end
end
# rubocop:enable Style/For

numbers = [1, 2, 3, 4, 5]
num_intp = %W[#{numbers[0]} #{numbers[1]} #{numbers[2]} #{numbers[3]} #{numbers[4]}]
words = %w[one two three four five]

puts 'each :VS: my_each'

numbers.each { |value| puts "Value: #{value}" }
numbers.my_each { |value| puts "Value: #{value}" }

puts 'each_with_index :VS: my_each_with_index'

words.each_with_index do |value, index|
  puts "Value: #{value.to_s.ljust(5)} Index: #{index}"
end
words.my_each_with_index do |value, index|
  puts "Value: #{value.to_s.ljust(5)} Index: #{index}"
end

puts 'array interpolation'
num_intp.each { |value| puts "Value: #{value}" }
