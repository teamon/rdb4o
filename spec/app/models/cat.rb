class Cat
  include Rdb4o::Model
  
  field :name, "String"
  field :color, "String"
  field :age, "int"
  
end
