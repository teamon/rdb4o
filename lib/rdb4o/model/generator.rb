module Rdb4o
  module Model
    class Generator
      class << self
        attr_accessor :classes
        
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
            capital = name.to_s.capitalize
            fields << "  #{field.java_type} #{name};" 
            accessors << "  public void set#{capital}(#{field.java_type} #{name}) { this.#{name} = #{name}; }"
            accessors << "  public #{field.java_type} get#{capital}(#{field.java_type} #{name}) { return this.#{name}; }"
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
        
        
        # Generate all class files that include Rdb4o::Model
        #
        # :api: public
        def generate_all!
          classes.map {|c| generate!(c) }
        end
        
      end
    end
  end
end
  
#     class << self
#       attr_accessor :dir
#       
#       # def included(base)
#       #   base.extend(ClassMethods)
#       #   base.__generator_fields = {}
#       #   classes << base
#       # end
#     
#       # def classes
#       #   @@classes ||= []
#       # end
#       
#       def generate_all!        
#         load_all      
#         classes.each {|c| c.generate! }
#       end
#       
#       def compile_all!        
#         load_all
#         classes.each {|c| c.compile! }
#       end
#       
#       def java_dir
#         File.join(self.dir, "java")
#       end
#       
#       def package
#         java_dir.gsub("/", ".")
#       end
#     
#       def load_all
#         Dir["#{self.dir}/*.rb"].each do |file|
#           puts "Reading #{file}"
#           require file
#         end
#       end
#     end
#     
#     module ClassMethods
#       attr_accessor :__generator_fields
#       
#       def field(name, type, opts={})
#         # raise ArgumentError("Type must be a String") unless type.is_a?(String) # isnt that stupid?
#         __generator_fields[name] = {:type => type}.merge(opts)
#       end
#       
#       def generate!
#         fields = __generator_fields.map do |name, opts|
#           name = name.to_s
# <<-FIELD
#   private #{opts[:type]} _#{name};
#   public void set#{name.capitalize}(#{opts[:type]} #{name}) { this._#{name} = #{name}; }
#   public #{opts[:type]} get#{name.capitalize}() { return this._#{name}; }
# FIELD
#         end.join "\n"
# 
#         content = <<-CLASS_FILE
# package #{Rdb4o::ModelGenerator.package};
# 
# import com.rdb4o.Rdb4oModel;
# 
# public class #{self.name} extends Rdb4oModel {
# 
#   public #{self.name}() {
#       // Set all stirng empty and all integers to 0
#   }
#   
# #{fields}
#   
# }
# CLASS_FILE
#       
#         dir = Rdb4o::ModelGenerator.java_dir
#         Dir.mkdir(dir) unless File.exist?(dir)
#         File.open(File.join(dir, "#{self.name}.java"), "w") {|f| f.write(content) }
# 
#       end
#     
#       def compile!
#         java_file = File.join(Rdb4o::ModelGenerator.java_dir, "#{self.name}.java")
#         command = "javac -cp #{Rdb4o.jar_classpath}:. #{java_file}"
#         puts command
#         system(command)
#       end
#     end
#   end
# end