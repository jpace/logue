#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue'
require 'test_helper'
require 'stringio'

class LogAbyss
  include Logue::Loggable

  def squeal
    log "hello from the abyss"
    stack "turtles all the way down"
  end
end

class LogDepths
  include Logue::Loggable

  def speak
    log "hello from the depths"
    la = LogAbyss.new
    la.squeal
  end
end

class LogInner
  include Logue::Loggable

  def screech
    ldi = LogDepths.new
    log "hello from the innerds"
    ldi.speak
  end
end

module Logue
  class LogStackTestCase < Test::Unit::TestCase
    include Loggable

    def test_stack
      Log.set_widths(-15, 4, -40)
      
      block = Proc.new { 
        li = LogInner.new
        li.screech
      }

      expected_output = [
        "[log_stack_test.rb:  32] {LogInner#screech                        } hello from the innerds",
        "[log_stack_test.rb:  21] {LogDepths#speak                         } hello from the depths",
        "[log_stack_test.rb:  12] {LogAbyss#squeal                         } hello from the abyss",
        "[log_stack_test.rb:  13] {LogAbyss#squeal                         } turtles all the way down",
        "[log_stack_test.rb:  23] {speak                                   } ",
        "[log_stack_test.rb:  33] {screech                                 } ",
      ]

      do_run_test block, *expected_output
    end

    def do_run_test block, *expected
      Log.verbose = true
      io = Log.output = StringIO.new

      block.call

      assert_not_nil io
      str = io.string
      assert_not_nil str

      lines = str.split "\n"

      (0 ... expected.size).each do |idx|
        if expected[idx]
          assert_equal expected[idx], lines[idx], "index: #{idx}"
        end
      end
    end
  end
end
