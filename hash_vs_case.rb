# frozen_string_literal: true

require "benchmark"
require "benchmark-memory"
require "date"

SIMPLE_HASH_STORE = {
  1 => "result_1",
  2 => "result_2",
  3 => "result_3",
  4 => "result_4",
}.freeze

HASH_STORE = {
  [Date.new(2022, 1, 1), 1] => "result_1",
  [Date.new(2022, 1, 2), 2] => "result_2",
  [Date.new(2022, 1, 3), 3] => "result_3",
  [Date.new(2022, 1, 4), 4] => "result_4",
}.freeze

values = [
  [Date.new(2022, 1, 1), 1],
  [Date.new(2022, 1, 2), 2],
  [Date.new(2022, 1, 3), 3],
  [Date.new(2022, 1, 4), 4]
]

bench = lambda do |x|
  x.report(:simple_find_with_hash) do
    1_000_000.times do
      value = rand(1..4)
      SIMPLE_HASH_STORE[value]
    end
  end

  x.report(:simple_find_with_case) do
    1_000_000.times do
      value = rand(1..4)
      case value
      when 1 then "result_1"
      when 2 then "result_2"
      when 3 then "result_3"
      when 4 then "result_4"
      end
    end
  end

  x.report(:find_with_hash) do
    1_000_000.times do
      value = values.sample
      HASH_STORE[value]
    end
  end

  x.report(:find_with_case) do
    1_000_000.times do
      value = values.sample
      case value
      when [Date.new(2022, 1, 1), 1] then "result_1"
      when [Date.new(2022, 1, 2), 2] then "result_2"
      when [Date.new(2022, 1, 3), 3] then "result_3"
      when [Date.new(2022, 1, 4), 4] then "result_4"
      end
    end
  end
end

Benchmark.bmbm(&bench)

#                         user       system     total      real
# simple_find_with_hash   0.236148   0.000654   0.236802   (0.236831)
# simple_find_with_case   0.233312   0.000627   0.233939   (0.233974)
# find_with_hash          1.231883   0.001829   1.233712   (1.233743)
# find_with_case          2.808220   0.003277   2.811497   (2.811524)
