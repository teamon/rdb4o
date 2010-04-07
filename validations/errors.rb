# Copyright (c) 2007-2008 Sharon Rosner
# Copyright (c) 2008-2009 Jeremy Evans

module Jrodb
  module Model

    # This is taken from sequel
    class Errors < Hash
      ATTRIBUTE_JOINER = ' and '

      # Assign an array of messages for each attribute on access
      def initialize
        super{|h,k| h[k] = []}
      end

      # Adds an error for the given attribute.
      def add(att, msg)
        self[att] << msg
      end

      # Return the total number of error messages.
      def count
        values.inject(0){|m, v| m += v.length}
      end

      # Returns an array of fully-formatted error messages.
      def full_messages
        inject([]) do |m, kv|
          att, errors = *kv
          errors.each {|e| m << "#{Array(att).join(ATTRIBUTE_JOINER)} #{e}"}
          m
        end
      end

      # Returns the array of errors for the given attribute, or nil
      # if there are no errors for the attribute.
      def on(att)
        self[att] if include?(att)
      end
    end
  end
end
