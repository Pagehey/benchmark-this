# frozen_string_literal: true

require 'benchmark'
require "benchmark-memory"

class A
  define_method :method_defined_with_defined_method do
    2
  end

  def normally_defined_method
    2
  end

  class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
    def method_defined_with_class_eval
      #{1 + 1}
    end
  RUBY
end

a = A.new

Benchmark.bmbm do |x|
  x.report(:method_defined_with_defined_method) do
    10_000_000.times do
      a.method_defined_with_defined_method
    end
  end

  x.report(:normally_defined_method) do
    10_000_000.times do
      a.normally_defined_method
    end
  end

  x.report(:method_defined_with_class_eval) do
    10_000_000.times do
      a.method_defined_with_class_eval
    end
  end
end

Benchmark.memory do |x|
  x.report(:method_defined_with_defined_method) do
    10_000_000.times do
      a.method_defined_with_defined_method
    end
  end

  x.report(:normally_defined_method) do
    10_000_000.times do
      a.normally_defined_method
    end
  end

  x.report(:method_defined_with_class_eval) do
    10_000_000.times do
      a.method_defined_with_class_eval
    end
  end

  x.compare!
end

# Rehearsal ----------------------------------------------------------------------
# method_defined_with_defined_method   0.985248   0.002157   0.987405 (  0.987600)
# normally_defined_method              0.451615   0.000882   0.452497 (  0.452537)
# method_defined_with_class_eval       0.451088   0.001165   0.452253 (  0.452313)
# ------------------------------------------------------------- total: 1.892155sec

#                                          user     system      total        real
# method_defined_with_defined_method   0.988690   0.001975   0.990665 (  0.990861)
# normally_defined_method              0.452052   0.000804   0.452856 (  0.452985)
# method_defined_with_class_eval       0.451329   0.000930   0.452259 (  0.452303)
# Calculating -------------------------------------
# method_defined_with_defined_method
#                          0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)
# normally_defined_method
#                          0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)
# method_defined_with_class_eval
#                          0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)

# Comparison:
# method_defined_with_defined_method:          0 allocated
# normally_defined_method:          0 allocated - same
# method_defined_with_class_eval:          0 allocated - same
