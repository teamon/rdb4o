require 'rubygems'
require 'rake/gempackagetask'

PLUGIN = "rdb4o"
GEM_NAME = "rdb4o"
GEM_VERSION = "0.0.2"
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
  s.executables = %w( rdb4o )
  s.files = %w( LICENSE README Rakefile TODO ) +  Dir["{bin,lib,spec}/**/*"]
  s.add_dependency('extlib', '>= 0.9')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end


dir = File.dirname(__FILE__)
ENV["CLASSPATH"] = "#{dir}/lib/java/db4o.jar:#{dir}/lib/java/rdb4o.jar:#{dir}/spec"

if ENV['file']
  files = "#{dir}/spec/#{ENV['file']}_spec.rb"
else
  files = Dir["#{dir}/spec/**/*_spec.rb"].join(" ")
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc 'Compile lib'
task :compile do
  Dir["#{dir}/lib/java/com/rdb4o/*.java"].each do |f|
    puts "Compiling #{f}"
    system "javac -cp #{dir}/lib/java/db4o.jar:#{dir}/lib/java #{f}"
  end
end

desc 'Make jar'
task :jar => :compile do
  Dir.chdir "#{dir}/lib/java"
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
    system "jruby -S spec -O spec/spec.opts #{files}"
  end
  
  desc "Generate and compile spec models"  
  task :gen do
    Dir.chdir(dir + "/spec")
    ENV["DEV"] = "true"
    system "../bin/rdb4o generate app/models"
    system "../bin/rdb4o compile app/models"
  end

  desc "Console"
  task :console do
    system "jruby -S irb -r #{dir}/spec/console.rb"
  end
  
  desc "rcov"
  task :rcov do
    system "jruby -S rcov #{files}"
  end
end


# development

desc 'Strip trailing whitespace from source files'
task :strip do
  Dir["#{dir}/**/*.rb"].each do |path|
    content = File.open(path, 'r') do |f|
      f.map { |line| line.gsub(/\G\s/, ' ').rstrip + "\n" }.join.rstrip
    end + "\n"
    
    if File.read(path) != content
      puts "Stripping whitepsace from #{path}"
      File.open(path, 'w') {|f| f.write content}
    end
  end
end


