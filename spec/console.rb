require File.dirname(__FILE__) + '/../lib/jrodb.rb'

Jrodb.load_models(File.dirname(__FILE__))
Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each {|f| require f }


Jrodb::Database::Db4o.configure.generateUUIDs(Java::JavaLang::Integer::MAX_VALUE)
Jrodb::Database::Db4o.configure.objectClass(Person).generateUUIDs(true);
Jrodb::Database.setup(:dbfile =>  "#{File.dirname(__FILE__)}/../console.db")
