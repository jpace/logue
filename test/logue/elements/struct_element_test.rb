require 'logue/elements/struct_element'
require 'logue/fixture/element_test_util'
require 'logue/tc'

module Logue
  class StructElementTest < TestCase
    include ElementTestUtil

    def new_instance msg, obj, lines
      context = [ obj.object_id ]
      StructElement.new msg, obj, context, lines
    end

    def test_write_struct
      str = Struct.new :x, :y
      arg = str.new 14, "abc"
      expected = %Q{
 m1[x]: 14
 m1[y]: abc
      }
      run_write_test(expected) do |lines|
        element = new_instance "m1", arg, lines
        element.write_element
      end
    end
  end
end
