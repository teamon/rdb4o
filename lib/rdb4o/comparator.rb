module Rdb4o
  class Comparator < Java::com::rdb4o::RubyComparator
    attr_accessor :proc

    def rubyCompare(first, second)
      @proc.call(first, second)
    end

    def self.new(proc)
      comp = super()
      comp.proc = proc
      comp
    end

  end
end
