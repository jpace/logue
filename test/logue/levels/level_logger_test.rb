require 'logue/logger'
require 'stringio'
require 'logue/tc'

module Logue
  class LevelLoggerTest < TestCase
    def new_instance
      LevelLogger.new
    end

    def test_init
      logger = new_instance
      assert_all [
                   lambda { assert_equal Level::WARN, logger.level },
                   lambda { assert_equal false, logger.verbose },
                 ]
    end

    param_test [
                 [true, Level::FATAL],
                 [true, Level::ERROR],
                 [true, Level::WARN],
                 [false, Level::INFO],
                 [false, Level::DEBUG],
               ] do |exp, level|
      logger = new_instance
      logger.level = level
      assert_equal exp, logger.quiet?
    end

    param_test [
                 [Level::ERROR, Level::ERROR],
                 [Level::WARN, Level::WARN],
                 [Level::INFO, Level::INFO],
                 [Level::DEBUG, Level::DEBUG],
                 [Level::FATAL, false],
                 [Level::DEBUG, true],
               ] do |exp, value|
      logger = new_instance
      logger.verbose = value
      assert_equal exp, logger.level
    end

    param_test [
                 [false, Level::FATAL],
                 [false, Level::ERROR],
                 [false, Level::WARN],
                 [false, Level::INFO],
                 [true, Level::DEBUG],
               ] do |exp, value|
      logger = new_instance
      logger.level = value
      assert_equal exp, logger.verbose
    end

    param_test [
                 [Level::WARN, true],
                 [Level::DEBUG, false],
               ] do |exp, value|
      logger = new_instance
      logger.quiet = value
      assert_equal exp, logger.level
    end
  end
end
