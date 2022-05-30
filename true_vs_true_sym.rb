# frozen_string_literal: true

require 'benchmark'

def return_true
  true
end

def return_false
  false
end

def is_true_with_sym?
  :true == (@true_sym ||= return_true ? :true : :false)
end

def is_true_with_sym_but_its_false?
  :true == (@false_sym ||= return_false ? :true : :false)
end

def is_true_with_true_class?
  return_true
end

def is_true_with_false_class?
  return_false
end


Benchmark.bmbm do |x|
  x.report(:is_true_with_sym?) do
    10_000_000.times do
      is_true_with_sym?
    end
  end

  x.report(:is_true_with_sym_but_its_false?) do
    10_000_000.times do
      is_true_with_sym_but_its_false?
    end
  end

  x.report(:is_true_with_true_class?) do
    10_000_000.times do
      is_true_with_true_class?
    end
  end

  x.report(:is_true_with_false_class?) do
    10_000_000.times do
      is_true_with_false_class?
    end
  end
end

#                                   user       system     total    real
# is_true_with_sym?                 0.584752   0.000702   0.585454 (0.585542)
# is_true_with_sym_but_its_false?   0.583074   0.000846   0.583920 (0.584031)
# is_true_with_true_class?          0.606376   0.000981   0.607357 (0.607470)
# is_true_with_false_class?         0.607117   0.001188   0.608305 (0.608474)
