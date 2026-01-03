require 'logue/logger'
require 'logue/exec/exec_abc'
require 'logue/elements/elements_writer'
require 'logue/lines/lines_writer'
require 'logue/tc'
require 'stringio'

module Logue
  class ExecutionTest < TestCase
    def test_stack
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :   34] {ExecAbc#m_writes_stack                       } param1: value1
        [.../logue/exec/execution_test.rb:   19] {block in test_stack                          }
        [.../logue/exec/execution_test.rb:   30] {run_exec_test                                }
        [.../logue/exec/execution_test.rb:   17] {test_stack                                   }
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::LinesWriter) do
        obj = ExecAbc.new
        obj.m_writes_stack
      end
      assert_lines expected, result[0, expected.size].map(&:strip)
    end

    def run_exec_test level, cls, &blk
      output = StringIO.new
      writer = cls.new output: output
      format = LocationFormat.new file: -32, line: 5, method: -45
      logger = Logue::Logger.new writer: writer, level: level, format: format
      Logue::Log.logger = logger
      blk.call
      output.close
      output.string.split "\n"
    end

    def test_info
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :    9] {ExecAbc#m_x                                  } msg1: 123.4
        [.../test/logue/exec/exec_abc.rb :   10] {ExecAbc#block in m_x                         } msg2: 24
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::INFO, Logue::ElementsWriter) do
        obj = ExecAbc.new
        obj.m_x
      end
      assert_not_empty result
      assert_lines expected, result
    end

    def test_debug_colors
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :    9] {ExecAbc#m_x                                  } msg1: 123.4
        [.../test/logue/exec/exec_abc.rb :   10] {ExecAbc#block in m_x                         } msg2: 24
        [.../test/logue/exec/exec_abc.rb :   12] {ExecAbc#m_x                                  } [33mamarillo[0m: bob
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::ElementsWriter) do
        obj = ExecAbc.new
        obj.m_x
      end
      assert_lines expected, result
    end

    def test_color_log
      expected = resource_lines "expected3.txt"
      result = run_exec_test(Logue::Level::DEBUG, Logue::LinesWriter) do
        obj = ExecAbc.new
        obj.m_y
      end
      assert_lines expected, result
    end

    def test_array_elements
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary.#: 4
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[0]: this
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[1]: is
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[2]: a
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary[3]: test
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::ElementsWriter) do
        obj = ExecAbc.new
        obj.m_writes_array
      end
      assert_lines expected, result
    end

    def test_array_lines
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary: ["this", "is", "a", "test"]
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::LinesWriter) do
        obj = ExecAbc.new
        obj.m_writes_array
      end
      assert_lines expected, result
    end

    def test_block
      expected = %Q{
       [.../test/logue/exec/exec_abc.rb :   30] {ExecAbc#m_writes_block                       } arg is: xyz
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::ElementsWriter) do
        obj = ExecAbc.new
        obj.m_writes_block "xyz"
      end
      assert_equal expected, result
    end

    def test_msg_block
      expected = %Q{
       [.../test/logue/exec/exec_abc.rb :   26] {ExecAbc#m_writes_msg_block                   } mabc: arg is: xyz
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::ElementsWriter) do
        obj = ExecAbc.new
        obj.m_writes_msg_block "xyz"
      end
      assert_equal expected, result
    end

    def test_array_legacy
      expected = %Q{
        [.../test/logue/exec/exec_abc.rb :   22] {ExecAbc#m_writes_array                       } ary: ["this", "is", "a", "test"]
      }.strip.split("\n").map(&:strip)
      result = run_exec_test(Logue::Level::DEBUG, Logue::LinesWriter) do
        obj = ExecAbc.new
        obj.m_writes_array
      end
      assert_lines expected, result
    end
  end
end