module Rdb4o

  module Model
    class Field
      attr_accessor :name, :type, :options
      def initialize(name, type, opts ={})
        self.name, self.type, self.options = name, type, opts
      end
      
      def java_type
        type
      end
    end
    
    if jruby?
      
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
        alias :orig_new :new
        def new(proc, klazz = nil)
          finder = Finder.orig_new
          finder.proc = proc
          finder.klazz = klazz
          finder
        end
      end
    end
    
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      
      # Object attributes
      #
      # ==== Returns
      # Hash:: List of all attributes with values
      # :api: public
      def attributes
        @attributes ||= {}
      end
      
      
      # Update object attributes
      #
      # ==== Parameters
      # attrs<Hash>:: Hash of attributes that will apply to object
      #
      # ==== Returns
      # self
      #
      # :api: public
      def update(attrs)
        attrs.each_pair do |key, value|
          send(:"#{key}=", value) if respond_to?(:"#{key}=")
          # attributes[key] = value <- lets make use of virtual attributes too
        end
      end 
      
    end

    module ClassMethods
      
      # Add field to the model
      #
      # ==== Parameters
      # name<Symbol, String>:: Name of field
      # type<Rdb4o::Type>:: Type of field (see Types section)
      # opts<Hash>:: An options hash (for the future)
      #
      # :api: public
      def field(name, type, opts = {})
        fields[name] = Field.new(name, type, opts)
        
        class_eval <<-FIELD, __FILE__, __LINE__
          def #{name}
            attributes[:#{name}]
          end
          
          def #{name}=(value)
            attributes[:#{name}] = value
          end
        FIELD
      end
      
      # All fields
      #
      # ==== Returns
      # Hash:: List of all model fields
      #
      # :api: public
      def fields
        @fields ||= {}
      end
      
      
      # Create new object
      #
      # ==== Parameters
      # attrs<Hash>:: Hash of attributes that will apply to object
      #
      # ==== Returns
      # Instance of model
      #
      # :api: public
      def new(attrs = {})
        instance = super()
        instance.update(attrs)
        instance
      end
      
      
      
      

      # def has_many(name, opts = {})
      #   options = {
      #     :class_name => name.to_s.singular.capitalize,
      #     :key => Extlib::Inflection.demodulize(self).downcase
      #   }.merge(opts)
      # 
      #   class_eval <<-METHODS
      #     def #{name}
      #       #{options[:class_name]}.all(:#{options[:key]} => self)
      #     end
      #   METHODS
      # end
      
      



      # def create(attrs = {})
      #   instance = self.new(attrs)
      #   instance.save
      #   instance
      # end

      # Returns all models matching conditions hash *OR* proc
      # def all(conditions = {}, &proc)
      #   if proc
      #     self.database.query Finder.new(proc, self)
      #   elsif !conditions.empty?
      #     self.database.get(self.new conditions)
      #   else
      #     self.database.get(self.java_class)
      #   end.to_a
      # end

      # FIXME - this is LAME!
      # def count(conditions = {}, &proc)
      #   puts "I AM LAME COUNT METHOD PLEASE FIX ME"
      #   all(conditions, &proc).size
      # end

      # Destroys all objects
      # def destroy_all
      #   all.each {|o| o.destroy}
      # end

      # def get_by_db4o_id(id)
      #   obj = database.ext.getByID(id.to_i)
      #   # Activate depth should be configurable
      #   database.activate(obj, 5)
      #   obj
      # end

      # def get_by_uuid(uuid)
      #   database.ext.getByUUID(uuid)
      # end

      # Returns database connection
      # def database(name = :default)
      #   Rdb4o::Database[name]
      # end

    end

    # module InstanceMethods
      # include ValidationHelpers


      # Update object attributes
      # def update(attrs = {})
      #   attrs.each do |key, value|
      #     self.send("#{key}=", value)
      #   end
      # end

      # Returns false if object is stored in database, otherwize true
      # def new?
      #   # not sure..
      #   self.db4o_id == 0
      #   # or maby it should be
      #   # self.uuid.nil?
      # end

      # Saves object to database
      # def save(opts = {})
      #   return false if opts[:validate] != false && !valid?
      #   self.class.database.set(self)
      #   true
      # end

      # Deletes object form database
      # def destroy
      #   self.class.database.delete(self)
      # end

      # def db4o_id
      #   self.class.database.ext.getID(self)
      # end

      # def uuid
      #   obj_info = self.class.database.ext.getObjectInfo(self)
      #   obj_info && obj_info.getUUID
      # end

      # Returns the validation errors associated with this object.
      # def errors
      #   @errors ||= Errors.new
      # end

      # Validates the object.  If the object is invalid, errors should be added
      # to the errors attribute.  By default, does nothing, as all models
      # are valid by default.
      # def validate
      # end

      # Validates the object and returns true if no errors are reported.
      # def valid?
      #   errors.clear
      #   validate
      #   errors.empty?
      # end

    # end
  end

end
