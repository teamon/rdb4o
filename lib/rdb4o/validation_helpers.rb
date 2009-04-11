module Rdb4o
  module ValidationHelpers
    
    # Check that the attribute values are the given exact length.
    def validates_exact_length(exact, atts, opts={})
      validatable_attributes(atts, opts){|a,v,m| (m || "is not #{exact} characters") unless v && v.length == exact}
    end
    
    protected
    
    # Skip validating any attribute that matches one of the allow_* options.
    # Otherwise, yield the attribute, value, and passed option :message to
    # the block.  If the block returns anything except nil or false, add it as
    # an error message for that attributes.
    def validatable_attributes(atts, opts)
      am, an, ab, m = opts.values_at(:allow_missing, :allow_nil, :allow_blank, :message)
      Array(atts).each do |a|
        next if am && !values.has_key?(a)
        v = send(a)
        next if an && v.nil?
        next if ab && v.respond_to?(:blank?) && v.blank?
        if message = yield(a, v, m)
          errors.add(a, message)
        end
      end
    end
  end
end
  