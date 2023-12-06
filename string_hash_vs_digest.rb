# frozen_string_literal: true

require "benchmark-memory"
require "benchmark/ips"

require "memo_wise"
require "digest"
require "pry-byebug"

class StringDigester
  prepend MemoWise

  def string_digest(str)
    Digest::SHA1.hexdigest(str).to_i(16)
  end

  def string_md5_digest(str)
    Digest::MD5.hexdigest(str).to_i(16)
  end

  def memowized_string_digest(str)
    Digest::SHA1.hexdigest(str).to_i(16)
  end
  memo_wise :memowized_string_digest

  def string_hash(str)
    str.hash
  end
end

string_digester = StringDigester.new
abc = ("A".."z").to_a * 8
strings = abc.zip(abc.reverse).zip(abc.shuffle).zip(abc.shuffle).map(&:join)

block = proc do |x|
  x.report(:string_digest) do
    strings.each { string_digester.string_digest(_1) }
  end

  x.report(:string_md5_digest) do
    strings.each { string_digester.string_md5_digest(_1) }
  end

  x.report(:memowized_string_digest) do
    strings.each { string_digester.memowized_string_digest(_1) }
  end

  x.report(:string_hash) do
    strings.each { string_digester.string_hash(_1) }
  end

  x.compare!
end

Benchmark.ips(&block)
Benchmark.memory(&block)

# instance_eval { Kernel.binding.pry }

# string_digest             986.176k (± 2.3%) i/s - 4.929M in 5.000790s
# memowized_string_digest   7.749M (± 0.7%) i/s - 39.176M in 5.055988s
#             string_hash   13.070M (± 0.4%) i/s - 65.365M in 5.001064s

# Comparison:
#             string_hash: 13070392.9 i/s
# memowized_string_digest: 7748803.4 i/s - 1.69x  slower
#           string_digest: 986175.9 i/s - 13.25x  slower

# Calculating -------------------------------------
#           string_digest  240.000 memsize (     0.000  retained)
#                          4.000   objects (     0.000  retained)
#                          2.000   strings (     0.000  retained)
# memowized_string_digest  0.000   memsize (     0.000  retained)
#                          0.000   objects (     0.000  retained)
#                          0.000   strings (     0.000  retained)
#             string_hash  0.000   memsize (     0.000  retained)
#                          0.000   objects (     0.000  retained)
#                          0.000   strings (     0.000  retained)

# Comparison:
# memowized_string_digest:          0 allocated
#          string_hash:          0 allocated - same
#        string_digest:        240 allocated - Infx more
