require 'yaml'

module Elected
  class Lider

    include Logging

    attr_reader :info, :validity, :resource, :value, :created, :deadline, :diff

    def initialize(info, timeout)
      @info     = info
      @validity = info[:validity]
      @resource = info[:resource]
      @value    = info[:value]
      @created  = Time.now
      @deadline = created + (timeout / 1000.0).to_i
      @diff     = @deadline - @created
    end

    def current?
      @deadline > Time.now
    end

    def to_s(type = :short)
      case type
        when :full
          "#<#{self.class.name} " +
            "resource=#{resource.inspect} " +
            "value=#{value.inspect} " +
            "validity=#{validity.inspect} " +
            "deadline=#{deadline}" +
            ">"
        when :yaml
          to_yaml
        else
          %{#<Elected::Lider|#{resource}:#{value[0, 8]}:#{validity}>}
      end
    end

    alias :inspect :to_s

  end
end
