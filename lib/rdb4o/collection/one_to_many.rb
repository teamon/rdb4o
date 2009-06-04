module Rdb4o
  class OneToManyCollection < Collection
    attr_accessor :parent, :relation_name
    
    # Initialize collection with specified parent
    #
    # ==== Parameters
    # parent<Object>:: Parent object of collection items
    # model<Class>:: Class representing database model
    # relation_name<Class>:: Class representing database model
    #
    # ==== Examples
    # OneToManyCollection.new(genius, Fish, :fishes)
    #     
    # :api: public
    def initialize(parent, model, relation_name)
      self.parent, self.model, self.relation_name = parent, model, relation_name
    end
  end
end