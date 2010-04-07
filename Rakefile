require 'rubygems'
require 'rake/gempackagetask'

PLUGIN = "jrodb"
GEM_NAME = "jrodb"
GEM_VERSION = "0.2.0"
AUTHOR = "Kacper Cieśla, Tymon Tobolski"
EMAIL = "kacper.ciesla@gmail.com"
HOMEPAGE = "http://blog.teamon.eu/projekty/"
SUMMARY = "Small library for accessing db4o from jruby"

spec = Gem::Specification.new do |s|
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = 'jruby'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown", "LICENSE", "TODO"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE  
  s.require_path = 'lib'
  s.bindir = 'bin'
  s.executables = %w( jrodb )
  s.files = %w( LICENSE README.markdown Rakefile TODO ) +  Dir["{bin,lib,spec}/**/*"]
  s.add_dependency('extlib', '>= 0.9')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end


dir = File.dirname(__FILE__)
ENV["CLASSPATH"] = "#{dir}/lib/java/db4o.jar:#{dir}/lib/java/jrodb.jar:#{dir}/spec"

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
  Dir["#{dir}/lib/java/com/jrodb/*.java"].each do |f|
    puts "Compiling #{f}"
    system "javac -cp #{dir}/lib/java/db4o.jar:#{dir}/lib/java #{f}"
  end
end

desc 'Make jar'
task :jar => :compile do
  Dir.chdir "#{dir}/lib/java"
  system "jar -c com > jrodb.jar"
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
    system "../bin/jrodb generate app/models"
    system "../bin/jrodb compile app/models"
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

require "extlib"

def show_line(name, stats, color = nil)
  ce = color ? "\033[0m" : ""
  puts  "| #{color}#{name.to_s.capitalize.ljust(20)}#{ce} " + 
        "| #{color}#{stats[:lines].to_s.rjust(7)}#{ce} " +
        "| #{color}#{stats[:loc].to_s.rjust(7)}#{ce} " +
        "| #{color}#{stats[:classes].to_s.rjust(7)}#{ce} " +
        "| #{color}#{stats[:modules].to_s.rjust(7)}#{ce} " +
        "| #{color}#{stats[:methods].to_s.rjust(7)}#{ce} |"
  puts separator
end

def separator
  '+----------------------+---------+---------+---------+---------+---------+'
end

def check_dir(dir)
  Dir.foreach(dir) do |file_name|
    if File.stat(dir / file_name).directory? and (/^\./ !~ file_name)
      check_dir(dir / file_name)
    end

    if file_name =~ /.*\.(rb|feature)$/
      File.open(dir / file_name).each_line do |line|
        @stats[:lines]    += 1
        @stats[:loc]      += 1 unless line =~ /^\s*$/ || line =~ /^\s*#/
        @stats[:classes]  += 1 if line =~ /class [A-Z]/
        @stats[:modules]  += 1 if line =~ /module [A-Z]/
        @stats[:methods]  += 1 if line =~ /def [a-z]/
      end
    end
  end
end

desc "Lines of code statistics"
task :stats do
  STATISTICS_DIRS = {
    :controllers  => 'app/controllers',
    :helpers      => 'app/helpers',
    :models       => 'app/models',
    :lib          => 'lib',
    :spec         => 'spec',
    :test         => 'test',
    :features     => 'features'
  }.reject {|name, dir| !File.exist?(dir) }
  EMPTY_STATS = { :lines => 0, :loc => 0, :classes => 0, :modules => 0, :methods => 0 }
 
  @all = {}
  total = EMPTY_STATS.clone
  ce = "\033[0m"
  cb = "\033[35m"
  cg = "\033[4;32m"
  cr = "\033[31m"
 
  puts separator
  puts "| #{cg}Name#{ce}                 | #{cg}Lines#{ce}   | #{cg}LOC#{ce}     | #{cg}Classes#{ce} | #{cg}Modules#{ce} | #{cg}Methods#{ce} |"
  puts separator
 
  STATISTICS_DIRS.each_pair do |name, dir| 
    @stats = EMPTY_STATS.clone
    check_dir(dir)
    @all[name] = @stats
    show_line(name, @stats)
    @stats.each_pair { |type, count| total[type] += count }
  end
 
  show_line('Total', total, cr)
 
  code_loc = @all[:lib][:loc]
  
  test_loc = 0
  test_loc += @all[:spec][:loc] if @all[:spec]
  test_loc += @all[:test][:loc] if @all[:test]
  test_loc += @all[:features][:loc] if @all[:features]
 
  puts "   Code LOC: #{cb}#{code_loc}#{ce}     Test LOC: #{cb}#{test_loc}#{ce}     Code to test radio:  #{cb}1:%0.2f#{ce}" % (test_loc.to_f / code_loc.to_f)
  puts
end


