class Cat
  include Rdb4o::Model
  
  field :name, String
  field :color, String
  field :age, Fixnum
  # field :person, "Person"
  
  belongs_to :person
  
  def say
    puts "meow #{name}, meow!"
  end
  
end
