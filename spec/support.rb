require 'rspec/expectations'
require 'rspec/core/shared_context'
require 'timecop'

ENV['REDIS_URL'] ||= 'redis://localhost:6379/0'

FOCUSED     = ENV['FOCUS'] == 'true'
PERFORMANCE = ENV['PERFORMANCE'] == 'true'
DEBUG       = ENV['DEBUG'] == 'true'

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

  def wait_until(time)
    sleep 0.1 until Time.now >= time
  end

  def set_start_time
    @start_time = Time.now
  end

  def wait_for_timeout(fraction)
    wait_until @start_time + (@timeout / 1_000.0) * fraction
  end

  def expect_instance_log_msg(logr_meth, msg)
    subject.send logr_meth
    expect_log_line "#{subject.class.name}.#{logr_meth} | #{msg}"
  end

  def expect_class_log_msg(logr_meth, msg)
    subject.class.send logr_meth
    expect_log_line "#{subject.class.name}.#{logr_meth} | #{msg}"
  end

  def expect_log_line(msg)
    expect($logger.has_line?(msg)).to eq(true),
                                      "expected #{$logger.lines.inspect}\n" +
                                        "to have  [#{msg}]"

  end

end