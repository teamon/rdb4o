begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require File.dirname(__FILE__) + '/../lib/rdb4o'

Rdb4o.load_models(File.dirname(__FILE__))
Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each {|f| require f }

Spec::Runner.configure do |config|
  config.before(:all) do
  end

  config.after(:all) do
    Rdb4o::Database.close
    Dir["*.db"].each {|path| File.delete(path) }
  end
end
