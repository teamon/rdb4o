class Symbol
  def asc
    Rdb4o::OrderOperator.new(:asc, self)
  end

  def desc
    Rdb4o::OrderOperator.new(:desc, self)
  end
end
