#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'test/unit'
require 'stringio'
require 'logue'

include Logue

class LogAbyss
  include Loggable

  def squeal
    log "hello from the abyss"
    stack "turtles all the way down"
  end
end

class LogDepths
  include Loggable

  def speak
    log "hello from the depths"
    la = LogAbyss.new
    la.squeal
  end
end

class LogInner
  include Loggable

  def screech
    ldi = LogDepths.new
    log "hello from the innerds"
    ldi.speak
  end
end

class LogStackTestCase < Test::Unit::TestCase
  include Loggable

  def test_stack
    Log.set_widths(-15, 4, -40)
    
    log = Proc.new { 
      li = LogInner.new
      li.screech
    }

    expected_output = [
                       "[log_stack_test.rb:  35] {LogInner#screech                        } hello from the innerds",
                       "[log_stack_test.rb:  24] {LogDepths#speak                         } hello from the depths",
                       "[log_stack_test.rb:  15] {LogAbyss#squeal                         } hello from the abyss",
                       "[log_stack_test.rb:  16] {LogAbyss#squeal                         } turtles all the way down",
                       "[log_stack_test.rb:  26] {speak                                   } ",
                       "[log_stack_test.rb:  36] {screech                                 } ",
                      ]

    do_run_test @verbose_setup, log, *expected_output
  end

  # the ctor is down here so the lines above are less likely to change.
  def initialize test, name = nil
    @nonverbose_setup = Proc.new {
      Log.verbose = false
      Log.output  = StringIO.new
    }
    
    @verbose_setup = Proc.new {
      Log.verbose = true
      Log.output  = StringIO.new
    }

    super test
  end

  def do_run_test setup, log, *expected
    io = setup.call

    log.call

    assert_not_nil io
    str = io.string
    assert_not_nil str

    lines = str.split "\n"

    (0 ... expected.size).each do |idx|
      if expected[idx]
        assert_equal expected[idx], lines[idx], "index: #{idx}"
      end
    end

    Log.output = io
  end
end
