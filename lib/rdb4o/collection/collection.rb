module Rdb4o
  class Collection
    attr_accessor :model, :items

    # Initialize collection with specified model class
    #
    # ==== Parameters
    # model<Class>:: Class representing database model
    #
    # ==== Examples
    # Collection.new(Fish)
    #
    # :api: public
    def initialize(model)
      self.model = model
      self.items = []
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
      self.items = if proc
        model._database.query Finder.new(proc, model)
      elsif !conditions.empty?
        match = model.new(conditions)
        match._dump_attributes
        model._database.get(match)
      else
        model._database.get(model.java_class)
      end.to_a.each {|e| e._load_attributes }

      self
    end


    # Destroy all objects in collection
    #
    # :api: public
    def destroy_all!
      each {|o| o.destroy}
      all
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
      model.new _new_attributes.merge(attrs)
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
      instance = model.create _new_attributes.merge(attrs)
      self << instance
      instance
    end


    # Attributes for new object
    #
    # ==== Returns
    # Hash :: attributes
    #
    # :api: private
    def _new_attributes
      {}
    end


    # Pass all undefined methods into set
    #
    # :api: private
    def method_missing(method, *args, &proc)
      # x "method passing to items: #{method}(#{args.inspect}, #{proc.inspect})"
      items.send(method, *args, &proc)
    end
  end
end
