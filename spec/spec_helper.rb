begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require File.dirname(__FILE__) + '/../lib/jrodb'

Jrodb.load_models(File.dirname(__FILE__))
Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each {|f| require f }

def reconnect_database
  Jrodb::Database.close rescue nil
  Jrodb::Database.setup(:dbfile => "test.db")
end

def with_reconnect
  yield
  reconnect_database
  yield
end

Spec::Runner.configure do |config|
  config.before(:all) do
  end

  config.after(:all) do
    Jrodb::Database.close rescue nil
    Dir["*.db"].each {|path| File.delete(path) }
  end
end
