require 'rspec/expectations'
require 'rspec/core/shared_context'
require 'timecop'

ENV['REDIS_URL'] ||= 'redis://localhost:6379/0'

DEFAULT_KEY     = 'test_elected'
DEFAULT_TIMEOUT = 5_000

module TestingHelpers

  extend RSpec::Core::SharedContext

  class TestLogger

    attr_reader :lines

    def initialize
      @lines = Array.new
    end

    def debug(string)
      lines << string
    end

    def info(string)
      lines << string
    end

    def warn(string)
      lines << string
    end

    def error(string)
      lines << string
    end

    def has_line?(str)
      lines.any? { |x| x.include? str }
    end

  end

  # Setup defaults for testing
  before(:each) do
    Elected.key        = DEFAULT_KEY
    Elected.timeout    = DEFAULT_TIMEOUT
    Elected.redis_urls = ENV.fetch 'REDIS_URL', 'redis://localhost:6379/15'
  end

  # Get a inspectable logger
  before(:each, logging: true) do
    $logger        = TestLogger.new
    Elected.logger = $logger
  end

  # Freeze to current time on specs tagged :freeze_current_time
  before(:each, freeze_current_time: true) do
    Timecop.freeze Time.now
  end

  # Always return to real time
  after(:each) do
    Timecop.return
  end

  after(:each) do
    Elected.senado.release
  end

  def wait_until(time)
    sleep 0.1 until Time.now >= time
  end

  def set_start_time
    @start_time = Time.now
  end

  def wait_for_timeout(fraction)
    wait_until @start_time + (@timeout / 1_000.0) * fraction
  end

end