module Jrodb
  module Adapters
    class Base
      attr_accessor :connection
      
      # Sets up the database.
      # Opens database file
      #
      # ==== Parameters
      # filename<String>:: Database filename
      #
      # TODO: error handling
      #
      # @api public
      def initialize(filename)
        raise NotImplemented
      end

      # Close database connection
      #
      # @api private
      def close
        raise NotImplemented
      end
      
      # Query database
      #
      # @api private
      def query(model = nil, conditions = {}, procs = [], order_fields = [], comparator = nil)
        Jrodb.logger.debug "QUERY: #{model}  #{conditions.inspect}  #{procs.size}"

        if !order_fields.empty? && !comparator.nil?
          raise ArgumentError.new("You can`t specify both order_fields and comparator")
        end

        unless order_fields.empty?
          comparator = Proc.new do |a,b|
            a.load_attributes!
            b.load_attributes!

            order_fields.inject(0) do |result, operator|
              result = operator.result(a.send(operator.field) <=> b.send(operator.field))
              if result == 0
                result
              else
                break result
              end
            end
          end
        end

        # if procs.empty? && conditions.empty? && model.nil?
        #   raise ArgumentError.new("You must specify either model, conditions, or proc")
        # end

        unless conditions.empty?
          procs.push Proc.new {|obj| conditions.all? {|k, v| obj.attributes[k] == v } }
        end

        predicate = Proc.new do |obj|
          obj.load_attributes!
          procs.all? {|p| p.call(obj) }
        end

        unless comparator.nil?
          perform_query Predicate.new(model, predicate), Comparator.new(comparator)
        else
          perform_query Predicate.new(model, predicate)
        end
      end

      def perform_query(predicate = nil, comparator = nil)
        raise NotImplemented
      end

      def store(object)
        raise NotImplemented
      end

      def delete(object)
        raise NotImplemented
      end

      def id_for(object)
        raise NotImplemented
      end

      def get_by_id(id)
        raise NotImplemented
      end


    end

  end

end
