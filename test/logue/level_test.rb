require 'logue/level'
require 'logue/tc'

module Logue
  class LevelTest < TestCase
    def test_compare_all
      levels = [Level::DEBUG, Level::INFO, Level::WARN, Level::ERROR, Level::FATAL]
      lambdas = levels[1...-1].collect do |it|
        lambda { assert_true levels[it - 1] < levels[it], "it: #{it}, #{levels[it - 1]} < #{levels[it]}" }
      end
      assert_all lambdas
    end
  end
end
