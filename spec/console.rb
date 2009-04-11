require File.dirname(__FILE__) + '/../lib/rdb4o.rb'
$CLASSPATH << File.dirname(__FILE__)
Rdb4o::Tools.load_models "#{File.dirname(__FILE__)}/app/models/java"
