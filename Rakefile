require 'rubygems'
require 'rake/gempackagetask'

PLUGIN = "rdb4o"
GEM_NAME = "rdb4o"
GEM_VERSION = "0.0.1"
AUTHOR = "Kacper Cieśla, Tymon Tobolski"
EMAIL = "kacper.ciesla@gmail.com"
HOMEPAGE = "http://teamon.eu/rdb4o/"
SUMMARY = "Small library for accessing db4o from jruby"

spec = Gem::Specification.new do |s|
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = 'jruby'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE  
  s.require_path = 'lib'
  s.bindir = 'bin'
  s.executables = %w( compile_models )
  s.files = %w( LICENSE README Rakefile TODO ) +  Dir.glob("{bin,lib,spec}/**/*")
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

namespace :jruby do
  desc "Run :package and install the resulting .gem with jruby"
  task :install => :package do
    sh %{jruby -S gem install pkg/#{GEM_NAME}-#{GEM_VERSION}-java.gem --no-rdoc --no-ri}
  end
end

namespace :spec do
  desc "Run specs"
  task :run do
    if ENV['file']
      specs = File.dirname(__FILE__) + "/spec/#{ENV['file']}_spec.rb"
    else
      specs = Dir[File.dirname(__FILE__) + "/spec/**/*_spec.rb"].join(" ")
    end
    
    sh %{jruby -S spec -O spec/spec.opts #{specs}}
  end

  desc "Compile spec models"
  task :compile_models do
    require 'lib/rdb4o/tools'
    Rdb4o::Tools.compile_models(File.dirname(__FILE__) + "/spec/app/models/java")
  end

  desc "Console"
  task :console do
    exec "jruby -S irb -r #{File.dirname(__FILE__)}/spec/console.rb"
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

