require 'logue/locations/location'
require 'logue/lines/lines_writer'
require 'logue/level'
require 'logue/locations/frame'
require 'logue/tc'
require 'stringio'

module Logue
  class LinesWriterTest < TestCase
    def self.example_frame
      Frame.new path: "/path/a/b/c", method: "labc", line: 3
    end

    def test_init
      strio = StringIO.new
      writer = LinesWriter.new output: strio
      # I think assert_same should compare by ID, not #equal?
      assert_all [
                   lambda { assert_equal strio.object_id, writer.output.object_id },
                   lambda { assert_equal Array.new, writer.colors },
                   lambda { assert_equal false, writer.colorize_line },
                 ]
      strio.close
    end

    def test_print
      strio = StringIO.new
      writer = LinesWriter.new output: strio
      writer.print "hdrabc msgdef\n", Level::DEBUG
      strio.close
      assert_equal "hdrabc msgdef\n", strio.string
    end

    def test_write
      expected = "[/path/a/b/c              :   3] {abc#labc            } 123\n"
      strio = StringIO.new
      writer = LinesWriter.new output: strio
      frame = self.class.example_frame
      location = Location.new frame.path, frame.line, "abc", frame.method
      locfmt = LocationFormat.new
      locstr = locfmt.format_location location
      writer.write locstr, "123", Level::DEBUG
      strio.close
      assert_equal expected, strio.string
    end

    def test_write_msg_obj
      expected = "[/path/a/b/c              :   3] {abc#labc            } m1: obj2\n"
      strio = StringIO.new
      writer = LinesWriter.new output: strio
      frame = self.class.example_frame
      location = Location.new frame.path, frame.line, "abc", frame.method
      locfmt = LocationFormat.new
      locstr = locfmt.format_location location
      writer.write_msg_obj locstr, "m1", "obj2", Level::DEBUG
      strio.close
      assert_equal expected, strio.string
    end
  end
end
