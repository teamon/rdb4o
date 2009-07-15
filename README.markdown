Rdb4o
===============

see http://teamon.github.com/rdb4o


Author: Kacper Cieśla, Tymon Tobolski

Small library I wrote for fun too have even more fun with db4o and jruby :)
Lots of thanks for Marcin Mielżyński (lopex) for helping me with this.


Instalation
============
    $ git clone git://github.com/teamon/rdb4o.git
    $ cd rdb4o
    $ rake install


Usage
===============
Connect to database
require 'rubygems'
require 'rdb4o'

Rdb4o::Database.setup :dbfile => 'simple.db'


SPEC CONSOLE
============
rake spec:gen
rake spec:console


sorting:
# q = @db.query
# i q
# q.descend("name").orderAscending();
# r = q.execute
# while r.has_next
#   x r.next.getName
# end
# 
# q = @db.query
# i q
# q.descend("name").orderDescending();
# r = q.execute
# while r.has_next
#   x r.next.getName
# end

