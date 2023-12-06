require "benchmark/ips"

DATA = (1..100).to_a

def two_maps
  DATA.map { |n| n - 1 }
  DATA.map { |n| n.to_s }
end

def one_map
  other_array = []
  DATA.map do |n|
    other_array << n.to_s
    n - 1
  end
end

def one_map!
  other_array = []
  DATA.map! do |n|
    other_array << n.to_s
    n - 1
  end
end

def one_map_and_init_array
  other_array = Array.new(DATA.length)
  DATA.map.with_index do |n, i|
    other_array[i] = n.to_s
    n - 1
  end
end

def one_map_and_array_indices
  other_array = []
  DATA.map.with_index do |n, i|
    other_array[i] = n.to_s
    n - 1
  end
end

bench = lambda do |x|
  x.report(:two_maps) { two_maps }
  x.report(:one_map) { one_map }
  x.report(:one_map!) { one_map! }
  x.report(:one_map_and_init_array) { one_map_and_init_array }
  x.report(:one_map_and_array_indices) { one_map_and_array_indices }

  x.compare!
end

Benchmark.ips(&bench)
