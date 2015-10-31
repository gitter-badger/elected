require 'concurrent'
require 'concurrent/thread_safe/util/adder'

module Elected
  class Stats

    attr_reader :counters

    def initialize(*names)
      @counters = Concurrent::Hash.new
      names.map { |x| get_or_set_counter x }
    end

    def count(name)
      get_or_set_counter(name).sum
    end

    def increment(name, value = 1)
      get_or_set_counter(name).add value
      count name
    end

    def to_hash
      @counters.keys.sort.each_with_object({}) { |k, h| h[k] = count k }
    end

    def to_s
      %{#<#{self.class.name} #{to_hash.map { |k, v| "#{k}=#{v}" }.join(' ')}>}
    end

    alias :inspect :to_s

    private

    def get_or_set_counter(name, initial_value = 0)
      safe_name = name.to_s.strip.underscore.to_sym
      found     = @counters[safe_name]
      return found if found

      @counters[safe_name] = Concurrent::ThreadSafe::Util::Adder.new.tap do |c|
        c.add(initial_value) unless initial_value == 0
      end
    end

  end
end