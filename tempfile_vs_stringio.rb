# frozen_string_literal: true

require 'benchmark'
require "benchmark-memory"
require "open-uri"
require "tempfile"

content = URI.open("https://duckduckgo.com/")

bench = lambda do |x|
  x.report(:file_write) do
    10_000.times do
      Tempfile.create("tmp") do |file|
        file.write content.read
        file.read
      end
      content.rewind
    end
  end

  x.report(:string_io) do
    10_000.times do
      Tempfile.create("tmp") do |file|
        io = StringIO.new(content.read)
        io.read
      end
      content.rewind
    end
  end
end

Benchmark.bmbm(&bench)

Benchmark.memory(&bench)

# Rehearsal ----------------------------------------------
# file_write   0.277061   1.166814   1.443875 (  1.602365)
# string_io    0.233510   0.846217   1.079727 (  1.090419)
# ------------------------------------- total: 2.523602sec

#                  user     system      total        real
# file_write   0.272212   1.154210   1.426422 (  1.583545)
# string_io    0.229313   0.826566   1.055879 (  1.066437)
# Calculating -------------------------------------
#           file_write   116.916M memsize (     0.000  retained)
#                        350.001k objects (     0.000  retained)
#                         50.000  strings (     0.000  retained)
#            string_io    24.825M memsize (     0.000  retained)
#                        350.001k objects (     0.000  retained)
#                         50.000  strings (     0.000  retained)
