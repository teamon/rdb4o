module Rdb4o
  module Model
    module Relations
      # "Belongs to" relation
      #
      # ==== Parameters
      # name<Symbol>:: name of relation
      # options<Hash>:: options:
      #   :class - relation class
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
        type = options.delete(:class) || name.to_s.capitalize
        
        field(name, type, options)
      end
      
      # fields[name] = Field.new(name, type, opts)
      # 
      # def field(name, type, opts = {})
      #   fields[name] = Field.new(name, type, opts)
      #   
      #   class_eval <<-FIELD, __FILE__, __LINE__
      #     def #{name}
      #       attributes[:#{name}]
      #     end
      #     
      #     def #{name}=(value)
      #       attributes[:#{name}] = value
      #     end
      #   FIELD
      # end
      
      # "Has many" relation
      #
      # ==== Parameters
      # name<Symbol>:: name of relation
      # options<Hash>:: options:
      #   :class - relation class
      #
      # ==== Examples
      # Person.has_many :cats
      # Person.has_many :kitties, :class => Cat
      # 
      # person = Person.new
      # person.cats
      #
      # :api: public
      def has_many(name, options = {})
        
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
