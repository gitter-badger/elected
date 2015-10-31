require 'thread'

module Elected
  class Senado

    include Logging

    attr_writer :key, :timeout
    attr_reader :stats

    def initialize(key = nil, timeout = nil)
      @key     = key
      @timeout = timeout
      @stats   = Stats.new :elected, :rejected, :missing, :released
    end

    def key
      @key || Elected.key
    end

    # In ms (milliseconds), defaults to 5 seconds
    def timeout
      @timeout || Elected.timeout
    end

    def leader
      mutex.synchronize { get_leader || set_leader }
    end

    def leader?
      !!leader
    end

    def release
      return false unless @leader

      if @leader.current?
        Elected.electorado.unlock @leader.info
        @stats.increment :released
      end

      @leader = false
    end

    def to_s
      %{#<#{self.class.name} key=#{key.inspect} timeout=#{timeout} leader?=#{leader?}>}
    end

    alias :inspect :to_s

    private

    def mutex
      @mutex ||= Mutex.new
    end

    def get_leader
      unless @leader
        @stats.increment :missing
        return false
      end

      return @leader if @leader.current?

      release
    end

    def set_leader
      found = Elected.electorado.lock key, timeout
      if found
        @stats.increment :elected
        @leader = Lider.new found, timeout
      else
        @stats.increment :rejected
        false
      end
    end

  end

  extend self

  def senado
    @senate ||= Senado.new
  end

  senado

end