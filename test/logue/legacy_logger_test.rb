require 'logue/legacy_logger'
require 'logue/writer'
require 'logue/filter'
require 'logue/tc'
require 'pathname'

module Logue
  class LegacyLoggerTest < TestCase
    def create_logger
      Object.new.tap do |obj|
        obj.extend LegacyLogger

        def obj.writer
          @writer ||= Writer.new
        end

        def obj.filter
          @filter ||= Filter.new
        end

        def obj.format= fmt
          @format = fmt
        end
      end
    end

    def setup
      @logger = create_logger
    end
    
    def test_trim
      @logger.trim = false
    end
    
    def test_output
      file = File.new "/tmp/legacy_logger_test-abc", "w"
      begin
        @logger.output = file
      ensure
        Pathname.new(file).unlink
      end
    end
    
    def test_ignore_file
      @logger.ignore_file "abc"
    end
    
    def test_set_default_widths
      @logger.set_default_widths
    end
  end
end
