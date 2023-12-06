require 'benchmark'
require "benchmark-memory"
require "benchmark/ips"

SOURCE_HASH = { data: 1 }

def source_hash
  SOURCE_HASH
end

class A
  def memoized
    @memoized||= SOURCE_HASH[:data]
  end

  def hash_data
    SOURCE_HASH[:data]
  end
end

block = proc do |x|
  a = A.new

  x.report(:memoized) do
    a.memoized
  end

  x.report(:hash_data) do
    a.hash_data
  end

  x.compare!
end

Benchmark.ips(&block)
Benchmark.memory(&block)
