module Rdb4o
  class OneToManyCollection < Collection
    attr_accessor :parent, :relation_name, :foreign_name

    # Initialize collection with specified parent
    #
    # ==== Parameters
    # parent<Object>:: Parent object of collection items
    # model<Class>:: Class representing database model
    # relation_name<Class>:: Name of 1->n relation
    # foreign_name<Class>:: Name of n->1 relation
    #
    # ==== Examples
    # OneToManyCollection.new(genius, Fish, :fishes, :owner)
    #
    # :api: public
    def initialize(parent, model, relation_name, foreign_name)
      @parent, @model, @relation_name, @foreign_name = parent, model, relation_name, foreign_name
      @items = @parent.attributes[@relation_name] ||= []
      @items.each {|i| i._load_attributes }
    end


    # Add object to collection and set it`s parent
    #
    # ==== Parameters
    # object<Object>::
    #
    # :api: public
    def <<(object)
      unless items.include?(object)
        items << object
        object.attributes[@foreign_name] = @parent
        @parent.save unless object.new?
      end
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
      instance
    end


    # Attributes for new object
    #
    # ==== Returns
    # Hash :: attributes
    #
    # :api: private
    def _new_attributes
      attrs = {}
      attrs[@foreign_name] = @parent
      attrs
    end
  end
end
