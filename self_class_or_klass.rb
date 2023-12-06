
require "benchmark"
require "benchmark-memory"
require "benchmark/ips"

class A
  def self.class_method
    1 + 1
  end

  def call_class_method_with_self_class
    self.class.class_method
  end

  def call_class_method_with_direct_ref_to_class
    A.class_method
  end
end

bench = lambda do |x|
  a = A.new

  x.report(:call_class_method_with_self_class) do
    a.call_class_method_with_self_class
  end

  x.report(:call_class_method_with_direct_ref_to_class) do
    a.call_class_method_with_direct_ref_to_class
  end

  x.compare! if x.respond_to?(:compare!)
end

Benchmark.ips(&bench)
Benchmark.memory(&bench)
