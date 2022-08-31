require "benchmark/ips"
require "active_support"

puts "With present query:"
Benchmark.ips do |x|
  query = "toto"

  x.report(:ternary) do
    query.present? ? "%#{query}%" : nil
  end

  x.report(:and) do
    query.presence && "%#{query}%"
  end

  x.report(:reassign) do
    query = "%#{query}%" if query.present?
  end

  x.compare!
end

puts "With blank query:"
Benchmark.ips do |x|
  query = ""

  x.report(:ternary) do
    query.present? ? "%#{query}%" : nil
  end

  x.report(:and) do
    query.presence && "%#{query}%"
  end

  x.report(:reassign) do
    query = "%#{query}%" if query.present?
  end

  x.compare!
end

# With present query:
# Calculating -------------------------------------
#              ternary     60.839k (± 0.0%) i/s -    387.028k in   6.361534s
#                  and     60.342k (± 0.0%) i/s -    357.891k in   5.931010s
#             reassign     42.343k (±17.8%) i/s -    211.356k in   5.150991s

# Comparison:
#              ternary:    60838.8 i/s
#                  and:    60342.3 i/s - 1.01x  (± 0.00) slower
#             reassign:    42342.5 i/s - 1.44x  (± 0.00) slower

# With blank query:
# Calculating -------------------------------------
#              ternary     10.707M (± 4.1%) i/s -     54.083M in   5.059493s
#                  and      8.744M (± 2.6%) i/s -     44.201M in   5.058605s
#             reassign     10.643M (± 2.8%) i/s -     54.108M in   5.087828s

# Comparison:
#              ternary: 10706676.9 i/s
#             reassign: 10643136.0 i/s - same-ish: difference falls within error
#                  and:  8743556.2 i/s - 1.22x  (± 0.00) slower
