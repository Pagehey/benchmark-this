require 'benchmark'
require "benchmark-memory"

bench = lambda do |x|
  x.report(:double_quotes) do
    10_000_000.times do
      "Je ne pense pas qu\'il y aie de bons ou de mauvais guillements ..."
    end
  end

  x.report(:single_quotes) do
    10_000_000.times do
      'Je ne pense pas qu\'il y aie de bons ou de mauvais guillements ...'
    end
  end

  x.report(:heredoc) do
    10_000_000.times do
      <<-STR
      Je ne pense pas qu\'il y aie de bons ou de mauvais guillements ...
      STR
    end
  end

  x.compare! if x.respond_to?(:compare!)
end

Benchmark.bmbm(&bench)
Benchmark.memory(&bench)

#                 user       system     total      real
# double_quotes   0.524876   0.002958   0.527834   0.527878
# single_quotes   0.523699   0.003938   0.527637   0.527721
# heredoc         0.524400   0.003185   0.527585   0.527639
# Calculating -------------------------------------
#        double_quotes   400.000M memsize (     0.000  retained)
#                         10.000M objects (     0.000  retained)
#                          1.000  strings (     0.000  retained)
#        single_quotes   400.000M memsize (     0.000  retained)
#                         10.000M objects (     0.000  retained)
#                          1.000  strings (     0.000  retained)
#              heredoc   400.000M memsize (     0.000  retained)
#                         10.000M objects (     0.000  retained)
#                          1.000  strings (     0.000  retained)

# Comparison:
#        double_quotes:  400000000 allocated
#        single_quotes:  400000000 allocated - same
#              heredoc:  400000000 allocated - same
