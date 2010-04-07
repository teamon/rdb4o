class Symbol
  def asc
    Jrodb::OrderOperator.new(:asc, self)
  end

  def desc
    Jrodb::OrderOperator.new(:desc, self)
  end
end
