module Rdb4o

  module Model

    def self.included(base) #:nodoc:
       base.extend(ClassMethods)
       base.send(:include, InstanceMethods)
    end

    class Finder < Java::com::rdb4o::RubyPredicate
      attr_accessor :proc
      def rubyMatch(obj)
        @proc.call obj
      end
    end

    module ClassMethods

      def new(attrs = {})
        instance = super()
        instance.update(attrs)
        instance
      end

      def create(attrs = {})
        instance = self.new(attrs)
        instance.save
        instance
      end

      # Returns all models matching conditions hash *OR* proc
      def all(conditions = {}, &proc)
        if proc
          finder = Finder.new
          finder.proc = proc
          result = self.database.query(finder)
        elsif !conditions.empty?
          object = self.new
          object.update(conditions)
          result = self.database.get(object)
        else
          result = self.database.get(self.java_class)
        end

        result.to_a
      end

      # FIXME - this is LAME!
      def count(conditions = {}, &proc)
        puts "I AM LAME COUNT METHOD PLEASE FIX ME"
        all(conditions, &proc).size
      end

      # Destroys all objects
      def destroy_all
        all.each {|o| o.destroy}
      end

      def get_by_db4o_id(id)
        obj = database.ext.getByID(id.to_i)
        # Activate depth should be configurable
        database.activate(obj, 5)
        obj
      end

      # Returns database connection
      def database(name = :default)
        Rdb4o::Database[name]
      end
    end

    module InstanceMethods
      include ValidationHelpers


      # Update object attributes
      def update(attrs = {})
        attrs.each do |key, value|
          self.send("#{key}=", value)
        end
      end

      # Returns false if object is stored in database, otherwize true
      def new?
        # not sure..
        self.db4o_id == 0
      end

      # Saves object to database
      def save(opts = {})
        return false if opts[:validate] != false && !valid?
        self.class.database.set(self)
        true
      end

      # Deletes object form database
      def destroy
        self.class.database.delete(self)
      end

      def db4o_id
        self.class.database.ext.getID(self)
      end

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

end
