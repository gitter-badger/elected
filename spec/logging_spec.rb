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
      it('debug  ') { expect_instance_log_msg :dbg, :debug, 'debugging ...' }
      it('info   ') { expect_instance_log_msg :inf, :info, 'infoing ...' }
      it('warning') { expect_instance_log_msg :wrn, :warn, 'warning ...' }
      it('error  ') { expect_instance_log_msg :err, :error, 'erroring ...' }
    end

    context 'class' do
      it('debug  ') { expect_class_log_msg :dbg, :debug, 'debugging ...' }
      it('info   ') { expect_class_log_msg :inf, :info, 'infoing ...' }
      it('warning') { expect_class_log_msg :wrn, :warn, 'warning ...' }
      it('error  ') { expect_class_log_msg :err, :error, 'erroring ...' }
    end

    def expect_instance_log_msg(logr_meth, mock_meth, msg)
      prefix = "#{subject.class.name}.#{logr_meth} |  "
      expect($logger).to receive(mock_meth).with /#{prefix}#{msg}/
      subject.send logr_meth
    end

    def expect_class_log_msg(logr_meth, mock_meth, msg)
      prefix = "#{subject.class.name}.#{logr_meth} |  "
      expect($logger).to receive(mock_meth).with /#{prefix}#{msg}/
      subject.class.send logr_meth
    end
  end
end
