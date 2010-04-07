module Jrodb
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
      # @api public
      def belongs_to(name, options = {})
        type = options.delete(:class) || Object.const_get(name.to_s.capitalize) rescue name.to_s.capitalize
        field(name, type, options)
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
      # Person.has_many :kitties, :class => Cat, :key => :owner
      #
      # person = Person.new
      # person.cats
      #
      # @api public
      def has_many(name, options = {})
        type = options.delete(:class) || Object.const_get(name.to_s.singularize.comel_case) rescue name.to_s.singularize.camel_case
        options[:key] ||= Extlib::Inflection.demodulize(self.to_s).downcase.to_sym

        class_eval <<-FIELD, __FILE__, __LINE__
          def #{name}
            Jrodb::Collection::OneToMany.new(self, #{type}, :#{name}, :#{options[:key]})
          end
        FIELD
      end
    end
  end
end
