# warnings from teamcity/testrunner_events, so turn them off:
$VERBOSE = false

require 'logue/pathname_util'
require 'test/unit'
require 'paramesan'

module Logue
  class TestCase < Test::Unit::TestCase
    include Paramesan

    def assert_all blocks = Array.new
      errors = Array.new
      blocks.each do |blk|
        begin
          blk.call
        rescue => err
          errors << [err, blk]
        end
      end
      unless errors.empty?
        puts "#{errors.size} errors"
        errors.each do |err, blk|
          puts err
          puts err.backtrace
        end
        fail("")
      end
    end

    def assert_lines expected, actual
      if String === actual
        actual = actual.split("\n")
      end
      lambdas = Array.new
      lambdas << lambda { assert_equal expected.size, actual.size }
      num = [ expected.size, actual.size ].max
      (0...num).each do |idx|
        exp = expected[idx]
        act = actual[idx]
        if Regexp === exp
          lambdas << lambda { assert_match exp, act, "index: #{idx}" }
        else
          lambdas << lambda { assert_equal exp, act, "index: #{idx}" }
        end
      end
      assert_all lambdas
    end

    def resource_file name
      pn = Pathname.new __FILE__
      PathnameUtil.upto(pn, "test") + "resources/#{name}"
    end

    def resource_lines fname
      file = resource_file fname
      IO.readlines(file).map(&:strip)
    end
  end
end
