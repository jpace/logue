require 'logue/write/element_writer'
require 'logue/level'
require 'logue/tc'
require 'stringio'
require 'bigdecimal'

module Logue
  class ElementWriterTest < TestCase
    def run_writer_test &blk
      strio = StringIO.new
      locstr = "loc1"
      writer = ElementWriter.new strio, locstr
      blk.call writer
      strio.close
      result = strio.string
      puts "result:"
      puts result
      result
    end

    def test_write_scalar
      expected = Array.new.tap do |a|
        a << "loc1 m1: obj2"
      end
      result = run_writer_test do |writer|
        writer.write_msg_obj "m1", "obj2"
      end
      assert_lines expected, result
    end

    def test_write_array
      arg = %w{ this is a test }
      expected = Array.new.tap do |a|
        a << "loc1 m1.#: 4"
        a << "loc1 m1[0]: this"
        a << "loc1 m1[1]: is"
        a << "loc1 m1[2]: a"
        a << "loc1 m1[3]: test"
      end
      result = run_writer_test do |writer|
        writer.write_msg_obj "m1", arg
      end
      assert_lines expected, result
    end

    def test_write_array_with_array
      arg = Array.new.tap do |a|
        a << %w{ abc def }
        a << %w{ jkl mno pqr }
      end
      expected = Array.new.tap do |a|
        a << "loc1 m1.#: 2"
        a << "loc1 m1[0].#: 2"
        a << "loc1 m1[0][0]: abc"
        a << "loc1 m1[0][1]: def"
        a << "loc1 m1[1].#: 3"
        a << "loc1 m1[1][0]: jkl"
        a << "loc1 m1[1][1]: mno"
        a << "loc1 m1[1][2]: pqr"
      end
      result = run_writer_test do |writer|
        writer.write_msg_obj "m1", arg
      end
      assert_lines expected, result
    end

    def test_write_hash
      arg = { first: 1, second: "two", third: "iii" }
      expected = Array.new.tap do |a|
        a << "loc1 m1[first]: 1"
        a << "loc1 m1[second]: two"
        a << "loc1 m1[third]: iii"
      end
      result = run_writer_test do |writer|
        writer.write_msg_obj "m1", arg
      end
      assert_lines expected, result
    end

    def test_write_struct
      str = Struct.new :x, :y
      arg = str.new 14, "abc"
      expected = Array.new.tap do |a|
        a << "loc1 m1[x]: 14"
        a << "loc1 m1[y]: abc"
      end
      result = run_writer_test do |writer|
        writer.write_msg_obj "m1", arg
      end
      assert_lines expected, result
    end

    def test_write_no_recurse
      a = %w{ abc def }
      b = ["one", a]
      a << b
      arg = a
      expected = Array.new.tap do |ary|
        ary << "loc1 m1.#: 3"
        ary << "loc1 m1[0]: abc"
        ary << "loc1 m1[1]: def"
        ary << "loc1 m1[2].#: 2"
        ary << "loc1 m1[2][0]: one"
        ary << Regexp.new('loc1 m1\[2\]\[1\]: \d+ \(recursed\)')
      end
      result = run_writer_test do |writer|
        writer.write_msg_obj "m1", arg
      end
      assert_lines expected, result
    end

    def test_write_nil
      arg = nil
      expected = Array.new.tap do |a|
        a << "loc1 m1"
      end
      result = run_writer_test do |writer|
        writer.write_msg_obj "m1", arg
      end
      assert_lines expected, result
    end

    class Xyz
      def initialize val
        @val = val
        @ary = [ "one", { two: "dos" }, "trois"]
      end

      def to_s
        "value: #{@val}"
      end
    end

    def test_verbose
      obj = Xyz.new 3.166
      expected = Array.new.tap do |a|
        a << "loc1 m1: verbose"
        a << "loc1 m1.class: Logue::ElementWriterTest::Xyz"
        a << Regexp.new('loc1 m1.id: \d+')
        a << "loc1 m1: value: 3.166"
        a << "loc1 m1.@val: 3.166"
        a << "loc1 m1.@ary.#: 3"
        a << "loc1 m1.@ary[0]: one"
        a << "loc1 m1.@ary[1][two]: dos"
        a << "loc1 m1.@ary[2]: trois"
      end
      result = run_writer_test do |writer|
        arg = VerboseElement.new obj, writer: writer
        writer.write_msg_obj "m1", arg
      end
      assert_lines expected, result
    end
  end
end