#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'

pn = Pathname.pwd
libpath = pn + "lib"
$:.unshift libpath

require 'logue'

Logue::Log.level = Logue::Level::DEBUG

class Run
  include Logue::Loggable
  
  def initialize args
    # info "args: #{args}"
    blue "args", args
    green "args", args
  end
end

Run.new ARGV
