class Cat
  include Rdb4o::Model
  
  field :name, "String"
  field :color, "String"
  field :age, "int"
  field :person, "Person"
  
  def say
    puts "meow"
  end
  
end

class Kitty
  include Rdb4o::Model
  
  field :name, "String"
  field :color, "String"
  field :age, "int"
  field :person, "Person"
  
end
