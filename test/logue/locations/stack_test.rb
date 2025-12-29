require 'logue/locations/stack'
require 'logue/tc'

module Logue
  class StackTest < TestCase
    def test_init
      lnum = __LINE__
      result = Stack.new
      frame1 = result.frames[0]
      frame2 = result.frames[1]
      assert_all [
                   lambda { assert_equal "stack_test.rb", Pathname.new(frame1.path).basename.to_s },
                   lambda { assert_equal lnum + 1, frame1.line },
                   lambda { assert_equal "test_init", frame1.method },
                   lambda { assert_equal "testcase.rb", Pathname.new(frame2.path).basename.to_s },
                   lambda { assert_equal "run_test", frame2.method },
                 ]
    end

    def second
      lnum = __LINE__
      result = Stack.new
      frame1 = result.frames[0]
      frame2 = result.frames[1]
      assert_all [
                   lambda { assert_equal "stack_test.rb", Pathname.new(frame1.path).basename.to_s },
                   lambda { assert_equal lnum + 1, frame1.line },
                   lambda { assert_equal "second", frame1.method },
                   lambda { assert_equal "(eval)", frame2.path },
                   lambda { assert_equal 2, frame2.line },
                   lambda { assert_equal "first", frame2.method },
                 ]
    end

    def test_from_eval
      instmeth = Array.new.tap do |a|
        a << 'def first'
        a << '  second'
        a << 'end'
      end
      instance_eval instmeth.join "\n"
      first
    end
  end
end
