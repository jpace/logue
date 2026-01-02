require 'logue/elements/block_element'
require 'logue/fixture/element_test_util'
require 'logue/tc'


module Logue
  class BlockElementTest < TestCase
    include ElementTestUtil

    def test_write_scalar_with_message
      run_write_test(" mabc: abc-def\n") do |lines|
        element = BlockElement.new("mabc", lines) { "abc-def" }
        element.write_element Array.new
      end
    end

    def test_write_scalar_no_message
      run_write_test(" abc-def\n") do |lines|
        element = BlockElement.new(ObjectUtil::NONE, lines) { "abc-def" }
        element.write_element Array.new
      end
    end

    def test_write_array
      expected = %Q{
 mabc.#: 4
 mabc[0]: this
 mabc[1]: is
 mabc[2]: a
 mabc[3]: test
      }
      run_write_test(expected) do |lines|
        element = BlockElement.new("mabc", lines) { %w{ this is a test } }
        element.write_element Array.new
      end
    end
  end
end
