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

    # Checks that there are no duplicate values in the database for the given
    # attributes.  Pass an array of fields instead of multiple
    # fields to specify that the combination of fields must be unique,
    # instead of that each field should have a unique value.
    #
    # This means that the code:
    #   validate_unique([:column1, :column2])
    # validates the grouping of column1 and column2 while
    #   validate_unique(:column1, :column2)
    # validates them separately.
    #
    # You should also add a unique index in the
    # database, as this suffers from a fairly obvious race condition.
    #
    # This validation does not respect the :allow_* options that the other validations accept,
    # since it can deals with multiple attributes at once.
    #
    # Possible Options:
    # * :message - The message to use (default: 'is already taken')
    def validate_unique(*atts)
      opts = (atts.pop if atts.last.is_a?(Hash)) || {}
      if atts.first.is_a?(Array) # ([:one, :two])
        message = opts[:message] || "#{atts.first.size==1 ? 'is' : 'are'} already taken"
        params = atts.first.inject({}) {|p,a| p[a] = self.send(a); p}
        # add something like params[:id] != self.id (maby via proc? or something)
        errors.add(atts, message) unless self.class.count(params) == 0
      else # (:one, :two)
        atts.each {|a| validate_unique([a], opts) }
      end
    end

    protected

    # Skip validating any attribute that matches one of the allow_* options.
    # Otherwise, yield the attribute, value, and passed option :message to
    # the block.  If the block returns anything except nil or false, add it as
    # an error message for that attributes.
    def validatable_attributes(atts, opts)
      allow_nil, allow_blank, message = opts.values_at(:allow_nil, :allow_blank, :message)
      Array(atts).each do |attr|
        value = send(attr)
        next if allow_nil && value.nil?
        next if allow_blank && value.respond_to?(:blank?) && value.blank?
        if msg = yield(attr, value, message)
          errors.add(attr, msg)
        end
      end
    end
  end
end
