module Jrodb
  class Comparator < Java::com::jrodb::RubyComparator
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
