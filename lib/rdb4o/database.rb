module Rdb4o
  class Database
    Db4o = com.db4o.Db4o

    class << self
      DEFAULT_CONFIG = {:type => 'local', :port => 0, :login => '', :password => '', :name => :default}

      # List of created databases
      #
      # @api public
      def databases
        @databases ||= {}
      end


      # Select database
      #
      # ==== Parameters
      # name<Symbol>:: Namo of database
      #
      # @api public
      def [](name)
        databases[name]
      end


      # Preparing Object Container for a given databse
      #
      # ==== Parameters
      # config<Hash>:: Hash with a following possible keys:
      #   :type     - type of the databse can be remote or local options specific for remote type:
      #   :host     - if empty, use localhost
      #   :port     - can be 0 only for localhost
      #   :username - if omitted, no autentication is used
      #   :password
      #   :name     - if empty, use :default
      #
      # @api public
      # def setup_server(config)
      #    config = DEFAULT_CONFIG.merge(config)
      #    if config[:type].to_s == 'remote'
      #      puts "setting up server..."
              # Db4o.open_server(config[:dbfile], config[:port].to_i)
      #      databases[config[:name]] = Database.new(config)
      #      puts "done"
      #    else
      #      puts ":type must be set to :remote in odrder to start a server"
      #    end
      # end

      # Sets up the database.
      # Depending on the config it opens a dbfile or connects
      #
      # ==== Parameters
      # config<Hash>:: Hash with a following possible keys:
      #   :type     - type of the databse can be remote or local options specific for remote type:
      #   :host     - if empty, use localhost
      #   :port     - can be 0 only for localhost
      #   :user     - if omitted, no autentication is used
      #   :pass
      #   :name     - if empty, use :default
      #
      # TODO: error handling
      #
      # @api public
      def setup(config)
         config = DEFAULT_CONFIG.merge(config)
         db = Database.new(config)

         if config[:type].to_s == 'remote'
           db.client!
         else
           db.file!
         end

         databases[config[:name]] = db
         db
      end

      # Close the database.
      #
      # ==== Parameters
      # name<Symbol>:: Name of database
      #
      # @api public
      def close(name = :default)
        databases[name].close if databases[name]
      end
    end


    attr_accessor :config, :connection

    def initialize(config)
      @config = config
    end

    # Sets up the database as client
    #
    # @api private
    def client!
      @connection = Db4o.open_client('localhost', config[:port].to_i, config[:user], config[:pass])
    end

    # Sets up the file database
    #
    # @api private
    def file!
      raise ArgumentError.new(":dbfile not specified") unless config[:dbfile]
      @connection = Db4o.open_file config[:dbfile]
    end

    # Close database connection
    #
    # @api private
    def close
      @connection.close
    end


    def query(model = nil, conditions = {}, procs = [], order_fields = [], comparator = nil)
      Rdb4o.logger.debug "QUERY: #{model}  #{conditions.inspect}  #{procs.size}"

      if !order_fields.empty? && !comparator.nil?
        raise ArgumentError.new("You can`t specify both order_fields and order_proc")
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
        @connection.query Predicate.new(model, predicate), Comparator.new(comparator)
      else
        @connection.query Predicate.new(model, predicate)
      end
    end

    def store(object)
      Rdb4o.logger.debug "STORE: #{object}"
      @connection.set(object)
    end

    def delete(object)
      Rdb4o.logger.debug "DELETE: #{object}"
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
