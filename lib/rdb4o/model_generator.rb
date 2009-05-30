module Rdb4o
  module ModelGenerator
  
    class << self
      attr_accessor :dir
      
      def included(base)
        base.extend(ClassMethods)
        base.__generator_fields = {}
        classes << base
      end
    
      def classes
        @@classes ||= []
      end
      
      def generate_all!        
        load_all      
        classes.each {|c| c.generate! }
      end
      
      def compile_all!        
        load_all
        classes.each {|c| c.compile! }
      end
      
      def java_dir
        File.join(self.dir, "java")
      end
      
      def package
        java_dir.gsub("/", ".")
      end
    
      def load_all
        Dir["#{self.dir}/*.rb"].each do |file|
          puts "Reading #{file}"
          require file
        end
      end
    end
    
    module ClassMethods
      attr_accessor :__generator_fields
      
      def field(name, type, opts={})
        # raise ArgumentError("Type must be a String") unless type.is_a?(String) # isnt that stupid?
        __generator_fields[name] = {:type => type}.merge(opts)
      end
      
      def generate!
        fields = __generator_fields.map do |name, opts|
          name = name.to_s
<<-FIELD
  private #{opts[:type]} _#{name};
  public void set#{name.capitalize}(#{opts[:type]} #{name}) { this._#{name} = #{name}; }
  public #{opts[:type]} get#{name.capitalize}() { return this._#{name}; }
FIELD
        end.join "\n"

        content = <<-CLASS_FILE
package #{Rdb4o::ModelGenerator.package};

import com.rdb4o.Rdb4oModel;

public class #{self.name} extends Rdb4oModel {

  public #{self.name}() {
      // Set all stirng empty and all integers to 0
  }
  
#{fields}
  
}
CLASS_FILE
      
        dir = Rdb4o::ModelGenerator.java_dir
        Dir.mkdir(dir) unless File.exist?(dir)
        File.open(File.join(dir, "#{self.name}.java"), "w") {|f| f.write(content) }

      end
    
      def compile!
        java_file = File.join(Rdb4o::ModelGenerator.java_dir, "#{self.name}.java")
        command = "javac -cp #{Rdb4o.jar_classpath}:. #{java_file}"
        puts command
        system(command)
      end
    end
  end
end