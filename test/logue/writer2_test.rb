require 'logue/writer2'
require 'logue/level'
require 'logue/tc'
require 'stringio'

module Logue
  class Writer2Test < TestCase
    def test_write_msg_obj
      expected = "loc1 m1: obj2\n"
      strio = StringIO.new
      writer = Writer2.new output: strio
      locstr = "loc1"
      writer.write_msg_obj locstr, "m1", "obj2", Level::DEBUG
      strio.close
      assert_equal expected, strio.string
    end

    def test_write_block_scalar
      expected = "loc1 : x: 17\n"
      strio = StringIO.new
      writer = Writer2.new output: strio
      locstr = "loc1"
      msg = ""
      obj = nil
      level = Level::DEBUG
      x = 17
      blk = Proc.new { "x: #{x}" }
      writer.write_msg_obj locstr, msg, obj, level, &blk
      strio.close
      assert_equal expected, strio.string
    end

    def test_write_block_complex
      expected = "loc1 .#: 4\n" +
        "loc1 [0]: this\n" +
        "loc1 [1]: is\n" +
        "loc1 [2]: a\n" +
        "loc1 [3]: test\n"
      strio = StringIO.new
      writer = Writer2.new output: strio
      locstr = "loc1"
      msg = ""
      obj = nil
      level = Level::DEBUG
      x = %w{ this is a test }
      blk = Proc.new { x }
      writer.write_msg_obj locstr, msg, obj, level, &blk
      strio.close
      assert_equal expected, strio.string
    end

    def test_write_array_hash
      expected = "loc1 ary.#: 2\n" +
        "loc1 ary[0][this]: is\n" +
        "loc1 ary[0][a]: test\n" +
        "loc1 ary[1][so]: too\n" +
        "loc1 ary[1][is]: this\n"
      strio = StringIO.new
      writer = Writer2.new output: strio
      locstr = "loc1"
      msg = "ary"
      obj = Array.new
      obj << { this: 'is', a: 'test'}
      obj << { so: 'too', is: 'this'}
      level = Level::DEBUG
      writer.write_msg_obj locstr, msg, obj, level
      strio.close
      assert_equal expected, strio.string
    end
  end
end