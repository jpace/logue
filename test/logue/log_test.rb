require 'logue/log'
require 'logue/tc'

module Logue
  class LogTest < TestCase
    param_test [
                 [:verbose, false, true],
                 [:level, Level::FATAL, Level::INFO],
                 [:colorize_line, false, true],
               ].each do |methname, *values|
      wrmeth = (methname.to_s + "=").to_sym
      logger = Log.logger
      values.each do |value|
        Log.send wrmeth, value
        assert_equal value, logger.send(methname)
        assert_equal value, Log.send(methname)
      end
    end

    def test_delegator_outfile
      # is called, but converted from value to File.new(value)
      fname = "/tmp/logue_test_abc"
      Log.outfile = fname
      assert_path_exist fname
      File.unlink fname
    end

    param_test [
                 [:ignore_file, true, false],
                 [:ignore_method, true, false],
                 [:ignore_class, true, false],
                 [:log_file, true, false],
                 [:log_method, true, false],
                 [:log_class, true, false],
                 [:set_color, [Level::FATAL, :red], [Level::FATAL, :none]],
               ].each do |methname, *values|
      values.each do |value|
        Log.send methname, *value
      end
    end

    def self.delegated_methods
      [
        :colorize_line,
        :format,
        :level,
        :outfile,
        :output,
        :quiet,
        :verbose,
        :ignore_class,
        :ignore_file,
        :ignore_method,
        :log_class,
        :log_file,
        :log_method,
        :set_color,
        :set_default_widths,
        :set_widths,
        :debug,
        :fatal,
        :info,
        :log,
        :stack,
        :write,
        :warn,
        :error,
        :blue,
        :yellow,
      ]
    end

    def self.build_method_params
      Array.new.tap do |a|
        a.concat delegated_methods.collect { |m| [true, m] }
        a << [false, :abc]
        a << [false, :xyz]
      end
    end

    param_test build_method_params do |exp, methname|
      assert_all [
                   lambda { assert_equal exp, Log.methods.include?(methname) },
                   lambda { assert_equal exp, Log.respond_to?(methname) },
                 ]
    end
  end
end