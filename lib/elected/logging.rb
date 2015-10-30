require 'logger'

module Elected
  module Logging

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def debug_var(var_name, var, meth = :inspect, level = :debug)
        msg   = var.nil? ? 'NIL' : var.send(meth)
        msg   = msg[0..-2] if msg[-1, 1] == "\n"
        klass = var.is_a?(Class) ? var.name : var.class.name
        Elected.logger.send level, "#{log_prefix} #{var_name} : (#{klass}:#{var.object_id}) #{msg}"
      end

      def log(string, type = :debug)
        msg = "#{log_prefix} #{string}"
        Elected.logger.send type, msg
      end

      def debug(string)
        log string, :debug
      end

      def info(string)
        log string, :info
      end

      def warn(string)
        log string, :warn
      end

      def error(string)
        log string, :error
      end

      def log_prefix(length = 60)
        prefixes = [name]
        label    = log_prefix_labels.last
        prefixes << label.rjust(length, ' ')[-length, length]
        prefixes << ' | '
        prefixes.join('')
      end

      def run_thread_count
        Thread.list.select { |thread| thread.status == 'run' }.count
      end

      def thread_count
        Thread.list.count
      end

      def log_prefix_labels
        caller.
          reject { |x| x.index(__FILE__) }.
          map { |x| x =~ /(.*):(.*):in `(.*)'/ ? [$1, $2, $3] : nil }.
          first
      end

    end

    def debug(string)
      self.class.debug string
    end

    def debug_var(name, var, meth = :inspect, level = :debug)
      self.class.debug_var name, var, meth, level
    end

    def info(string)
      self.class.info string
    end

    def warn(string)
      self.class.warn string
    end

    def error(string)
      self.class.error string
    end
  end

  extend self

  attr_accessor :logger

  self.logger = Logger.new(STDOUT).tap { |x| x.level = Logger::INFO } if logger.nil?

end
