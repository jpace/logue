require 'logue/pathname_util'
require 'test/unit'
require 'paramesan'

module Logue
  class TestCase < Test::Unit::TestCase
    include Paramesan

    def assert_all blocks = Array.new
      errors = Array.new
      blocks.each do |blk|
        begin
          blk.call
        rescue Test::Unit::AssertionFailedError => err
          errors << [err, blk]
        end
      end
      unless errors.empty?
        puts "#{errors.size} errors"
        errors.each do |err, blk|
          puts err
          puts err.backtrace
        end
        fail("")
      end
    end

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
