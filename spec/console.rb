require File.dirname(__FILE__) + '/../lib/rdb4o.rb'

Rdb4o.load_models(File.dirname(__FILE__))
Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each {|f| require f }


Rdb4o::Database::Db4o.configure.generateUUIDs(Java::JavaLang::Integer::MAX_VALUE)
Rdb4o::Database::Db4o.configure.objectClass(Person).generateUUIDs(true);
Rdb4o::Database.setup(:dbfile =>  "#{File.dirname(__FILE__)}/../console.db")
