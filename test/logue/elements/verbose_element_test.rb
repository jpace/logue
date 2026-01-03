require 'logue/elements/verbose_element'
require 'logue/fixture/element_test_util'
require 'logue/tc'

module Logue
  class VerboseElementTest < TestCase
    include ElementTestUtil

    class Xyz
      def initialize val
        @val = val
        @ary = ["one", { two: "dos" }, "trois"]
      end

      def to_s
        "value: #{@val}"
      end
    end

    def new_instance msg, obj, lines
      context = [obj.object_id]
      VerboseElement.new msg, obj, context, lines
    end

    def test_write
      obj = Xyz.new 3.166
      expected = Array.new.tap do |a|
        a << " m1: verbose"
        a << " m1.class: Logue::VerboseElementTest::Xyz"
        a << Regexp.new(' m1.id: \d+')
        a << " m1: value: 3.166"
        a << " m1.@val: 3.166"
        a << " m1.@ary.#: 3"
        a << " m1.@ary[0]: one"
        a << " m1.@ary[1][two]: dos"
        a << " m1.@ary[2]: trois"
      end
      run_write_test(expected) do |lines|
        element = new_instance "m1", obj, lines
        element.write_element
      end
    end
  end
end
