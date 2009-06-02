module Rdb4o
  module Types
    
    class Fixnum < Rdb4o::Type
      java_type "int" # Integer?
      
      def self.dump(value)
        value.to_s.to_i
      end
    end
    
    Integer = Fixnum
    
    class Float < Rdb4o::Type
       java_type "float"
       
       def self.dump(value)
         value.to_s.to_f
       end
    end
    
    class Boolean < Rdb4o::Type
       java_type "boolean"

       def self.dump(value)
         !!value
       end
    end
    
    class String < Rdb4o::Type
       java_type "String"

       def self.dump(value)
         value.to_s
       end
    end
    
  end
end