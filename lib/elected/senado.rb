require 'thread'

module Elected
  class Senado

    attr_accessor :key, :timeout

    def initialize(key = nil, timeout = nil)
      @key, @timeout = key, timeout
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

      Elected.electorado.unlock @leader.info if @leader.current?
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
      return false unless @leader
      return @leader if @leader.current?

      release
    end

    def set_leader
      found = Elected.electorado.lock key, timeout
      return false unless found

      @leader = Lider.new found, timeout
    end

  end

  extend self

  def senado
    @senate ||= Senado.new
  end

  senado

end