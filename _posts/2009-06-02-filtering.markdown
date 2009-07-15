---
layout: default
title: Filtering, scope & ordering
---

{% highlight ruby %}
Cat.all # all objects
Cat.all(:name => "Kitty") # all cats with name "Kitty"
Cat.all{|c| c.age > 1 } # cats older than 1 year
# etc.
{% endhighlight %}

{% highlight ruby %}
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

{% endhighlight %}

{% highlight ruby %}
Cat.all.order(:name)
Cat.all.order(:name, :age)
Cat.all.order {|a,b| a.name.size <=> b.name.size }

{% endhighlight %}