require 'logue/loggable'
require 'logue/colorable'

class ExecAbc
  include Logue::Loggable
  include Logue::Colorable

  def m_x
    info "msg1", 123.4
    x = lambda { info "msg2", 24 }
    x.call
    yellow "amarillo", "bob"
  end

  def m_y
    yellow "amarillo", "bob"
    Logue::Log.green "green2", "objabc"
  end

  def m_writes_array
    ary = %w{ this is a test }
    info "ary", ary
  end

  def m_writes_msg_block arg
    info("mabc") { "arg is: #{arg}" }
  end

  def m_writes_block arg
    info { "arg is: #{arg}" }
  end

  def m_writes_stack
    stack "param1", "value1"
  end
end
