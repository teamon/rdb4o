module Rdb4o
  class OrderOperator
    attr_accessor :type, :field

    def initialize(type, field)
      @type, @field = type, field
    end

    def result(num)
      type == :desc ? -num : num
    end
  end
end
