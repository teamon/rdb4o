require 'rubygems'
require 'rake/gempackagetask'

PLUGIN = "rdb4o"
GEM_NAME = "rdb4o"
GEM_VERSION = "0.0.1"
AUTHOR = "Kacper Cieśla, Tymon Tobolski"
EMAIL = "kacper.ciesla@gmail.com"
HOMEPAGE = "http://blog.teamon.eu/projekty/"
SUMMARY = "Small library for accessing db4o from jruby"

spec = Gem::Specification.new do |s|
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = 'jruby'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE  
  s.require_path = 'lib'
  s.bindir = 'bin'
  s.executables = %w( compile_models )
  s.files = %w( LICENSE README Rakefile TODO ) +  Dir["{bin,lib,spec}/**/*"]
  s.add_dependency('extlib', '>= 0.9')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc 'Compile lib'
task :compile do
  dir = File.dirname(__FILE__)
  Dir["#{dir}/lib/java/com/rdb4o/*.java"].each do |f|
    puts "Compiling #{f}"
    system "javac -cp #{dir}/lib/java/db4o.jar:#{dir}/lib/java #{f}"
  end
end

desc 'Make jar'
task :jar => :compile do
  Dir.chdir "#{File.dirname(__FILE__)}/lib/java"
  system "jar -c com > rdb4o.jar"
  puts "JAR file created"
end

desc "Run :package and install the resulting .gem with jruby"
task :install => :package do
  system "jruby -S gem install pkg/#{GEM_NAME}-#{GEM_VERSION}-java.gem --no-rdoc --no-ri"
end


namespace :spec do
  desc "Run specs"
  task :run do
    dir = File.dirname(__FILE__)
    
    if ENV['file']
      specs = "#{dir}/spec/#{ENV['file']}_spec.rb"
    else
      specs = Dir["#{dir}/spec/**/*_spec.rb"].join(" ")
    end

    c = "CLASSPATH=#{dir}/lib/java/db4o.jar:#{dir}/lib/java/rdb4o.jar:#{dir}/spec jruby -S spec -O spec/spec.opts #{specs}"
    puts c
  end
  
  desc "Generate spec models"  
  task :generate do
    require File.dirname(__FILE__) + "/lib/rdb4o"
    Dir.chdir(File.dirname(__FILE__) + "/spec")
    Rdb4o::ModelGenerator.dir = "app/models"
    Rdb4o::ModelGenerator.generate_all!
  end

  desc "Compile spec models"
  task :compile do
    require File.dirname(__FILE__) + "/lib/rdb4o"
    Dir.chdir(File.dirname(__FILE__) + "/spec")
    Rdb4o::ModelGenerator.dir = "app/models"
    Rdb4o::ModelGenerator.compile_all!
  end

  desc "Console"
  task :console do
    dir = File.dirname(__FILE__)
    system "CLASSPATH='#{dir}/lib/java/db4o.jar:#{dir}/lib/java/rdb4o.jar:#{dir}/spec' jruby -S irb -r #{dir}/spec/console.rb"
  end
end


# development

desc 'Strip trailing whitespace from source files'
task :strip do
  Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |path|
    content = File.open(path, 'r') do |f|
      f.map { |line| line.gsub(/\G\s/, ' ').rstrip + "\n" }.join.rstrip
    end + "\n"
    
    if File.read(path) != content
      puts "Stripping whitepsace from #{path}"
      File.open(path, 'w') {|f| f.write content}
    end
  end
end


