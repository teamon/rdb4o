module Rdb4o

  module Model
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:include, Rdb4o::Types)
      base.send(:include, Extlib::Hook)

      Generator.classes << base
    end


    # Hash with all models
    #
    # :api: private
    def self.type_map
      @type_map ||= {}
    end


    module ClassMethods
      include Relations

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


      # Create named scope matching conditions hash *OR* proc
      #
      # ==== Parameters
      # conditions<Hash>:: Hash of conditions that will filter the database
      # proc<Proc>:: Filter proc
      #
      # ==== Examples
      # Person.scope :stans, :name => "Stan"
      # Person.scope(:young) {|p| p.age < 18 }
      #
      # When using several scopes:
      # class Cat
      #   scope(:young) {|c| c.age <= 2}
      #   scope(:old) {|c| c.age > 4}
      #   scope :black, :color => "black"
      #   scope :white, :color => "white"
      # end
      #
      # Cat.white => {:color => "white"}
      # Cat.black => {:color => "black"}
      # Cat.white.black => {:color => "white"}.merge!(:color => "black") => {:color => "black"} # overwritten conditions!
      #
      # but
      #
      # Cat.young => Proc#1
      # Cat.old => Proc#2
      # Cat.old.young => Proc#1 + Proc#2
      #
      #
      # :api: public
      def scope(name, conditions = {}, &proc)
        if !conditions.empty?
          scopes[name] = conditions
        elsif proc
          scopes[name] = proc
        else
          raise ArgumentError.new("Please specify conditions or proc")
        end
      end


      # All scopes
      #
      # ==== Returns
      # Hash:: List of all model scopes
      #
      # :api: public
      def scopes
        @@scopes ||= {}
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
        instance.load_attributes!
        instance.update(attrs)
        instance
      end


      # Create new object and save it to database
      #
      # ==== Parameters
      # attrs<Hash>:: Hash of attributes that will apply to object
      #
      # ==== Returns
      # Instance of model
      #
      # :api: public
      def create(attrs = {})
        instance = self.new(attrs)
        instance.save
        instance
      end


      # Returns all models matching conditions hash and proc
      #
      # ==== Parameters
      # conditions<Hash>:: Hash of conditions that will filter the database
      # proc<Proc>:: Filter proc
      #
      # ==== Returns
      # Array :: Collection of objects
      #
      # ==== Examples
      # Person.all
      # Person.all(:name => "Stan")
      # Person.all {|p| p.age > 30 }
      #
      # :api: public
      def all(conditions = {}, &proc)
        collection.all(conditions, &proc)
      end


      # Destroy all objects
      #
      # :api: public
      def destroy_all!
        collection.destroy_all!
      end


      # Find object with db4o_id
      #
      # ==== Parameters
      # id<Fixnum>:: Object db4o id
      #
      # ==== Returns
      # Object with that id
      #
      # :api: public
      def get_by_db4o_id(id)
        obj = database.ext.getByID(id.to_i)
        # NOTE: Activate depth should be configurable
        database.connection.activate(obj, 5)
        obj.load_attributes!
      end


      # Java type
      #
      # ==== Returns
      # String
      #
      # :api: private
      def java_type
        Rdb4o::Model.type_map[self]
      end


      # Database connection
      #
      # ==== Returns
      # Java::ComDb4oInternal::IoAdaptedObjectContainer
      #
      # :api: private
      def database
        Rdb4o::Database[:default]
      end


      # Model class collection
      #
      # ==== Returns
      # Rdb4o::Collection
      #
      # :api: private
      def collection
        Rdb4o::Collection::Basic.new(self)
      end


      # Example model with dumped attributes for QueryByExample
      #
      # :api: private
      def example_for(conditions)
        new(conditions).dump_attributes!
      end


      # Pass not found methods to collection
      #
      # :api: private
      def method_missing(method_name, *args, &proc)
        collection.send(method_name, *args, &proc)
      end

    end

    module InstanceMethods

      # Object attributes
      #
      # ==== Returns
      # Hash:: List of all attributes with values
      #
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


      # Save object to database
      #
      # ==== Returns
      # true/false
      #
      # :api: public
      def save
        dump_attributes!
        # return false if opts[:validate] != false && !valid?
        self.class.database.store(self)
        true
      end


      # Delete object from database
      #
      # :api: public
      def destroy
        self.class.database.delete(self)
      end


      # Returns false if object is stored in database, otherwize true
      #
      # :api: public
      def new?
        # not sure..
        self.db4o_id == 0
        # or maby it should be
        # self.uuid.nil?
      end


      # Object`s db4o id
      #
      # ==== Returns
      # Fixnum :: db4o id
      #
      # :api: public
      def db4o_id
        self.class.database.ext.getID(self)
      end


      # Set java attributes with appropriate types
      #
      # :api: private
      def dump_attributes!
        self.class.fields.each_pair do |name, field|
          send(:"set_#{name}", field.dump(attributes[name])) if respond_to? :"set_#{name}"
        end
        self
      end


      # Load java attributes with appropriate types
      #
      # :api: private
      def load_attributes!
        self.class.fields.each_pair do |name, field|
          attributes[name] = field.load(send(:"get_#{name}")) if respond_to? :"get_#{name}"
        end
        self
      end
    end

  end
end






      # def get_by_uuid(uuid)
      #   database.ext.getByUUID(uuid)
      # end



    # end

    # module InstanceMethods
      # include ValidationHelpers


      # Update object attributes

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
#   end
#
# end
