module Rdb4o
  # Type casting
  #
  # To prevent errors like:
  # class Foo
  #   include Rdb4o::Model
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
      # :api: public
      def for(type)
        if type.is_a?(Array)
          Rdb4o::Types::Array.with(type.first)
        else
          type = Extlib::Inflection.demodulize(type.to_s)
          if Rdb4o::Types.constants.include?(type)
            Rdb4o::Types.const_get(type)
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
      # :api: public
      def java_type_for(type)
        type = self.for(type)
        if type.respond_to?(:java_type)
          type.java_type
        else
          type
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
      # :api: public
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
      # :api: public
      def load(type, value)
        type = self.for(type)
        if type.respond_to?(:load) && type.method(:dump).arity == 1
          type.load(value)
        else
          value
        end
      end
        
    end
  end
end
