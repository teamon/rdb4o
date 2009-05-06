module Rdb4o
  module ModelGenerator
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def field(name, type, opts={})
        @@__generator_fields ||= {}
        raise ArgumentError("Type must be a String") unless type.is_a?(String)
        @@__generator_fields[name] = {:type => type}.merge(opts)
      end
      
      def generate!
        fields = @@__generator_fields.map do |name, opts|
          name = name.to_s
<<-FIELD
  private #{opts[:type]} _#{name};
  public void set#{name.capitalize}(#{opts[:type]} #{name}) { this._#{name} = #{name}; }
  public #{opts[:type]} get#{name.capitalize}() { return this._#{name}; }
FIELD
        end.join "\n"
        
        package = "com.foo"
        
<<-CLASS_FILE
package #{package};

import com.rdb4o.Rdb4oModel;

public class #{self} extends Rdb4oModel {

  public #{self}() {
      // Set all stirng empty and all integers to 0
  }
  
#{fields}
  
}
CLASS_FILE
      end
    end
  end
end