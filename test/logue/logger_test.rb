require 'logue/logger'
require 'stringio'
require 'logue/tc'

module Logue
  class LoggerTest < TestCase
    def self.create_logger writer = Writer.new
      Logger.new(writer: writer).tap do |logger|
        def logger.invoked
          @invoked
        end

        def logger.log_frames msg, obj = nil, classname: nil, level: nil, nframes: -1, &blk
          @invoked ||= Array.new
          @invoked << { msg: msg, obj: obj, classname: classname, level: level, nframes: nframes, blk: blk }
          super
        end
      end
    end

    def test_init
      logger = Logger.new
      assert_all [
                   lambda { assert_equal Level::WARN, logger.level },
                   lambda { assert_equal $stdout, logger.output },
                   lambda { assert_equal false, logger.colorize_line },
                   lambda { assert_empty logger.filter.files },
                   lambda { assert_equal false, logger.verbose },
                 ]
    end

    def test_respond_to
      logger = Logger.new
      assert_all [
                   lambda { assert_equal true, logger.respond_to?(:blue) },
                   lambda { assert_equal false, logger.respond_to?(:no_such_color) },
                 ]
    end

    param_test [
                 [1, 2, 3, 1, 2, 3],
                 [4, 5, 6, 4, 5, 6],
               ] do |expfile, expline, expmethod, *args|
      logger = Logger.new
      logger.set_widths(*args)
      format = logger.format
      assert_all [
                   lambda { assert_equal expfile, format.file },
                   lambda { assert_equal expline, format.line },
                   lambda { assert_equal expmethod, format.method },
                 ]
    end

    def self.build_log_write_params
      re = Regexp.new '^\[.../logue/logger_test.rb\s*:\s*\d+\] {cdef#.*} mabc$'

      obj = "o2"
      objre = Regexp.new '^\[.../logue/logger_test.rb\s*:\s*\d+\] {cdef#.*} mabc: o2$'

      Array.new.tap do |a|
        a << [true, re, :warn, "mabc", classname: "cdef"]
        a << [true, re, :fatal, "mabc", classname: "cdef"]
        a << [true, re, :error, "mabc", classname: "cdef"]
        a << [false, re, :debug, "mabc", classname: "cdef"]
        a << [false, re, :info, "mabc", classname: "cdef"]

        a << [true, objre, :warn, "mabc", obj, classname: "cdef"]
        a << [true, objre, :fatal, "mabc", obj, classname: "cdef"]
        a << [true, objre, :error, "mabc", obj, classname: "cdef"]
        a << [false, objre, :debug, "mabc", obj, classname: "cdef"]
        a << [false, objre, :info, "mabc", obj, classname: "cdef"]
      end
    end

    param_test build_log_write_params do |exp, re, methname, *args|
      output = StringIO.new
      writer = Writer.new output: output
      logger = Logger.new writer: writer
      logger.send methname, *args
      output.flush
      str = output.string
      assert_equal exp, !!re.match(str), "str: #{str}; re: #{re}"
    end

    def self.build_delegate_params
      Array.new.tap do |a|
        a << [Level::WARN, :warn]
        a << [Level::FATAL, :fatal]
        a << [Level::ERROR, :error]
        a << [Level::DEBUG, :debug]
        a << [Level::INFO, :info]
      end
    end

    param_test build_delegate_params do |exp, methname|
      output = StringIO.new
      writer = Writer.new output: output
      logger = self.class.create_logger writer
      logger.send methname, ""
      output.flush
      latest = logger.invoked.last
      assert_equal exp, latest[:level]
    end
  end
end
