require File.dirname(__FILE__) + '/../lib/rdb4o.rb'

# Dir.chdir("spec")
Rdb4o.load_models

Dir["app/models/*.rb"].each {|f| require f }


# Rdb4o::Db4o.configure.generateUUIDs(Java::JavaLang::Integer::MAX_VALUE)
# Rdb4o::Db4o.configure.objectClass(Person).generateUUIDs(true);
Rdb4o::Database.setup(:dbfile => "console.db")
# 
# class Person
#   has_many :cats
# end
