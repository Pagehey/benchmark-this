require "benchmark/ips"

hash = {}
array = []
10_000.times do |n|
  hash[n] = n
  array << n
end

bench = lambda do |x|
  x.report(:hash) do
    hash[9999]
  end

  x.report(:array) do
    array[9999]
  end

  x.compare! if x.respond_to?(:compare!)
end

Benchmark.ips(&bench)
