module Rdb4o
  module ValidationHelpers
    
    # Check that the attribute values are the given exact length.
    def validate_exact_length(exact, atts, opts={})
      validatable_attributes(atts, opts) do |attr, value, message| 
        (message || "is not #{exact} characters") unless value && value.length == exact
      end
    end
    
    # Check the string representation of the attribute value(s) against the regular expression pattern.
    def validate_format(pattern, atts, opts={})
      validatable_attributes(atts, opts) do |attr, value, message|
        (message || 'is invalid') unless value.to_s =~ pattern
      end
    end
    
    # Check attribute value(s) is included in the given set.
    def validate_includes(set, atts, opts={})
      validatable_attributes(atts, opts) do |attr, value, message| 
        (message || "is not in range or set: #{set.inspect}") unless set.include?(value)
      end
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
  