require 'logue/elements/block_element'
require 'logue/elements/element_writer'
require 'logue/tc'
require 'stringio'

module Logue
  class BlockElementTest < TestCase
    def test_write_scalar_with_message
      io = StringIO.new
      writer = ElementWriter.new io
      element = BlockElement.new("mabc", writer) { "abc-def" }
      element.write_element Array.new
      result = io.string
      assert_equal " mabc: abc-def\n", result
    end

    def test_write_scalar_no_message
      io = StringIO.new
      writer = ElementWriter.new io
      element = BlockElement.new(ObjectUtil::NONE, writer) { "abc-def" }
      element.write_element Array.new
      result = io.string
      assert_equal " abc-def\n", result
    end

    def test_write_array
      io = StringIO.new
      writer = ElementWriter.new io
      element = BlockElement.new("mabc", writer) { %w{ this is a test } }
      element.write_element Array.new
      result = io.string
      assert_equal " mabc.#: 4\n mabc[0]: this\n mabc[1]: is\n mabc[2]: a\n mabc[3]: test\n", result
    end
  end
end
