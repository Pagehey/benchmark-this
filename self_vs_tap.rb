# frozen_string_literal: true

require 'benchmark'
require "benchmark-memory"

class A
  def explicit_self_return
    1 + 1
    self
  end

  def implicit_self_return
    tap { 1 + 1 }
  end
end

a = A.new

bench = lambda do |x|
  x.report(:explicit_self_return) do
    10_000_000.times do
      a.explicit_self_return
    end
  end

  x.report(:implicit_self_return) do
    10_000_000.times do
      a.implicit_self_return
    end
  end

  x.compare! if x.respond_to?(:compare!)
end

Benchmark.bmbm(&bench)
Benchmark.memory(&bench)


#                        user       system     total    real
# explicit_self_return   0.553690   0.000922   0.554612 (0.554658)
# implicit_self_return   0.904117   0.001091   0.905208 (0.905259)


# Memory consumption -------------------------------------
# explicit_self_return     0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)
# implicit_self_return     0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)

# Comparison:
# explicit_self_return:          0 allocated
# implicit_self_return:          0 allocated - same
