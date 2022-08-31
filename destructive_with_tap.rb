# frozen_string_literal: true

require "benchmark"
require "benchmark-memory"
require "benchmark/ips"

bench = lambda do |x|
  x.report(:flatten) do
    [[1], [2], [3]].flatten!
  end

  x.report(:tap_flatten) do
    [[1], [2], [3]].tap(&:flatten!)
  end

  x.compare! if x.respond_to?(:compare!)
end

Benchmark.ips(&bench)
Benchmark.memory(&bench)
