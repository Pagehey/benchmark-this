# frozen_string_literal: true

require 'benchmark'
require "benchmark-memory"

class MainClass
  class NestedClass
  end

  class << self
    def nested_class
      NestedClass
    end

    def const_get_nested_class
      const_get('NestedClass')
    end
  end
end

Benchmark.bmbm do |x|
  x.report(:classic_call) do
    10_000_000.times do
      MainClass::NestedClass
    end
  end

  x.report(:simple_method) do
    10_000_000.times do
      MainClass::nested_class
    end
  end

  x.report(:const_get) do
    10_000_000.times do
      MainClass.const_get('NestedClass')
    end
  end

  x.report(:const_get_in_method) do
    10_000_000.times do
      MainClass::const_get_nested_class
    end
  end
end

Benchmark.memory do |x|
  x.report(:classic_call) do
    10_000_000.times do
      MainClass::NestedClass
    end
  end

  x.report(:simple_method) do
    10_000_000.times do
      MainClass::nested_class
    end
  end

  x.report(:const_get) do
    10_000_000.times do
      MainClass.const_get('NestedClass')
    end
  end

  x.report(:const_get_in_method) do
    10_000_000.times do
      MainClass::const_get_nested_class
    end
  end

  x.compare!
end
