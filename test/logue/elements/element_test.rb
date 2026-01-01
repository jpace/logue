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
  end
end
