class Person
  include Jrodb::Model

  field :name, String
  field :age, Fixnum

  field :colors, [String]

  has_many :cats

end
