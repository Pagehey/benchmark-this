# frozen_string_literal: true

require 'benchmark'
require "benchmark-memory"

class A
  def not_memoized
    1
  end

  def memoized
    @memoized ||= 1
  end

  def instance_variable_reading
    @instance_variable_reading
  end
end

a = A.new

bench = lambda do |x|
  x.report(:not_memoized) do
    10_000_000.times do
      a.not_memoized
    end
  end

  x.report(:memoized) do
    10_000_000.times do
      a.memoized
    end
  end

  x.report(:instance_variable_reading) do
    a.instance_variable_set("@instance_variable_reading", 1)
    10_000_000.times do
      a.instance_variable_reading
    end
  end

  x.compare! if x.respond_to?(:compare!)
end

Benchmark.bmbm(&bench)

Benchmark.memory(&bench)

# Rehearsal ------------------------------------------------
# not_memoized   0.464249   0.000778   0.465027 (  0.465167)
# memoized       0.570158   0.002211   0.572369 (  0.572630)
# --------------------------------------- total: 1.037396sec

#                    user     system      total        real
# not_memoized   0.465195   0.001643   0.466838 (  0.467202)
# memoized       0.575482   0.001620   0.577102 (  0.577687)
# Calculating -------------------------------------
#         not_memoized     0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)
#             memoized     0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)

# Comparison:
#         not_memoized:          0 allocated
#             memoized:          0 allocated - same

# Rehearsal -------------------------------------------------------------
# not_memoized                0.450307   0.000976   0.451283 (  0.451432)
# memoized                    0.514390   0.001870   0.516260 (  0.516415)
# instance_variable_reading   0.484683   0.001253   0.485936 (  0.486089)
# ---------------------------------------------------- total: 1.453479sec

#                                 user     system      total        real
# not_memoized                0.450616   0.000933   0.451549 (  0.451666)
# memoized                    0.512395   0.000875   0.513270 (  0.513350)
# instance_variable_reading   0.482119   0.000858   0.482977 (  0.483039)
# Calculating -------------------------------------
#         not_memoized     0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)
#             memoized     0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)
# instance_variable_reading
#                          0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)

# Comparison:
#         not_memoized:          0 allocated
#             memoized:          0 allocated - same
# instance_variable_reading:          0 allocated - same
