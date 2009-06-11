module Rdb4o
  module Collection
    class OneToMany < Basic
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
        collection = self.dup
        collection.items = if proc
          self.items.select(&proc)
        elsif !conditions.empty?
          self.items.select {|e| conditions.all? {|key, value| e.send(key) == value } }
        else
          self.items
        end.to_a.each {|e| e.load_attributes! }

        collection
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
        model.create _new_attributes.merge(attrs)
      end


      # Delete object from collection
      #
      # :api: public
      def delete(object)
        @items.delete(object)
        object.attributes[@foreign_name] = nil
        object.save
        @parent.save
      end

      # Add object to collection and set it`s parent
      #
      # ==== Parameters
      # object<Object>::
      #
      # :api: public
      def <<(object)
        unless @items.include?(object)
          object.attributes[@foreign_name] = @parent
          object.save
        end
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
end
