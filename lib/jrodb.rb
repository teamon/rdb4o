require 'rubygems'
require 'extlib'

def x(msg)
  STDOUT.puts "\033[0;35m%s\033[0m" % msg
end

def i(obj)
  STDOUT.puts "\033[0;35m%s\033[0m" % obj.inspect
end

$: << File.dirname(__FILE__)

include Java

begin
  require 'java/db4o.jar'
rescue LoadError
  begin
    require ENV['DB4O_JAR'].to_s
  rescue LoadError
    raise "Jrodb ERROR: Could not find db4objects library, put it in my lib/java dir, or try setting environment variable DB4O_JAR to db4objects jar location (You can get it at www.db4o.com)"
  end
end

require 'java/jrodb.jar'


module Jrodb
  def self.logger
    @@logger ||= begin
      logger = Extlib::Logger.new($stdout, :debug)
      class << logger
        def debug(msg)
          # debug!("\033[0;36m%s\033[0m" % msg) if @do_log
        end

        def off!
          @do_log = false
        end

        def on!
          @do_log = true
        end

      end

      logger.on!
      logger
    end
  end

  # global config
  # class << self
  #   attr_accessor :use_validations
  # end

  def self.jar_classpath
    File.join(File.dirname(File.expand_path(__FILE__)), "java")
  end

  def self.load_models(dir = ".")
    Dir["#{dir}/**/*.class"].each do |class_file|
      class_name = File.basename(class_file).sub('.class', '')
      package = File.dirname(class_file).gsub("#{dir}/", "").gsub("/", ".")
      model_class = eval("Java.#{package}.#{class_name}")
      klazz = Object.const_set(class_name, model_class)
      Model.type_map[klazz] = "#{package}.#{class_name}"
    end
  end
end

require :jrodb / :database
require :jrodb / :comparator
require :jrodb / :predicate
# require 'jrodb/errors'
# require 'jrodb/validation_helpers'
require :jrodb / :model / :relations
require :jrodb / :model / :field
require :jrodb / :model / :generator
require :jrodb / :model / :model
require :jrodb / :type
require :jrodb / :types / :primitives
require :jrodb / :collection / :basic
require :jrodb / :collection / :one_to_many
require :jrodb / :order_operator
require :jrodb / :symbol
