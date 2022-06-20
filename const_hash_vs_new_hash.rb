# frozen_string_literal: true

require 'benchmark'
require "benchmark-memory"

BG_COLORS = {
  contributor_sent_to_gateway: "bg-yellow-50",
  payment_confirmed: "bg-green-50",
  payment_process_canceled: "bg-orange-50",
  payment_process_canceled_for_manual_payment: "bg-orange-50",
  payment_pending_confirmation: "bg-yellow-50",
  payment_failed_by_gateway: "bg-red-50",
  payment_requires_action_by_gateway: "bg-red-50",
  payment_processing_by_gateway: "bg-yellow-50",
}.freeze

def bg_color_class_with_hash_const(status)
  BG_COLORS[status]
end

def bg_color_class_with_new_hash(status)
  {
    contributor_sent_to_gateway: "bg-yellow-50",
    payment_confirmed: "bg-green-50",
    payment_process_canceled: "bg-orange-50",
    payment_process_canceled_for_manual_payment: "bg-orange-50",
    payment_pending_confirmation: "bg-yellow-50",
    payment_failed_by_gateway: "bg-red-50",
    payment_requires_action_by_gateway: "bg-red-50",
    payment_processing_by_gateway: "bg-yellow-50",
  }[status]
end

bench = lambda do |x|
  x.report(:bg_color_class_with_hash_const) do
    1_000_000.times do
      bg_color_class_with_hash_const(:payment_failed_by_gateway)
    end
  end

  x.report(:bg_color_class_with_new_hash) do
    1_000_000.times do
      bg_color_class_with_new_hash(:payment_failed_by_gateway)
    end
  end

  x.compare! if x.respond_to?(:compare!)
end

Benchmark.bmbm(&bench)
Benchmark.memory(&bench)

#                                  user       system     total    real
# bg_color_class_with_hash_const   0.078494   0.000108   0.078602 (0.078639)
# bg_color_class_with_new_hash     0.104891   0.000203   0.105094 (0.105110)
# Calculating -------------------------------------
# bg_color_class_with_hash_const
#                          0.000  memsize (     0.000  retained)
#                          0.000  objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)
# bg_color_class_with_new_hash
#                        168.000M memsize (     0.000  retained)
#                          1.000M objects (     0.000  retained)
#                          0.000  strings (     0.000  retained)

# Comparison:
# bg_color_class_with_hash_const:          0 allocated
# bg_color_class_with_new_hash:  168000000 allocated - Infx more
