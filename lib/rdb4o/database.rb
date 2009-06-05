module Rdb4o
  class Database
    class << self
      DEFAULT_CONFIG = {:type => 'local', :port => 0, :login => '', :password => '', :name => :default}

      # List of created databases
      #
      # :api: public
      def databases
        @databases ||= {}
      end


      # Select database
      #
      # ==== Parameters
      # name<Symbol>:: Namo of database
      #
      # :api: public
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
      # :api: public
      def setup_server(config)
         config = DEFAULT_CONFIG.merge(config)
         if config[:type].to_s == 'remote'
           puts "setting up server..."
           raise ArgumentError.new(":dbfile not specified") unless config[:dbfile]
           databases[config[:name]] = Db4o.open_server(config[:dbfile], config[:port].to_i)
           databases[config[:name]].grant_access(config[:login], config[:password])
           puts "done"
         else
           puts ":type must be set to :remote in odrder to start a server"
         end
      end

      # Sets up the database.
      # Depending on the config it opens a dbfile or connects
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
      # TODO: error handling
      #
      # :api: public
      def setup(config)
         config = DEFAULT_CONFIG.merge config
         if config[:type].to_s == 'remote'
           databases[config[:name]] = Db4o.open_client('localhost', config[:port].to_i, config[:login], config[:password])
         else
           raise ArgumentError.new(":dbfile not specified") unless config[:dbfile]
           databases[config[:name]] = Db4o.open_file config[:dbfile]
         end
      end

      # Close the database.
      #
      # ==== Parameters
      # name<Symbol>:: Name of database
      #
      # :api: public
      def close(name = :default)
        databases[name].close if databases[name]
      end
    end

  end
end
