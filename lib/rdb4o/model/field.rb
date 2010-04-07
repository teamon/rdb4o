module Jrodb
  module Model
    class Field
      attr_accessor :name, :type, :options
      def initialize(name, type, opts ={})
        self.name, self.type, self.options = name, type, opts
      end

      # Java type for field`s type
      #
      # ==== Returns
      # String :: java type
      #
      # @api public
      def java_type
        Jrodb::Type.java_type_for(type)
      end


      # Dumped value for field`s type
      #
      # ==== Parameters
      # value<anything>:: value
      #
      # ==== Returns
      # Dumped value
      #
      # @api public
      def dump(value)
        Jrodb::Type.dump(type, value)
      end


      # Loaded value for field`s type
      #
      # ==== Parameters
      # value<anything>:: value
      #
      # ==== Returns
      # Loaded value
      #
      # @api public
      def load(value)
        Jrodb::Type.load(type, value)
      end

      # Generate accessors
      def add_accessors(klazz)
        klazz.class_eval Jrodb::Type.accessors_for(type, name)
      end

    end
  end
end
