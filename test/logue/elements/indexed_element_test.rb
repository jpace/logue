require 'logue/elements/element'
require 'logue/fixture/element_test_util'
require 'logue/tc'

module Logue
  class IndexedElementTest < TestCase
    include ElementTestUtil

    def new_instance msg, obj, lines
      context = [ obj.object_id ]
      IndexedElement.new msg, obj, context, lines
    end

    def test_one_dimension
      expected = %Q{
 mabc.#: 4
 mabc[0]: this
 mabc[1]: is
 mabc[2]: a
 mabc[3]: test
      }
      arg = %w{ this is a test }
      run_write_test(expected) do |lines|
        obj = new_instance "mabc", arg, lines
        obj.write_element
      end
    end

    def test_two_dimension
      arg = Array.new.tap do |a|
        a << %w{ abc def }
        a << %w{ jkl mno pqr }
      end
      expected = %Q{
 m1.#: 2
 m1[0].#: 2
 m1[0][0]: abc
 m1[0][1]: def
 m1[1].#: 3
 m1[1][0]: jkl
 m1[1][1]: mno
 m1[1][2]: pqr
      }
      run_write_test(expected) do |lines|
        obj = new_instance "m1", arg, lines
        obj.write_element
      end
    end

    def test_recurse
      a = %w{ abc def }
      b = ["one", a]
      a << b
      arg = a
      expected = Array.new.tap do |ary|
        ary << " m1.#: 3"
        ary << " m1[0]: abc"
        ary << " m1[1]: def"
        ary << " m1[2].#: 2"
        ary << " m1[2][0]: one"
        ary << Regexp.new(' m1\[2\]\[1\]: \d+ \(recursed\)')
      end
      run_write_test(expected) do |lines|
        obj = new_instance "m1", arg, lines
        obj.write_element
      end
    end
  end
end
