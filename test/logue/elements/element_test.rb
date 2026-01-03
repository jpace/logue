require 'logue/elements/element'
require 'logue/elements/element_lines'
require 'logue/tc'

module Logue
  class ElementTest < TestCase
    def test_init
      msg = "mabc"
      obj = "vxyz"
      lo = Element.new msg, obj, Array.new, nil
      assert_same obj, lo.object
    end
  end
end
