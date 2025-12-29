require 'logue/locations/frame'
require 'logue/tc'

module Logue
  class FrameTest < TestCase
    param_test [
                 ["/path/a/b/c.rb", "labc", 3],
                 ["/path/d/e/f.rb", "lghi", 1],
                 ["/path/g/h/i.rb", "ljkl", 7],
                 ["(eval)", "labc", 3],
               ].each do |path, method, line|
      result = Frame.new path: path, method: method, line: line
      assert_all [
                   lambda { assert_equal path, result.path },
                   lambda { assert_equal method, result.method },
                   lambda { assert_equal line, result.line },
                 ]
    end
  end
end
