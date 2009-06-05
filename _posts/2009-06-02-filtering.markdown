---
layout: default
title: Filtering
---

{% highlight ruby %}
Cat.all # all objects
Cat.all(:name => "Kitty") # all cats with name "Kitty"
Cat.all{|c| c.age > 1 } # cats older than 1 year
# etc.
{% endhighlight %}
