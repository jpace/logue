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
end
