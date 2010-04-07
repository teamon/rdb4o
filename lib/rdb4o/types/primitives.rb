module Jrodb
  module Types

    class Generic
      def self.accessors(name)
        <<-FIELD
          def #{name}
            attributes[:#{name}]
          end

          def #{name}=(value)
            attributes[:#{name}] = value
          end
        FIELD
      end

      def self.dump(value)
        value
      end

      def self.load(value)
        value
      end
    end

    class Fixnum < Generic
      def self.java_type
        "int" # Integer?
      end

      def self.dump(value)
        value.to_s.to_i
      end
    end

    Integer = Fixnum

    class Bignum < Integer
      def self.java_type
        "long"
      end
    end

    class Float < Generic
       def self.java_type
         "float"
       end

       def self.dump(value)
         value.to_s.to_f
       end
    end

    class Boolean < Generic
       def self.java_type
         "boolean"
       end

       def self.dump(value)
         !!value
       end

       def self.accessors(name)
         super + <<-FIELD
           def #{name}?
             !!attributes[:#{name}]
           end
         FIELD
       end
    end

    class String < Generic
       def self.java_type
         "String"
       end

       def self.dump(value)
         value.nil? ? nil : value.to_s
       end
    end

    class Array < Generic
      class << self
        attr_accessor :type

        def with(type)
          c = Class.new(self)
          c.type = type
          c
        end

        def java_type
          "#{Jrodb::Type.java_type_for(type)}[]"
        end

        def load(value)
          value.to_a
        end

        def dump(value)
          if value && type.respond_to?(:java_type)
            value.map do |e|
              e = Jrodb::Type.dump(type, e)
              # e.save if e.respond_to?(:save)
              e
            end.to_java(type.java_type)
          else
            value
          end
        end

      end
    end

  end
end
