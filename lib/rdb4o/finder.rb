module Rdb4o
  class Finder < Java::com::rdb4o::RubyPredicate
    attr_accessor :proc, :model
    
    def rubyMatch(obj)
      if model.nil? || obj.is_a?(model)
        !!@proc.call(obj) # make sure we pass boolean
      else
        false
      end
    end

    class << self
      def new(model, conditions, procs)
        finder = super()
        finder.model = model
        
        unless conditions.empty?
          procs.push Proc.new {|obj| conditions.all? {|k, v| obj.attributes[k] == v } }
        end
        
        finder.proc = Proc.new do |obj| 
          obj.load_attributes!
          procs.all? {|p| p.call(obj) } 
        end
        
        
        finder
      end
    end
    
  end
end
