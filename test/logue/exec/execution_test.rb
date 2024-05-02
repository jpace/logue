require 'logue/logger'
require 'logue/exec/exec_abc'
require 'logue/writer2'
require 'logue/tc'
require 'stringio'

module Logue
  class ExecutionTest < TestCase
    def run_exec_test level, writer = nil, &blk
      output = StringIO.new
      Logue::Log.verbose = true
      Logue::Log.set_widths(-32, 5, -45)
      Logue::Log.level = level
      # need to replace the logger before changing the output
      if writer
        Logue::Log.logger.writer = writer
      end
      Logue::Log.output = output

      blk.call
      output.close
      result = output.string.split("\n")

      puts "result:"
      puts result

      result
    end

    def test_info
      expected = resource_lines "expected1.txt"
      puts "expected:"
      puts expected

      result = run_exec_test(Logue::Level::INFO, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_x
      end

      assert_lines expected, result
    end

    def test_debug_colors
      expected = resource_lines "expected2.txt"
      puts "expected:"
      puts expected

      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_x
      end

      assert_lines expected, result
    end

    def test_color_log
      expected = resource_lines "expected3.txt"
      puts "expected:"
      puts expected

      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_y
      end

      assert_lines expected, result
    end

    def test_array
      expected = resource_lines "expected_m_z_array.txt"
      puts "expected:"
      puts expected

      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer2.new) do
        obj = ExecAbc.new
        obj.m_z
      end

      assert_lines expected, result
    end

    def test_block
      expected = resource_lines "expected_m_w_block.txt"
      puts "expected:"
      puts expected

      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_w "xyz"
      end

      assert_lines expected, result
    end

    def test_array_legacy
      expected = resource_lines "expected_m_z_array_legacy.txt"
      puts "expected:"
      puts expected

      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_z
      end

      assert_lines expected, result
    end
  end
end