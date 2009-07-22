Rdb4o
===============

see http://teamon.github.com/rdb4o


Author: Kacper Cieśla, Tymon Tobolski

Small library I wrote for fun too have even more fun with db4o and jruby :)
Lots of thanks for Marcin Mielżyński (lopex) for helping me with this.

Requirements
============
All you need to use rdb4o is [JRuby](http://jruby.codehaus.org/) 1.2.0.


Getting started
===============
    git clone git://github.com/teamon/rdb4o.git
    cd rdb4o
    rake install


Usage
=====

#### Model file
    # app/models/cat.rb
    class Cat
      include Rdb4o::Model
  
      field :name, String
      field :age, Fixnum
    end
    
#### Generate and compile
    rdb4o generate app/models
    rdb4o compile app/models

#### Require rdb4o
    require 'rubygems'
    require 'rdb4o'
    
#### Load models
    Rdb4o.load_models
    Dir["app/models/*.rb"].each {|f| require f }
    
#### Connect to database
    Rdb4o::Database.setup :dbfile => 'simple.db'
    
#### Create some objects
    Cat.create(:name => "Kitty", :age => 2)
    Cat.create(:name => "Foobar", :age => 1)
    
#### Get them from database
    Cat.all

#### Close database
This step is not necessary - database gets closed automaticly when process ends.
    Rdb4o::Database.close
    
    
#### Run program
Due to classpaths issue the best way to run this program is to use rdb4o executable.
    rdb4o run main.rb

### Relations

#### One to Many
    class Cat
      include Rdb4o::Model

      field :name, String
      field :age, Fixnum

      belongs_to :person
      belongs_to :owner, :class => Person
    end

    class Person
      include Rdb4o::Model

      field :name, String

      has_many :cats
      has_many :friends, :class => Cat, :key => :owner
    end

    p = Person.create(:name => "Foo")
    c = Cat.new

    p.cats 
    p.cats.new
    p.cats.create

    c = Cat.new
    p.cats << c
    p.cats.delete(c)
    p.cats.destroy_all!

    c.person = p
    
### Filtering
    Cat.all # all objects
    Cat.all(:name => "Kitty") # all cats with name "Kitty"
    Cat.all{|c| c.age > 1 } # cats older than 1 year
    # etc.

### Scope
    class Cat
      scope(:young) {|c| c.age <= 2}
      scope(:old) {|c| c.age > 4}
      scope :black, :color => "black"
      scope :white, :color => "white"
      scope(:colorful) {|c| c.color != "black" && c.color != "white"}
      scope(:four_letters) {|c| c.name.size == 4}
      scope :kitties, :name => "Kitty"
    end

    Cat.young
    Cat.old
    Cat.kitties.black.young

    # works with relations

    p = Person.create(:name => "Eric")

    p.cats.black
    p.cats.black.old.new
    
    
### Ordering
    Cat.all.order(:name.desc)
    Cat.all.order(:name.asc, :age.desc)
    Cat.all.order {|a,b| a.name.size <=> b.name.size }
