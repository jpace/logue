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
      output.string.split("\n")
    end

    def test_info
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :    9] {ExecAbc#m_x                                  } msg1: 123.4
        [.../test/logue/exec/exec_abc.rb :   10] {ExecAbc#block in m_x                         } msg2: 24
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::INFO, Logue::Writer2.new) do
        obj = ExecAbc.new
        obj.m_x
      end
      assert_lines expected, result
    end

    def test_debug_colors
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :    9] {ExecAbc#m_x                                  } msg1: 123.4
        [.../test/logue/exec/exec_abc.rb :   10] {ExecAbc#block in m_x                         } msg2: 24
        [.../test/logue/exec/exec_abc.rb :   12] {ExecAbc#m_x                                  } [33mamarillo[0m: bob
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer2.new) do
        obj = ExecAbc.new
        obj.m_x
      end
      assert_lines expected, result
    end

    def test_color_log
      expected = resource_lines "expected3.txt"
      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_y
      end
      assert_lines expected, result
    end

    def test_array
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary.#: 4
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[0]: this
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[1]: is
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[2]: a
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[3]: test
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer2.new) do
        obj = ExecAbc.new
        obj.m_writes_array
      end
      assert_lines expected, result
    end

    def test_block
      expected = %Q{
       [.../test/logue/exec/exec_abc.rb :   30] {ExecAbc#m_writes_block                       } arg is: xyz
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer2.new) do
        obj = ExecAbc.new
        obj.m_writes_block "xyz"
      end
      assert_equal expected, result
    end

    def test_msg_block
      expected = %Q{
       [.../test/logue/exec/exec_abc.rb :   26] {ExecAbc#m_writes_msg_block                   } mabc: arg is: xyz
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer2.new) do
        obj = ExecAbc.new
        obj.m_writes_msg_block "xyz"
      end
      assert_equal expected, result
    end

    def test_array_legacy
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary: ["this", "is", "a", "test"]
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_writes_array
      end
      assert_lines expected, result
    end

    def test_stack
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :   34] {ExecAbc#m_writes_stack                       } param1: value1
        [.../logue/exec/execution_test.rb:  116] {block in test_stack                          }
        [.../logue/exec/execution_test.rb:   20] {run_exec_test                                }
        [.../logue/exec/execution_test.rb:  114] {test_stack                                   }
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::Writer.new) do
        obj = ExecAbc.new
        obj.m_writes_stack
      end
      assert_lines expected, result[0, expected.size].map(&:strip)
    end
  end
end