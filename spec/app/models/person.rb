class Person
  include Rdb4o::Model
  
  field :name, "String"
  field :age, "int"
  
end
