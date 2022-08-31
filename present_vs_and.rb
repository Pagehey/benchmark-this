require "benchmark/ips"
require "active_support"

puts "With present query:"
Benchmark.ips do |x|
  query = "toto"

  x.report(:present_ternary) do
    query.present? ? "%#{query}%" : nil
  end

  x.report(:present_and) do
    query.presence && "%#{query}%"
  end

  x.compare!
end

puts "With blank query:"
Benchmark.ips do |x|
  query = ""

  x.report(:blank_ternary) do
    query.present? ? "%#{query}%" : nil
  end

  x.report(:blank_and) do
    query.presence && "%#{query}%"
  end

  x.compare!
end

# With present query:
# Calculating -------------------------------------
#      present_ternary      3.970M (± 1.7%) i/s -     19.947M in   5.025735s
#          present_and      3.639M (± 0.5%) i/s -     18.390M in   5.054015s

# Comparison:
#      present_ternary:  3970191.2 i/s
#          present_and:  3638747.1 i/s - 1.09x  (± 0.00) slower

# With blank query:
# Calculating -------------------------------------
#        blank_ternary     11.833M (± 0.3%) i/s -     60.318M in   5.097445s
#            blank_and      9.455M (± 0.4%) i/s -     47.378M in   5.011060s

# Comparison:
#        blank_ternary: 11833054.2 i/s
#            blank_and:  9454869.5 i/s - 1.25x  (± 0.00) slower
