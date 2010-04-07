module Jrodb
  module Model
    class Generator
      class << self

        # All registered classes
        #
        # @api private
        def classes
          @classes ||= []
        end


        # Generate class file
        #
        # ==== Parameters
        # klazz<Class>:: Class object
        # package<String>:: Java class package
        #
        # @api public
        def generate!(klazz, package = nil)
          fields, accessors = [], []

          klazz.fields.each_pair do |name, field|
            camel = name.to_s.camel_case
            fields << "  private #{field.java_type} #{name};"
            accessors << "  public void set#{camel}(#{field.java_type} #{name}) { this.#{name} = #{name}; }"
            accessors << "  public #{field.java_type} get#{camel}() { return this.#{name}; }"
          end

          package = "package #{package}.java;" if package

          java = <<-JAVA
#{package}

import com.jrodb.JrodbModel;

public class #{klazz} extends JrodbModel {
  public #{klazz}() {}

#{fields.join("\n")}

#{accessors.join("\n")}

#{klazz.enhancement}

}
          JAVA
        end

      end
    end
  end
end
