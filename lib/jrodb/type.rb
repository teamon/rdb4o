module Jrodb
  # Type casting
  #
  # To prevent errors like:
  # class Foo
  #   include Jrodb::Model
  #
  #   field :num, Fixnum
  # end
  #
  # f = Foo.new
  # f.num = "4" # => type error

  class Type
    class << self

      # Type class for specified name
      #
      # ==== Parameters
      # type<Class,String>:: type name
      #
      # ==== Returns
      # Class,String
      #
      # If type class exist returns that class, otherwise returns type name
      #
      # @api public
      def for(type)
        if type.is_a?(Array)
          Jrodb::Types::Array.with(type.first)
        else
          type = Extlib::Inflection.demodulize(type.to_s)
          if Jrodb::Types.constants.include?(type)
            Jrodb::Types.const_get(type)
          else
            type
          end
        end
      end


      # Java type for specified type name
      #
      # ==== Parameters
      # type<Class,String>:: type name
      #
      # ==== Returns
      # String :: java type
      #
      # @api public
      def java_type_for(type)
        type = self.for(type)
        if type.respond_to?(:java_type)
          type.java_type
        else
          type
        end
      end


      # Class accessors for specified type
      #
      # ==== Parameters
      # type<Class,String>:: type name
      # name<String,Sybol>:: field name
      #
      # ==== Returns
      # String :: class accessors
      #
      # @api public
      def accessors_for(type, name)
        type = self.for(type)
        if type.respond_to?(:accessors)
          type.accessors(name)
        else
          Jrodb::Types::Generic.accessors(name)
        end
      end


      # Dumped value for specified type name
      #
      # ==== Parameters
      # type<Class,String>:: type name
      # value<anything>:: value
      #
      # ==== Returns
      # Dumped value
      #
      # @api public
      def dump(type, value)
        type = self.for(type)
        if type.respond_to?(:dump) && type.method(:dump).arity == 1
          type.dump(value)
        else
          value
        end
      end


      # Loaded value for specified type name
      #
      # ==== Parameters
      # type<Class,String>:: type name
      # value<anything>:: value
      #
      # ==== Returns
      # Loaded value
      #
      # @api public
      def load(type, value)
        type = self.for(type)
        if type.respond_to?(:load) && type.method(:load).arity == 1
          type.load(value)
        else
          value
        end
      end

    end
  end
end
