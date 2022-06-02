# frozen_string_literal: true

require "benchmark"
require "benchmark-memory"

class A
  attr_reader :variable

  def initialize
    @variable = 1
  end

  def instance_variable_direct_read
    @variable
  end

  def instance_variable_read_with_getter
    variable
  end
end

a = A.new

bench = lambda do |x|
  x.report(:instance_variable_direct_read) do
    10_000_000.times do
      a.instance_variable_direct_read
    end
  end

  x.report(:instance_variable_read_with_getter) do
    10_000_000.times do
      a.instance_variable_read_with_getter
    end
  end
end

Benchmark.bmbm(&bench)

#                                      user       system     total      real
# instance_variable_direct_read        0.496650   0.009067   0.505717   (0.505748)
# instance_variable_read_with_getter   0.563241   0.010447   0.573688   (0.573720)
