require 'logue/elements/msg_element'
require 'logue/fixture/element_test_util'
require 'logue/tc'

module Logue
  class MsgElementTest < TestCase
    include ElementTestUtil

    def new_instance msg, lines
      MsgElement.new msg, Array.new, lines
    end

    def test_write
      run_write_test(" m1") do |lines|
        element = new_instance "m1", lines
        element.write_element
      end
    end
  end
end
