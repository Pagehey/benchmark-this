# frozen_string_literal: true

require "async"
require "open-uri"
require "httparty"

start = Time.now

Async do |task|
  task.async do
    puts "start URI"
    URI.open("https://httpbin.org/delay/1.6")
    puts "end URI"
  end

  task.async do
    puts "start HTTParty"
    HTTParty.get("https://httpbin.org/delay/1.6")
    puts "end HTTParty"
  end
end

puts "Duration: #{Time.now - start}"
