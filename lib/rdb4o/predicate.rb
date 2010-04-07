module Jrodb
  class Predicate < Java::com::jrodb::RubyPredicate
    attr_accessor :proc, :model

    def rubyMatch(obj)
      if model.nil? || obj.is_a?(model)
        !!@proc.call(obj) # make sure we pass boolean
      else
        false
      end
    end

    def self.new(model, proc)
      predicate = super()
      predicate.model = model
      predicate.proc = proc
      predicate
    end

  end
end
