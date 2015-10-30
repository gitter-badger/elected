unless Object.const_defined? :SPEC_HELPER_LOADED

  $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
  require 'elected'

  require_relative '../spec/support'


  RSpec.configure do |c|
    c.include TestingHelpers
  end

  SPEC_HELPER_LOADED = true
end