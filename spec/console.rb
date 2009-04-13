require File.dirname(__FILE__) + '/../lib/rdb4o.rb'
$CLASSPATH << File.dirname(__FILE__)
if ENV['compile']
  Rdb4o::Tools.compile_and_load_models "#{File.dirname(__FILE__)}/app/models/java"
else
  Rdb4o::Tools.load_models "#{File.dirname(__FILE__)}/app/models/java"
end

class KickAssReflector < com.db4o.reflect.jdk.JdkReflector
  def initialize
    super(JRuby.runtime.getJRubyClassLoader)
  end
  
end

def track_class(klazz)
  methods = klazz.instance_methods
  methods.reject! {|e| e !~ /^[a-z]/}
  methods -= %w(send)
  methods.each do |meth|
    klazz.class_eval <<-OOO
    alias :orig_#{meth} :#{meth}
    def #{meth}(*args, &block)
      puts "\033[0;35m -> #{meth}\033[0m(#\{args.inspect\}, #\{block.inspect\})"
      send(:orig_#{meth}, *args, &block)
    end
    OOO
  end
end

track_class KickAssReflector

Rdb4o::Db4o.configure.reflectWith(KickAssReflector.new)
Rdb4o::Database.setup(:dbfile => "/tmp/console.db")

class Foo < java.lang.Object
  attr_accessor :baz, :bar
  
  def initialize(baz, bar)
    super()
    self.baz = baz
    self.bar = bar
  end
end
