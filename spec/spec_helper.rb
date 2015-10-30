unless Object.const_defined? :SPEC_HELPER_LOADED

  $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
  require 'elected'

  require_relative '../spec/support'

  RSpec.configure do |c|
    c.include TestingHelpers

    # Setup defaults for testing
    c.before(:each) do
      Elected.key        = DEFAULT_KEY
      Elected.timeout    = DEFAULT_TIMEOUT
      Elected.redis_urls = ENV.fetch 'REDIS_URL', 'redis://localhost:6379/15'
    end

    # Get a inspectable logger
    c.before(:each, logging: true) do
      $logger        = TestingHelpers::TestLogger.new
      Elected.logger = $logger
    end

    # Freeze to current time on specs tagged :freeze_current_time
    c.before(:each, freeze_current_time: true) do
      Timecop.freeze Time.now
    end

    # Always return to real time
    c.after(:each) do
      Timecop.return
    end

    # Release leader
    c.after(:each) do
      Elected.senado.release
    end
  end

  SPEC_HELPER_LOADED = true
end