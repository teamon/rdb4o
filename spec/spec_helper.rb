begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require File.dirname(__FILE__) + '/../lib/rdb4o'

def d(*attrs)
  attrs.each {|a| puts a.inspect }
end

Spec::Runner.configure do |config|  
  config.before(:all) do
    $CLASSPATH << File.dirname(__FILE__)
    Rdb4o::Tools.load_models "#{File.dirname(__FILE__)}/app/models/java"
  end
  
  config.after(:all) do
    Rdb4o::Database.close
    Dir["*.db"].each {|path| File.delete(path) }
  end
end

