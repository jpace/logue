# warnings from teamcity/testrunner_events, so turn them off:
$VERBOSE = false

require 'logue/pathname_util'
require 'test/unit'
require 'logue/util/assertions'
require 'paramesan'

module Logue
  class TestCase < Test::Unit::TestCase
    include Paramesan
    include Logue::Assertions

    def resource_file name
      pn = Pathname.new __FILE__
      PathnameUtil.upto(pn, "test") + "resources/#{name}"
    end

    def resource_lines fname
      file = resource_file fname
      IO.readlines(file).map(&:strip)
    end
  end
end
