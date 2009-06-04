module Rdb4o
  module Types
    
    class Fixnum
      def self.java_type
        "int" # Integer?
      end
      
      def self.dump(value)
        value.to_s.to_i
      end
    end
    
    Integer = Fixnum
    
    class Float
       def self.java_type 
         "float"
       end
       
       def self.dump(value)
         value.to_s.to_f
       end
    end
    
    class Boolean
       def self.java_type 
         "boolean"
       end

       def self.dump(value)
         !!value
       end
    end
    
    class String
       def self.java_type 
         "String"
       end

       def self.dump(value)
         value.to_s
       end
    end
    
    class Array
      class << self
        attr_accessor :type
        
        def with(type)
          c = Class.new(self)
          c.type = type
          c
        end      
        
        def java_type
          "#{Rdb4o::Type.java_type_for(type)}[]"
        end
        
        def load(value)
          value.to_a
        end
      
        def dump(value)
          if value
            jtype = type.java_type rescue type
            value.map do |e|
              e = Rdb4o::Type.dump(type, e)
              e.save if e.respond_to?(:save)
              e
            end.to_java(jtype)
          end
        end
      end
    end
    
  end
end