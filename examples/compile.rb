require 'rubygems'

begin
  require 'rdb4o'
rescue LoadError => e
  raise LoadError.new "#{e.message}\nrun $ jruby -S rake jruby:install first" 
end

$CLASSPATH << File.dirname(__FILE__)


puts $CLASSPATH.inspect

puts Java::ComRdb4o::Rdb4oModel.inspect
puts Java::ModelsJava::Cat.inspect

Rdb4o::Tools.compile_and_load_models(File.dirname(__FILE__) + "/models/java")