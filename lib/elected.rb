require 'elected/version'
require 'redlock'

module Elected

  extend self

  def redis_urls
    @redis_urls || ENV['REDIS_URL'].split('|')
  end

  # Split strings by pipes to allow for one ENV['REDIS_URL'] to hold many urls
  def redis_urls=(urls)
    @redis_urls = Array(urls).flatten.
      map { |x| x.is_a?(String) ? x.split('|') : x }.
      flatten
  end

  def electorado
    @electorado ||= ::Redlock::Client.new redis_urls
  end

  attr_writer :key, :timeout

  def key
    @key || 'elected'
  end

  # In ms (milliseconds), defaults to 5 seconds
  def timeout
    @timeout || 5_000
  end

end

require 'elected/core_ext'
require 'elected/logging'
require 'elected/stats'
require 'elected/lider'
require 'elected/senado'
