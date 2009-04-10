require 'rubygems'

begin
  require 'rdb4o'
rescue LoadError => e
  raise LoadError.new "#{e.message}\nrun $ jruby -S rake jruby:install first" 
end

$CLASSPATH << File.dirname(__FILE__)

Rdb4o::Tools.compile_and_load_models(File.dirname(__FILE__) + "/models/java")

Rdb4o::Database.setup :dbfile => 'example.db'
puts Cat.all.map{|o| o.name}