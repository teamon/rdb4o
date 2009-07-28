module Rdb4o
  module Collection
    class Basic < LazyArray
      attr_accessor :model, :conditions, :procs, :order_fields, :comparator

      # Initialize collection with specified model class
      #
      # ==== Parameters
      # model<Class>:: Class representing database model
      #
      # ==== Examples
      # Collection.new(Fish)
      #
      # @api public
      def initialize(model = nil, conditions = {}, procs = [], order_fields = [], comparator = nil)
        super()
        @model = model
        @conditions = conditions
        @procs = procs
        @order_fields = order_fields
        @comparator = comparator

        load_with do |collection|
          Rdb4o.logger.debug "COLLECTION:LOAD"
          collection.clear!
          result = collection.result
          while result.has_next
            obj = result.next.load_attributes!
            collection.add(obj)
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
      # Rdb4o::Collection::Basic :: Collection of objects
      #
      # ==== Examples
      # collection.all
      # collection.all(:name => "Stan")
      # collection.all {|e| e.age > 30 }
      #
      # @api public
      def all(conditions = {}, &proc)
        procs = @procs.dup
        procs << proc if proc
        Rdb4o::Collection::Basic.new(@model, @conditions.merge!(conditions), procs)
      end

      def first(conditions = {}, &proc)
        all(conditions, &proc)[0]
      end

      # Returns models in order
      #
      # ==== Parameters
      # symbols or comparator proc
      #
      # ==== Returns
      # Rdb4o::Collection::Basic :: Collection of objects
      #
      # ==== Examples
      # Person.all.order(:name)
      # Person.all.order(:name, :age)
      # Person.all.order {|a,b| a.name <=> b.name }
      #
      # @api public
      def order(*fields, &comparator)
        fields = [] unless comparator.nil?
        Rdb4o::Collection::Basic.new(@model, @conditions, @procs, fields, comparator)
      end


      # Destroy all objects in collection
      #
      # @api public
      def destroy_all!
        each {|e| e.destroy }
        clear!
      end


      # Create new @model object
      #
      # ==== Parameters
      # attrs<Hash>:: Hash of attributes that will apply to object
      #
      # ==== Returns
      # Instance of model
      #
      # @api public
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
      # @api public
      def create(attrs = {})
        instance = model.create default_attributes.merge(attrs)
        self << instance
        mark_added
        instance
      end


      # Returns size of collection without loading objects
      #
      # ==== Returns
      # Size of collection
      #
      # @api public
      def size
        lazy_load if added?
        loaded? ? super : result.size
      end
      alias_method :count, :size



      protected

      # Attributes for new object
      #
      # ==== Returns
      # Hash :: attributes
      #
      # @api private
      def default_attributes
        conditions
      end


      # Database object
      #
      # ==== Returns
      # Java::ComDb4oInternal::IoAdaptedObjectContainer
      #
      # @api private
      def database
        Rdb4o::Database[:default]
      end


      # Try to use scope
      # TODO: some cache?
      #
      # @api private
      def method_missing(method_name, *args, &proc)
        if scope = model.scopes[method_name]
          result = all(scope[:conditions])
          result = result.all(&scope[:conditions_proc]) if scope[:conditions_proc]

          case scope[:order]
          when Array
            result = result.order(*scope[:order])
          when Proc
            result = result.order(&scope[:order])
          end

          result
        else
          super
        end
      end


      # db4o result set object
      #
      # @api private
      def result
        @result ||= database.query(@model, @conditions, @procs, @order_fields, @comparator)
      end


      # Clear collection
      #
      # @api private
      def clear!
        @head.clear if @head
        @tail.clear if @tail
        @result = nil
        clear
      end


      # Mark when new objects are added to collection
      #
      # @api private
      def mark_added
        @added = true
      end


      # Checks if there are new objects in collection
      #
      # @api private
      def added?
        @added == true
      end

    end
  end
end
