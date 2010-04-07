begin
  require 'java/db4o.jar'
rescue LoadError
  begin
    require ENV['DB4O_JAR'].to_s
  rescue LoadError
    raise "Jrodb ERROR: Could not find db4objects library, put it in my lib/java dir, or try setting environment variable DB4O_JAR to db4objects jar location (You can get it at www.db4o.com)"
  end
end

require File.dirname(__FILE__) + "/base.rb"

module Jrodb
  module Adapters
    class Db4o < Base
      Db4o = com.db4o.Db4o
      
      def initialize(filename)
        raise ArgumentError.new(":dbfile not specified") unless config[:dbfile]
        @connection = Db4o.open_file config[:dbfile]
      end
      
      def close
        @connection.close
      end
      
      def perform_query(predicate = nil, comparator = nil)
        unless comparator.nil?
          @connection.query(predicate, comparator)
        else
          @connection.query(predicate)
        end
      end
      
      def store(object)
        Jrodb.logger.debug "STORE: #{object}"
        @connection.set(object)
      end

      def delete(object)
        Jrodb.logger.debug "DELETE: #{object}"
        @connection.delete(object)
      end

      def id_for(object)
        @connection.ext.getID(object)
      end

      def get_by_id(id)
        @connection.ext.getByID(id)
      end
    end
  end
end