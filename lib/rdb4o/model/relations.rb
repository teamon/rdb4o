module Rdb4o
  module Model
    module Relations
      # "Belongs to" relation
      #
      # ==== Parameters
      # name<Symbol>:: name of relation
      # options<Hash>:: options:
      #   :class - relation class
      #   :foreign_name - name of 1->n relation
      #
      # ==== Examples
      # Cat.belongs_to :person
      # Cat.belongs_to :owner, :class => Person
      #
      # kitty = Cat.new
      # kitty.person
      #
      # :api: public
      def belongs_to(name, options = {})
        type = options.delete(:class) || Object.const_get(name.to_s.capitalize) rescue name.to_s.capitalize
        options[:foreign_name] ||= Extlib::Inflection.demodulize(self.to_s).downcase.pluralize.to_sym
        fields[name] = Field.new(name, type, options)

        class_eval <<-FIELD, __FILE__, __LINE__
          def #{name}
            attributes[:#{name}]
          end

          def #{name}=(value)
            attributes[:#{name}] = value
          end

          after :save do
            if attributes[:#{name}]
              attributes[:#{name}].#{options[:foreign_name]}.items << self
              attributes[:#{name}].save
            end
          end

          before :destroy do
            if attributes[:#{name}]
              attributes[:#{name}].#{options[:foreign_name]}.delete(self)
            end
          end
        FIELD
      end

      # "Has many" relation
      #
      # ==== Parameters
      # name<Symbol>:: name of relation
      # options<Hash>:: options:
      #   :class        - relation class
      #   :foreign_name - name of n->1 relation
      #
      # ==== Examples
      # Person.has_many :cats
      # Person.has_many :kitties, :class => Cat
      # Person.has_many :kitties, :class => Cat, :foreign_name => :owner
      #
      # person = Person.new
      # person.cats
      #
      # :api: public
      def has_many(name, options = {})
        type = options.delete(:class) || Object.const_get(name.to_s.singularize.capitalize) rescue name.to_s.singularize.capitalize
        options[:foreign_name] ||= Extlib::Inflection.demodulize(self.to_s).downcase.to_sym
        fields[name] = Field.new(name, [type], options)

        class_eval <<-FIELD, __FILE__, __LINE__
          def #{name}
            @__#{name}_collection ||= Rdb4o::OneToManyCollection.new(self, #{type}, :#{name}, :#{options[:foreign_name]})
          end

          before :save do
            if @__#{name}_collection
              attributes[:#{name}] = @__#{name}_collection.items
            end
          end

          before :destroy do
            if @__#{name}_collection
              @__#{name}_collection.items.each {|e|
                e.attributes[:#{options[:foreign_name]}] = nil
                e.save
              }
            end
          end
        FIELD
      end
    end
  end
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
