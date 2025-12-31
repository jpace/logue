require 'logue/elements/element'
require 'logue/elements/element_writer'
require 'logue/tc'

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
end
