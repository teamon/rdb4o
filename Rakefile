require 'rubygems'
require 'rake/gempackagetask'

PLUGIN = "rdb4o"
GEM_NAME = "rdb4o"
GEM_VERSION = "0.0.1"
AUTHOR = "Kacper Cieśla"
EMAIL = "kacper.ciesla@gmail.com"
HOMEPAGE = "http://"
SUMMARY = "Small library for accessing db4o from jruby"

spec = Gem::Specification.new do |s|
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = 'jruby'
  s.has_rdoc = true
  #s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE  
  s.require_path = 'lib'
  s.autorequire = PLUGIN
  s.files = %w(LICENSE README Rakefile TODO) +  Dir.glob("{lib,spec}/**/*")
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
end
