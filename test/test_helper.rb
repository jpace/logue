require 'test/unit'
require 'paramesan'

module Messager
  def message(*fields)
    fields.each_slice(2).collect do |field, value|
      "#{field}: #{value}"
    end.join "; "
  end
end
