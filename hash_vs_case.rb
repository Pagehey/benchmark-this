# frozen_string_literal: true

require "benchmark"
require "benchmark-memory"
require "date"

SIMPLE_HASH_STORE = {
  1 => "result_1",
  2 => "result_2",
  3 => "result_3",
  4 => "result_4",
  5 => "result_5",
  6 => "result_6",
  7 => "result_7",
  8 => "result_8",
  9 => "result_9",
  10 => "result_10",
}.freeze

HASH_STORE = {
  [Date.new(2022, 1, 1), 1] => "result_1",
  [Date.new(2022, 1, 2), 2] => "result_2",
  [Date.new(2022, 1, 3), 3] => "result_3",
  [Date.new(2022, 1, 4), 4] => "result_4",
  [Date.new(2022, 1, 5), 5] => "result_5",
  [Date.new(2022, 1, 6), 6] => "result_6",
  [Date.new(2022, 1, 7), 7] => "result_7",
  [Date.new(2022, 1, 8), 8] => "result_8",
  [Date.new(2022, 1, 9), 9] => "result_9",
  [Date.new(2022, 1, 10), 10] => "result_10",
}.freeze

values = [
  [Date.new(2022, 1, 1), 1],
  [Date.new(2022, 1, 2), 2],
  [Date.new(2022, 1, 3), 3],
  [Date.new(2022, 1, 4), 4],
  [Date.new(2022, 1, 5), 5],
  [Date.new(2022, 1, 6), 6],
  [Date.new(2022, 1, 7), 7],
  [Date.new(2022, 1, 8), 8],
  [Date.new(2022, 1, 9), 9],
  [Date.new(2022, 1, 10), 10]
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
      when 5 then "result_5"
      when 6 then "result_6"
      when 7 then "result_7"
      when 8 then "result_8"
      when 9 then "result_9"
      when 10 then "result_10"
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
      when [Date.new(2022, 1, 5), 5] then "result_5"
      when [Date.new(2022, 1, 6), 6] then "result_6"
      when [Date.new(2022, 1, 7), 7] then "result_7"
      when [Date.new(2022, 1, 8), 8] then "result_8"
      when [Date.new(2022, 1, 9), 9] then "result_9"
      when [Date.new(2022, 1, 10), 10] then "result_10"
      end
    end
  end
end

Benchmark.bmbm(&bench)

#                         user       system     total      real
# simple_find_with_hash   0.236148   0.000654   0.236802   (0.236831)
# simple_find_with_case   0.233312   0.000627   0.233939   (0.233974)
# find_with_hash          1.231883   0.001829   1.233712   (1.233743) # (with 4 items)
# find_with_case          2.808220   0.003277   2.811497   (2.811524) # (with 4 items)
# find_with_hash          1.233214   0.010597   1.243811   (1.243820) # (with 10 items)
# find_with_case          5.856218   0.030544   5.886762   (5.888280) # (with 10 items)
