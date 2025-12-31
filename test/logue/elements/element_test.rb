require 'logue/elements/element'
require 'logue/elements/element_writer'
require 'logue/tc'
require 'stringio'

module Logue
  class ElementTest < TestCase
    def test_init
      obj = "xyz"
      lo = Element.new obj, nil
      assert_same obj, lo.object
    end

    def test_lines_scalar
      arg = "xyz"
      obj = Element.new arg, nil
      result = obj.lines
      assert_equal 'xyz', result
    end

    def test_lines_enumerable
      ary = %w{ this is a test }
      obj = Element.new ary, nil
      result = obj.lines
      assert_equal '["this", "is", "a", "test"]', result
    end
  end

  class BlockElementTest < TestCase
    def test_write_scalar_with_message
      io = StringIO.new
      writer = ElementWriter.new io
      element = BlockElement.new(writer) { "abc-def" }
      element.write_element "mabc", Array.new
      result = io.string
      assert_equal " mabc: abc-def\n", result
    end

    def test_write_scalar_no_message
      io = StringIO.new
      writer = ElementWriter.new io
      element = BlockElement.new(writer) { "abc-def" }
      element.write_element ObjectUtil::NONE, Array.new
      result = io.string
      assert_equal " abc-def\n", result
    end

    def test_write_array
      io = StringIO.new
      writer = ElementWriter.new io
      element = BlockElement.new(writer) { %w{ this is a test } }
      element.write_element "mabc", Array.new
      result = io.string
      assert_equal " mabc.#: 4\n mabc[0]: this\n mabc[1]: is\n mabc[2]: a\n mabc[3]: test\n", result
    end
  end
end
