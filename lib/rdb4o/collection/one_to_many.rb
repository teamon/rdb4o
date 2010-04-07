module Jrodb
  module Collection
    class OneToMany < Basic
      attr_accessor :parent, :relation_name, :foreign_key

      # Initialize collection with specified parent
      #
      # ==== Parameters
      # parent<Object>:: Parent object of collection items
      # model<Class>:: Class representing database model
      # relation_name<Class>:: Name of 1->n relation
      # foreign_name<Class>:: Name of n->1 relation
      #
      # ==== Examples
      # OneToManyCollection.new(person, Cat, :cats, :owner)
      #
      # @api public
      def initialize(parent, model, relation_name, foreign_key)
        super(model)
        @parent, @relation_name, @foreign_key = parent, relation_name, foreign_key
        conditions.merge!(@foreign_key => @parent)
      end

      # Destroy object from collection - set parent to nil
      #
      # @api public
      def delete(object)
        object.send(:"#{@foreign_key}=", nil)
        object.save
        super
      end


      # Add object to collection and set it`s parent
      #
      # ==== Parameters
      # object<Object>::
      #
      # @api public
      def <<(object)
        unless include?(object)
          object.send(:"#{@foreign_key}=", @parent)
          object.save
          super
        end
      end

    end
  end
end
