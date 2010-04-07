require File.dirname(__FILE__) + '/../lib/jrodb.rb'
# Jrodb.setup(:neodatis, "console.db")

require File.dirname(__FILE__) + '/../lib/jrodb/adapters/neodatis'

# Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each {|f| Jrodb.load_file(f) }


# Jrodb::Database::Db4o.configure.generateUUIDs(Java::JavaLang::Integer::MAX_VALUE)
# Jrodb::Database::Db4o.configure.objectClass(Person).generateUUIDs(true);
# Jrodb::Adapter::Noedatis.setup("#{File.dirname(__FILE__)}/../console.db")
