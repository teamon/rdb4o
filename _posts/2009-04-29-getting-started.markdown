---
layout: default
title: Getting started
---

### Requirements
All you need to use rdb4o is [JRuby](http://jruby.codehaus.org/) 1.2.0.

### Instalation

{% highlight bash %}
$ git clone git://github.com/teamon/rdb4o.git
$ cd rdb4o
$ rake install

# this does not work right now...
$ jruby -S gem sources -a http://gems.github.com/
$ jruby -S gem install teamon-rdb4o
{% endhighlight %}

### Create a model file
Ruby model class will be transformed into Java class, so it should have some package. For example app/models.

{% highlight ruby %}
# app/models/cat.rb
class Cat
  include Rdb4o::Model
  
  field :name, "String"
  field :age, "int"
end
{% endhighlight %}

### Generate & compile
In order to store objects in db4o Ruby classes need Java wrappers, that must be generated and compiled.
{% highlight bash %}
$ rdb4o generate app/models
$ rdb4o compile app/models
{% endhighlight %}


### Store some objects

#### Require rdb4o
{% highlight ruby %}
require "rubygems"
require "rdb4o" 
{% endhighlight %}

#### Load models
{% highlight ruby %}
Rdb4o.load_models
Dir["app/models/*.rb"].each {|f| require f }
{% endhighlight %}

#### Setup database
{% highlight ruby %}
Rdb4o::Database.setup(:dbfile => "main.db")
{% endhighlight %}

#### Create some objects
{% highlight ruby %}
Cat.create(:name => "Kitty", :age => 2)
Cat.create(:name => "Foobar", :age => 1)
{% endhighlight %}

#### Fetch them from database
{% highlight ruby %}
puts Cat.all.map {|c| c.name}.inspect
{% endhighlight %}

#### Close database
This step is not necessary - database gets closed automaticly when program ends.
{% highlight ruby %}
Rdb4o::Database.close
{% endhighlight %}


### Complete file
{% highlight ruby %}
# main.rb
require "rubygems"
require "rdb4o"

Rdb4o.load_models
Dir["app/models/*.rb"].each {|f| require f }

Rdb4o::Database.setup(:dbfile => "main.db")

Cat.create(:name => "Kitty", :age => 2)
Cat.create(:name => "Foobar", :age => 1)

puts Cat.all.map {|c| c.name}.inspect

Rdb4o::Database.close
{% endhighlight %}


### Run program
Due to classpaths issue the best way to run this program is to use rdb4o executable.
{% highlight bash %}
$ rdb4o run main.rb
{% endhighlight %}

Program should output
{% highlight bash %}
["Kitty", "Foobar"]
{% endhighlight %}
If you run that again you will get
{% highlight bash %}
["Kitty", "Foobar", "Kitty", "Foobar"]
{% endhighlight %}
