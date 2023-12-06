require "benchmark/ips"

class FrozenAtCreate
  attr_reader :time, :value, :str
  
  def initialize(time, value, str)
    @time = time.freeze
    @value = value.freeze
    @str = str.freeze
    freeze
  end
end

class NotFrozen
  attr_reader :time, :value, :str
  
  def initialize(time, value, str)
    @time = time
    @value = value
    @str = str
  end
end

bench = lambda do |x|
  x.report(:frozen_at_create) do
    time = Time.now
    FrozenAtCreate.new(time, rand(100.0), "string")
  end

  x.report(:not_frozen) do
    time = Time.now
    NotFrozen.new(time, rand(100.0), "string")
  end

  x.compare!
end

Benchmark.ips(&bench)