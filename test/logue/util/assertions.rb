require 'test/unit/assertions'

module Logue
  module Assertions
    include Test::Unit::Assertions

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
      num = [expected.size, actual.size].max
      lambdas = Array.new
      lambdas << lambda { assert_equal expected.size, actual.size }
      (0...num).each do |idx|
        exp = expected[idx]
        methname = Regexp === exp ? :assert_match : :assert_equal
        lambdas << create_lambda(methname, exp, actual[idx], idx)
      end
      assert_all lambdas
    end

    def create_lambda method, expected, actual, index
      lambda { send(method, expected, actual, "index: #{index}") }
    end
  end
end
