require 'logue/elements/element'
require 'logue/fixture/element_test_util'
require 'logue/tc'

module Logue
  class IndexedElementTest < TestCase
    include ElementTestUtil

    def test_init
      expected = %Q{
 mabc.#: 4
 mabc[0]: this
 mabc[1]: is
 mabc[2]: a
 mabc[3]: test
      }
      arg = %w{ this is a test }
      run_write_test(expected) do |lines|
        obj = IndexedElement.new arg, lines
        obj.write_element "mabc", Array.new
      end
    end
  end
end
