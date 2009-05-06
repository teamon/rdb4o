class Fish
  include Rdb4o::ModelGenerator
  
  field :name, "String"
  field :age, "int"
  field :speed, "float"
  
end
