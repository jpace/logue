require 'logue/elements/element_factory'
require 'logue/tc'

module Logue
  class ElementFactoryTest < TestCase
    def test_to_msg_element
      obj = ElementFactory.new nil
      result1 = obj.to_msg_element "m1", :none, Array.new
      result2 = obj.to_msg_element "m1", ObjectUtil::NONE, Array.new
      result3 = obj.to_msg_element "m1", "str1", Array.new
      result4 = obj.to_msg_element "m1", nil, Array.new
      assert_instance_of MsgElement, result1
      assert_instance_of MsgElement, result2
      assert_instance_of MsgObjElement, result3
    end
  end
end
