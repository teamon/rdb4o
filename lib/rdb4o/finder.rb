module Rdb4o
  class Finder < Java::com::rdb4o::RubyPredicate
    attr_accessor :proc, :klazz
    def rubyMatch(obj)
      if klazz.nil? || obj.is_a?(klazz)
        !!@proc.call(obj) # make sure we pass boolean
      else
        false
      end
    end

    class << self
      def new(proc, klazz = nil)
        finder = super()
        finder.proc = Proc.new {|obj| obj._load_attributes; proc.call(obj) }
        finder.klazz = klazz
        finder
      end
    end
  end

end
