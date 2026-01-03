require 'logue/elements/elements_writer'
require 'logue/fixture/element_test_util'
require 'logue/level'
require 'logue/tc'
require 'stringio'

module Logue
  class ElementsWriterTest < TestCase
    include ElementTestUtil

    def test_write_msg_obj
      expected = %Q{
loc1 m1: obj2
      }
      run_the_test expected do |writer|
        locstr = "loc1"
        writer.write_msg_obj locstr, "m1", "obj2", Level::DEBUG
      end
    end

    def test_write_block_scalar
      expected = %Q{
loc1 : x: 17
      }
      run_the_test expected do |writer|
        locstr = "loc1"
        msg = ""
        level = Level::DEBUG
        x = 17
        blk = Proc.new { "x: #{x}" }
        writer.write_msg_blk locstr, msg, level, &blk
      end
    end

    def test_write_block_complex
      expected = %Q{
loc1 .#: 4
loc1 [0]: this
loc1 [1]: is
loc1 [2]: a
loc1 [3]: test
      }
      run_the_test expected do |writer|
        locstr = "loc1"
        msg = ""
        level = Level::DEBUG
        x = %w{ this is a test }
        blk = Proc.new { x }
        writer.write_msg_blk locstr, msg, level, &blk
      end
    end

    def test_write_array_hash
      expected = %Q{
loc1 ary.#: 2
loc1 ary[0][this]: is
loc1 ary[0][a]: test
loc1 ary[1][so]: too
loc1 ary[1][is]: this
      }
      run_the_test expected do |writer|
        locstr = "loc1"
        msg = "ary"
        obj = Array.new
        obj << { this: 'is', a: 'test' }
        obj << { so: 'too', is: 'this' }
        level = Level::DEBUG
        writer.write_msg_obj locstr, msg, obj, level
      end
    end

    def run_the_test expected, &blk
      strio = StringIO.new
      writer = ElementsWriter.new output: strio
      blk.call writer
      strio.close
      result = strio.string
      compare_lines expected, result
    end

    def test_write_array_with_array
      arg = Array.new.tap do |a|
        a << %w{ abc def }
        a << %w{ jkl mno pqr }
      end
      expected = %Q{
loc1 m1.#: 2
loc1 m1[0].#: 2
loc1 m1[0][0]: abc
loc1 m1[0][1]: def
loc1 m1[1].#: 3
loc1 m1[1][0]: jkl
loc1 m1[1][1]: mno
loc1 m1[1][2]: pqr
      }
      run_the_test(expected) do |writer|
        locstr = "loc1"
        msg = "m1"
        level = Level::DEBUG
        writer.write_msg_obj locstr, msg, arg, level
      end
    end
  end
end