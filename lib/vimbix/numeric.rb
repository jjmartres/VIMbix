class Numeric

  # percentage = a/b*100 => a.percent_of(b)
  def percent_of(n)
    (self.to_f / n.to_f * 100.0).finite? ? self.to_f / n.to_f * 100.0 : 0.0
  end

end
