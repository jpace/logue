module PathnameUtil
  extend self

  def upto pn, name
    t = pn
    while true
      case t
      when nil, -> (it) { it.root? }
        return nil
      when -> (it) { it.basename.to_s == name }
        return t
      else
        t = t.parent
      end
    end
  end
end
