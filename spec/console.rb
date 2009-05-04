require File.dirname(__FILE__) + '/../lib/rdb4o.rb'
$CLASSPATH << File.dirname(__FILE__)
if ENV['compile']
  Rdb4o::Tools.compile_and_load_models "#{File.dirname(__FILE__)}/app/models/java"
else
  Rdb4o::Tools.load_models "#{File.dirname(__FILE__)}/app/models/java"
end


class RubyReflector
end



def track_class(klazz, color = 35)
  methods = klazz.instance_methods
  methods.reject! {|e| e !~ /^[a-z]/}
  methods -= %w(send)
  methods.each do |meth|
    klazz.class_eval <<-OOO
    alias :orig_#{meth} :#{meth}
    def #{meth}(*args, &block)
      puts "\033[0;#{color}m -> #{meth}\033[0m(#\{args.inspect\}, #\{block.inspect\})"
      send(:orig_#{meth}, *args, &block)
    end
    OOO
  end
end
# track_class RubyReflector
# track_class Java::ComDb4oReflectJdk::JdkReflector, 33


Rdb4o::Db4o.configure.reflectWith(RubyReflector.new(JRuby.runtime.getJRubyClassLoader))
Rdb4o::Database.setup(:dbfile => "/tmp/console.db")

class Foo
  attr_accessor :baz, :bar
  
  def initialize
    # super()
    # self.baz = baz
    # self.bar = bar
  end
end

track_class Foo, 36
track_class Person, 36

# Person.new.save

