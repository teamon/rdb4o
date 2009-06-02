---
layout: default
title: Type casting
---

### The problem
Java is staticly typed language. For java class like:
{% highlight java %}
public class Cat {
  public Cat() {}

  int age;

  public void setAge(int age) { this.age = age; }
  public int getAge() { return this.age; 
}
{% endhighlight %}

if we then use it from JRuby and try to set name:
{% highlight ruby %}
c = Cat.new
c.age = "3" # => TypeError: for method setAge expected [#<Java::JavaClass:0x782b26a4>]; 
                 got: [java.lang.String]; error: argument type mismatch
{% endhighlight %}

This looks reasonable, but in Ruby world all ORMs let us to do something like:
{% highlight ruby %}
c = Cat.new(params)
{% endhighlight %}
where _params_ is hash or Strings. 

### The solution
Use attributes hash, store all values there and then right before saving object to database cast all values to properiate types.
For example, with int attribute _age_ method 
{% highlight ruby %}c.age = value{% endhighlight %}will store value in {% highlight ruby %}attributes[:age] = value{% endhighlight %}and then before save it will call {% highlight ruby %}setAge(attributes[:age].to_i){% endhighlight %}