# This is mostly port of sequel validation helpers

module Rdb4o
  module ValidationHelpers
    
    # Check that the attribute values are the given exact length or in the specified range.
    def validate_length(range, atts, opts={})
      
      if range.is_a?(Range)
        msg = "must be between #{range.first} and #{range.last} characters"
      else
        msg = "is not #{range} characters"
        range = (range..range)
      end
      validatable_attributes(atts, opts) do |attr, value, message|
        (message || msg) unless value && range.include?(value.length)
      end
    end
    
    # Check that the attribute values are not longer than the given max length.
    def validate_max_length(max, atts, opts={})
      validatable_attributes(atts, opts) do |attr, value, message|
        (message || "is longer than #{max} characters") unless value && value.length <= max
      end
    end

    # Check that the attribute values are not shorter than the given min length.
    def validate_min_length(min, atts, opts={})
      validatable_attributes(atts, opts) do |attr, value, message|
        (message || "is shorter than #{min} characters") unless value && value.length >= min
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
    
    # Check attribute value(s) is not considered blank by the database, but allow false values.
    def validate_presence(atts, opts={})
      validatable_attributes(atts, opts) do |attr, value, message|
        (message || "is not present") if value.blank?
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
  