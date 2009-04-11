module Rdb4o
  module Model
    
    # Returns the validation errors associated with this object.
    def errors
      @errors ||= Errors.new
    end
    
    # Validates the object.  If the object is invalid, errors should be added
    # to the errors attribute.  By default, does nothing, as all models
    # are valid by default.
    def validate
    end

    # Validates the object and returns true if no errors are reported.
    def valid?
      errors.clear
      validate
      errors.empty?
    end
  end
end