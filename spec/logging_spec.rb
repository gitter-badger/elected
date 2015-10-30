require 'spec_helper'

module Elected
  class LogTester

    include Logging

    def dbg
      debug 'debugging ...'
    end

    def inf
      info 'infoing ....'
    end

    def wrn
      warn 'warning ...'
    end

    def err
      error 'erroring ...'
    end

    class << self

      def dbg
        debug 'debugging ...'
      end

      def inf
        info 'infoing ....'
      end

      def wrn
        warn 'warning ...'
      end

      def err
        error 'erroring ...'
      end

    end

  end

  describe Logging, logging: true do

    subject { LogTester.new }

    context 'instance' do
      it('debug  ') { expect_instance_log_msg :dbg, 'debugging ...' }
      it('info   ') { expect_instance_log_msg :inf, 'infoing ...' }
      it('warning') { expect_instance_log_msg :wrn, 'warning ...' }
      it('error  ') { expect_instance_log_msg :err, 'erroring ...' }
    end

    context 'class' do
      it('debug  ') { expect_class_log_msg :dbg, 'debugging ...' }
      it('info   ') { expect_class_log_msg :inf, 'infoing ...' }
      it('warning') { expect_class_log_msg :wrn, 'warning ...' }
      it('error  ') { expect_class_log_msg :err, 'erroring ...' }
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
end
