require 'logue/elements/msg_obj_element'
require 'logue/fixture/element_test_util'
require 'logue/tc'

module Logue
  class MsgObjElementTest < TestCase
    include ElementTestUtil

    def new_instance msg, obj, lines
      context = [ obj.object_id ]
      MsgObjElement.new msg, obj, context, lines
    end

    def test_write
      run_write_test(" m1: 14") do |lines|
        element = new_instance "m1", 14, lines
        element.write_element
      end
    end
  end
end
