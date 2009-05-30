$: << File.dirname(__FILE__)

include Java

begin
  require 'java/db4o.jar'
rescue LoadError
  begin
    require ENV['DB4O_JAR'].to_s
  rescue LoadError
    raise "Rdb4o ERROR: Could not find db4objects library, put it in my lib/java dir, or try setting environment variable DB4O_JAR to db4objects jar location (You can get it at www.db4o.com)"
  end
end

require 'extlib'
require 'java/rdb4o.jar'

# Rdb4o

def x(msg)
  STDOUT.puts "\033[0;35m%s\033[0m" % msg
end

def i(obj)
  STDOUT.puts "\033[0;36m%s\033[0m" % obj.inspect
end


module Rdb4o
  Db4o = com.db4o.Db4o

  # # Includes Rdb4o::Base module into given class
  # def self.set_model(some_class)
  #  some_class = Object.const_get(some_class) if some_class.class == 'String'
  #  some_class.send(:include, Rdb4o::Model)
  # end
  # this is not needed now
  
  def self.jar_classpath
    File.join(File.dirname(File.expand_path(__FILE__)), "java")
  end
  
  def self.load_models(dir = ".")
    Dir["#{dir}/**/*.class"].each do |class_file|
      class_name = File.basename(class_file).sub('.class', '')
      package = File.dirname(class_file).gsub("#{dir}/", "").gsub("/", ".")
      model_class = eval("Java.#{package}.#{class_name}")
      Object.const_set(class_name, model_class)
      # Rdb4o.set_model(model_class)
    end
  end

end

require 'rdb4o/database'
require 'rdb4o/errors'
require 'rdb4o/validation_helpers'
require 'rdb4o/model'
require 'rdb4o/model_generator'
