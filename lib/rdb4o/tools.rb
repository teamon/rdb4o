module Rdb4o
  module Tools
    # To let others know where to find Rdb4oBase.class
    def self.base_classpath
      "#{File.dirname(File.expand_path(__FILE__))}/../java"
    end
    
    def self.compile_models(path)
      class_files = []
      puts "Looking for .java files in #{path}"
      Dir.glob("#{path}/*.java").each do |class_file|
        class_name = class_file.split('/')[-1].split('.')[0]
        puts "compiling #{class_name}..."
        #puts "  #{command}"
        class_files << class_file
      end
      
      unless class_files.empty?      
        command = "javac -cp #{base_classpath} #{class_files.join(' ')}"
        puts command
        puts `#{command}`
        puts "DONE"
      else
        puts "No .java files found"
      end
    end
    
    def self.load_models(path)
      Dir.glob("#{path}/*.java").each do |class_file|
        if File.exists? "#{class_file.split('.')[0]}.class"
          package = File.read(class_file).match(/package +([a-zA-Z0-9.]+) *;/)[1] # .gsub(".", "::");
          class_name = class_file.split('/')[-1].split('.')[0]
          # FIXME: EVAL = EVIL !!!
          # should be some const_get
          puts "Java::#{package}::#{class_name}".inspect
          puts eval("Java::#{package}::#{class_name}").inspect
          model_class = eval("Java::#{package}::#{class_name}")
          Object.const_set(class_name, model_class)
          Rdb4o.set_model(model_class)
        end
      end
    end
    
    def self.compile_and_load_models(path)
      compile_models(path)
      load_models(path)
    end
  end
end