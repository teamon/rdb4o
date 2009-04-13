require File.dirname(__FILE__) + '/../lib/rdb4o.rb'
$CLASSPATH << File.dirname(__FILE__)
if ENV['compile']
  Rdb4o::Tools.compile_and_load_models "#{File.dirname(__FILE__)}/app/models/java"
else
  Rdb4o::Tools.load_models "#{File.dirname(__FILE__)}/app/models/java"
end

Rdb4o::Db4o.configure.reflectWith(com.rdb4o.RubyReflector.new)
# Rdb4o::Database.setup(:dbfile => "console.db")
