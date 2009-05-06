module Rdb4o
  module ModelGenerator
    def self.included(base)
      base.extend(ClassMethods)
      @@classes ||= []
      @@classes << base
    end
    
    def self.classes
      @@classes
    end
    
    def self.package
      @@package
    end
    
    def self.package=(pkg)
      @@package = pkg
    end
    
    # def self.generate!
    #   @@classes.map {|c| c.generate! }
    # end
    
    module ClassMethods
      
      def field(name, type, opts={})
        @@__generator_fields ||= {}
        raise ArgumentError("Type must be a String") unless type.is_a?(String)
        @@__generator_fields[name] = {:type => type}.merge(opts)
      end
      
      def generate!(dir)
        java_dir = File.join(dir, "java")
        package = java_dir.gsub(/\//, ".")
                
        fields = @@__generator_fields.map do |name, opts|
          name = name.to_s
<<-FIELD
  private #{opts[:type]} _#{name};
  public void set#{name.capitalize}(#{opts[:type]} #{name}) { this._#{name} = #{name}; }
  public #{opts[:type]} get#{name.capitalize}() { return this._#{name}; }
FIELD
        end.join "\n"

        content = <<-CLASS_FILE
package #{package};

import com.rdb4o.Rdb4oModel;

public class #{self.name} extends Rdb4oModel {

  public #{self.name}() {
      // Set all stirng empty and all integers to 0
  }
  
#{fields}
  
}
CLASS_FILE

      Dir.mkdir(java_dir) unless File.exist?(java_dir)
      File.open(File.join(java_dir, "#{self.name}.java"), "w") {|f|
        f.write(content)
      }

      end
    end
  end
end