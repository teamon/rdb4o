module Rdb4o
  module Collection
    class Basic < LazyArray
      attr_accessor :model, :conditions, :procs

      # Initialize collection with specified model class
      #
      # ==== Parameters
      # model<Class>:: Class representing database model
      #
      # ==== Examples
      # Collection.new(Fish)
      #
      # :api: public
      def initialize(model = nil, conditions = {}, procs = [])
        super()
        @model = model 
        @conditions = conditions
        @procs = procs
        
        load_with do |collection|
          Rdb4o.logger.debug "COLLECTION:LOAD"
          collection.clear!
          result = database.query(collection.model, collection.conditions, collection.procs)
          while result.has_next
            obj = result.next.load_attributes!
            collection << obj
          end
        end
        
      end
      
    
      # Returns all models matching conditions hash *OR* proc
      #
      # ==== Parameters
      # conditions<Hash>:: Hash of conditions that will filter the database
      # proc<Proc>:: Filter proc
      #
      # ==== Returns
      # Array :: Collection of objects
      #
      # ==== Examples
      # collection.all
      # collection.all(:name => "Stan")
      # collection.all {|e| e.age > 30 }
      #
      # :api: public
      def all(conditions = {}, &proc)
        procs = @procs.dup
        procs << proc if proc
        Rdb4o::Collection::Basic.new(@model, @conditions.merge!(conditions), procs)
      end


      # Destroy all objects in collection
      #
      # :api: public
      def destroy_all!
        until empty?
          pop.destroy
        end
      end


      # Create new @model object
      #
      # ==== Parameters
      # attrs<Hash>:: Hash of attributes that will apply to object
      #
      # ==== Returns
      # Instance of model
      #
      # :api: public
      def new(attrs = {})
        model.new default_attributes.merge(attrs)
      end


      # Create new @model object and save it
      #
      # ==== Parameters
      # attrs<Hash>:: Hash of attributes that will apply to object
      #
      # ==== Returns
      # Instance of model
      #
      # :api: public
      def create(attrs = {})
        instance = model.create default_attributes.merge(attrs)
        self << instance
        instance
      end
      
      protected

      # Attributes for new object
      #
      # ==== Returns
      # Hash :: attributes
      #
      # :api: private
      def default_attributes
        conditions
      end
          
      
      # Database object
      #
      # ==== Returns
      # Java::ComDb4oInternal::IoAdaptedObjectContainer
      #
      # :api: private
      def database
        Rdb4o::Database[:default]
      end
      
      
      # Try to use scope
      # TODO: some cache?
      #
      # :api: private
      def method_missing(method_name, *args, &proc)
        if scope = model.scopes[method_name]
          if scope.is_a?(Hash)
            all(scope)
          elsif scope.is_a?(Proc)
            all(&scope)
          end
        else
          super
        end
      end
      
      
      # Clear collection
      #
      # :api: private
      def clear!
        @head.clear
        @tail.clear
        clear
      end
      
    end
  end
end