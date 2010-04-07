begin
  require 'java/neodatis.jar'
rescue LoadError
  begin
    require ENV['NEODATIS_JAR'].to_s
  rescue LoadError
    raise "Jrodb ERROR: Could not find db4objects library, put it in my lib/java dir, or try setting environment variable NEODATIS_JAR to neodatis jar location"
  end
end

require File.dirname(__FILE__) + "/base.rb"

module Jrodb
  module Adapters
    class Neodatis < Base
      ODB = org.neodatis.odb

      def initialize(filename)
        raise ArgumentError.new(":dbfile not specified") unless config[:dbfile]
        @connection = Neodatis::ODBFactory.open config[:dbfile]
        java.lang.Runtime.getRuntime.addShutdownHook(java.lang.Thread.new { 
          Jrodb::Adapters::Neodatis.close rescue nil
          puts "Database closed by ShutdownHook"
        })
        
        Jrodb.require_libs
      end
      
      def close
        @connection.close
      end
      
      def perform_query(predicate = nil, comparator = nil)
        unless comparator.nil?
          @connection.getObjects(predicate)
        else
          @connection.getObjects(predicate)
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
    end
  end
end