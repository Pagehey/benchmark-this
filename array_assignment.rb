# frozen_string_literal: true

require 'benchmark'
require "benchmark-memory"

NUMBERS = 0..99

def array_with_given_length
  arr = Array.new(100)
  NUMBERS.each_with_index do |n, i|
    arr[i] = n
  end
end

def empty_array
  arr = []
  NUMBERS.each_with_index do |n, i|
    arr[i] = n
  end
end

##
# this generates a custom method that looks like:
#   def distinct_assigments
#     arr = Array.new(100)
#     arr[0] = 0
#     arr[1] = 1
#     arr[2] = 2
#     arr[3] = 3
#     arr[4] = 4
#     # ... up to
#     arr[99] = 99
#
#     return arr
#   end
#
# This is obviously not realistic but the goal is to check
# how each method can be optimized by Ruby compiler
# This one is incredibly fast!
assignments_string = NUMBERS.map.with_index {|n, i| "arr[#{i}] = #{n};" }.join
eval(<<-RUBY)
  def distinct_assigments
    arr = Array.new(100)
    #{assignments_string}

    return arr
  end
RUBY

bench = lambda do |x|
  x.report(:array_with_given_length) do
    100_000.times do
      array_with_given_length
    end
  end

  x.report(:empty_array) do
    100_000.times do
      empty_array
    end
  end

  x.report(:distinct_assigments) do
    100_000.times do
      distinct_assigments
    end
  end
end

Benchmark.bmbm(&bench)
Benchmark.memory(&bench)

#                           user       system     total      real
# array_with_given_length   1.006997   0.018310   1.025307   (1.025378)
# empty_array               1.016449   0.020080   1.036529   (1.036629)
# distinct_assigments       0.170805   0.002659   0.173464   (0.173537)
# Calculating -------------------------------------
# array_with_given_length
#                         84.000M memsize (0.000  retained)
#                        100.000k objects (0.000  retained)
#                          0.000  strings (0.000  retained)
#          empty_array    97.600M memsize (0.000  retained)
#                        100.000k objects (0.000  retained)
#                          0.000  strings (0.000  retained)
#  distinct_assigments    84.000M memsize (0.000  retained)
#                        100.000k objects (0.000  retained)
#                          0.000  strings (0.000  retained)
