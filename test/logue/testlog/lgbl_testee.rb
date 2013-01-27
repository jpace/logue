#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'logue/loggable'

class LgblTestee
  include Logue::Loggable

  def crystal
    info "hello!"
    blue "azul ... "
    red "rojo?"
  end
end
