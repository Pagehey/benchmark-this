# frozen_string_literal: true

require "benchmark"
require "benchmark-memory"
require "benchmark/ips"

EMPTY_ARRAY = [].freeze

def error_with_stack
  raise ArgumentError, "message"
end

def error_without_stack
  raise ArgumentError, "message", EMPTY_ARRAY
end

bench = lambda do |x|
  x.report(:error_with_stack) do
    error_with_stack

  rescue ArgumentError
  end

  x.report(:error_without_stack) do
    error_without_stack

  rescue ArgumentError
  end

  x.compare!
end

Benchmark.ips(&bench)
Benchmark.memory(&bench)

#                       user       system     total      real
# error_with_stack      0.075993   0.001458   0.077451   (0.077510)
# error_without_stack   0.052862   0.000983   0.053845   (0.053851)
# Calculating -------------------------------------
#     error_with_stack    54.400M memsize (0.000  retained)
#                        200.000k objects (0.000  retained)
#                          0.000  strings (0.000  retained)
#  error_without_stack     4.000M memsize (0.000  retained)
#                        100.000k objects (0.000  retained)
#                          0.000  strings (0.000  retained)

##
# Caution: this method is meant for errors you know you will rescue somehow,
# because by doing this, you completly lose the backtrace and thus the path that lead to the error
# The saved memory usage is huge!
