---
layout: default
title: Associations
---

### One to Many
{% highlight bash %}
class Cat
  include Rdb4o::Model

  field :name, String
  field :age, Fixnum

  belongs_to :person
  belongs_to :owner, :class => Person, :foreign_name => :friends
end

class Person
  include Rdb4o::Model

  field :name, String

  has_many :cats
  has_many :friends, :class => Cat, :foreign_name => :owner
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

{% endhighlight %}
