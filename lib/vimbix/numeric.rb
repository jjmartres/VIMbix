class Numeric

  # percentage = a/b*100 => a.percent_of(b)
  def percent_of(n)
    (self.to_f / n.to_f ).finite? ? self.to_f / n.to_f : 0.0
  end

end
