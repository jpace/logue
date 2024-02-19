require 'logue/element'
require 'logue/tc'
require 'stringio'

module Logue
  class ElementTest < TestCase
    def test_init
      obj = "xyz"
      lo = Element.new obj
      assert_same obj, lo.object
    end

    def test_lines_scalar
      arg = "xyz"
      obj = Element.new arg
      result = obj.lines
      assert_equal 'xyz', result
    end

    def test_lines_enumerable
      ary = %w{ this is a test }
      obj = Element.new ary
      result = obj.lines
      assert_equal '["this", "is", "a", "test"] (#:4)', result
    end
  end
end
