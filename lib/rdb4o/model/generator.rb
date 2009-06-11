module Rdb4o
  module Model
    class Generator
      class << self
        def classes
          @classes ||= []
        end

        # Generate class file
        #
        # ==== Parameters
        # klazz<Class>:: Class object
        # package<String>:: Java class package
        #
        # :api: public
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

import com.rdb4o.Rdb4oModel;

public class #{klazz} extends Rdb4oModel {
  public #{klazz}() {}

#{fields.join("\n")}

#{accessors.join("\n")}

}
          JAVA
        end


        # May not be usefull at al
        # # Generate all class files that include Rdb4o::Model
        # #
        # # :api: public
        # def generate_all!
        #   classes.map {|c| generate!(c) }
        # end

      end
    end
  end
end
