require 'logue/elements/hash_element'
require 'logue/fixture/element_test_util'
require 'logue/tc'

module Logue
  class HashElementTest < TestCase
    include ElementTestUtil

    def new_instance msg, obj, lines
      context = [ obj.object_id ]
      HashElement.new msg, obj, context, lines
    end

    def test_write
      arg = { first: 1, second: "two", third: "iii" }
      expected = %Q{
 m1[first]: 1
 m1[second]: two
 m1[third]: iii
      }
      run_write_test(expected) do |lines|
        element = new_instance "m1", arg, lines
        element.write_element
      end
    end
  end
end
