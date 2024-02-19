require 'logue/logger'
require 'logue/exec/exec_abc'
require 'logue/tc'

module Logue
  class ExecutionTest < TestCase
    def assert_arrays_equal expected, result
      lambdas = Array.new
      lambdas << lambda { assert_equal expected.length, result.length }
      (0...[expected.length, result.length].max).each do |lnum|
        lambdas << lambda { assert_equal expected[lnum], result[lnum], "line: #{lnum}" }
      end
      assert_all lambdas
    end

    def test_info
      expected = resource_lines "expected1.txt"
      puts "expected:"
      puts expected

      output = StringIO.new

      Logue::Log.verbose = true
      Logue::Log.set_widths(-32, 5, -45)
      Logue::Log.level = Logue::Level::INFO
      Logue::Log.output = output

      obj = ExecAbc.new
      obj.m_x

      output.close

      puts "result:"
      result = output.string.split("\n")
      puts result

      assert_arrays_equal expected, result
    end

    def test_debug_colors
      expected = resource_lines "expected2.txt"
      puts "expected:"
      puts expected

      output = StringIO.new

      Logue::Log.verbose = true
      Logue::Log.set_widths(-32, 5, -45)
      Logue::Log.level = Logue::Level::DEBUG
      Logue::Log.output = output

      obj = ExecAbc.new
      obj.m_x

      output.close

      puts "result:"
      result = output.string.split("\n")
      puts result

      lambdas = Array.new
      lambdas << lambda { assert_equal expected.length, result.length }
      (0...[expected.length, result.length].max).each do |lnum|
        lambdas << lambda { assert_equal expected[lnum], result[lnum], "line: #{lnum}" }
      end
      assert_all lambdas
    end

    def test_color_log
      expected = resource_lines "expected3.txt"
      puts "expected:"
      puts expected

      output = StringIO.new

      Logue::Log.verbose = true
      Logue::Log.set_widths(-32, 5, -45)
      Logue::Log.level = Logue::Level::DEBUG
      Logue::Log.output = output

      obj = ExecAbc.new
      obj.m_y

      output.close

      puts "result:"
      result = output.string.split("\n")
      puts result

      assert_arrays_equal expected, result
    end
  end
end