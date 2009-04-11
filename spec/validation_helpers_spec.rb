require File.join(File.dirname(__FILE__), "spec_helper")

describe Rdb4o::ValidationHelpers do
  before(:all) do
    Rdb4o::Database.setup(:dbfile => "validation_helpers_spec.db")
    
    class Person
      def self.set_validations(&block)
        define_method(:validate, &block)
      end
    end
  end
  
  before do
    @person = Person.new
  end

  it "should take an :allow_blank option" do
    Person.set_validations { validate_format(/.+_.+/, :name, :allow_blank => true) }
      
    @person.name = 'abc_'
    @person.should_not be_valid
    @person.name = '1_1'
    @person.should be_valid
    @person.name = ''
    @person.should be_valid
  end

  it "should take an :allow_nil option" do
    Person.set_validations { validate_format(/.+_.+/, :name, :allow_nil => true) }
    @person.name = 'abc_'
    @person.should_not be_valid
    @person.name = '1_1'
    @person.should be_valid
    @person.name = nil
    @person.should be_valid
  end
  
  it "should take a :message option" do
    Person.set_validations { validate_format(/.+_.+/, :name, :message => "is so blah") }
    @person.name = 'abc_'
    @person.should_not be_valid
    @person.errors.full_messages.should == ['name is so blah']
    @person.name = '1_1'
    @person.should be_valid
  end
  
  it "should take multiple attributes in the same call" do
    Person.set_validations { validate_presence([:name, :age]) }
    @person.should_not be_valid
    @person.age = 35
    @person.should_not be_valid
    @person.name = "John"
    @person.should be_valid
  end
  
  it "should support validate_length with exact length" do
    Person.set_validations { validate_length(3, :name) }
    @person.should_not be_valid
    @person.name = '123'
    @person.should be_valid
    @person.name = '12'
    @person.should_not be_valid
    @person.name = '1234'
    @person.should_not be_valid
  end
  
  it "should support validates_length with range" do
    Person.set_validations { validate_length(2..5, :name) }
    @person.should_not be_valid
    @person.name = '12345'
    @person.should be_valid
    @person.name = '1'
    @person.should_not be_valid
    @person.name = '123456'
    @person.should_not be_valid
  end
  
  it "should support validate_format" do
    Person.set_validations { validate_format(/.+_.+/, :name) }
    @person.name = 'abc_'
    @person.should_not be_valid
    @person.name = 'abc_def'
    @person.should be_valid
  end
  
  it "should support validate_includes with an array" do
    Person.set_validations { validate_includes([1,2], :age) }
    @person.should_not be_valid
    @person.age = 1
    @person.should be_valid
    @person.age = 2
    @person.should be_valid    
    @person.age = 3
    @person.should_not be_valid 
  end

  it "should support validate_includes with a range" do
    Person.set_validations { validate_includes(1..4, :age) }
    @person.should_not be_valid
    @person.age = 1
    @person.should be_valid
    @person.age = 2
    @person.should be_valid
    @person.age = 0
    @person.should_not be_valid
    @person.age = 5
    @person.should_not be_valid    
  end

  # specify "should supports validates_integer" do
  #   Person.set_validations{validates_integer(:name)}
  #   @person.name = 'blah'
  #   @person.should_not be_valid
  #   @person.name = '123'
  #   @person.should be_valid
  #   @person.name = '123.1231'
  #   @person.should_not be_valid
  # end
  # 

  # 
  it "should support validate_max_length" do
    Person.set_validations { validate_max_length(5, :name) }
    @person.should_not be_valid
    @person.name = '12345'
    @person.should be_valid
    @person.name = '123456'
    @person.should_not be_valid
  end
  
  it "should support validate_min_length" do
    Person.set_validations { validate_min_length(5, :name) }
    @person.should_not be_valid
    @person.name = '12345'
    @person.should be_valid
    @person.name = '1234'
    @person.should_not be_valid
  end
  # 
  # specify "should support validates_not_string" do
  #   Person.set_validations{validates_not_string(:name)}
  #   @person.name = 123
  #   @person.should be_valid
  #   @person.name = '123'
  #   @person.should_not be_valid
  #   @person.errors.full_messages.should == ['value is a string']
  #   @person.meta_def(:db_schema){{:name=>{:type=>:integer}}}
  #   @person.should_not be_valid
  #   @person.errors.full_messages.should == ['value is not a valid integer']
  # end
  # 
  # specify "should support validates_numeric" do
  #   Person.set_validations{validates_numeric(:name)}
  #   @person.name = 'blah'
  #   @person.should_not be_valid
  #   @person.name = '123'
  #   @person.should be_valid
  #   @person.name = '123.1231'
  #   @person.should be_valid
  #   @person.name = '+1'
  #   @person.should be_valid
  #   @person.name = '-1'
  #   @person.should be_valid
  #   @person.name = '+1.123'
  #   @person.should be_valid
  #   @person.name = '-0.123'
  #   @person.should be_valid
  #   @person.name = '-0.123E10'
  #   @person.should be_valid
  #   @person.name = '32.123e10'
  #   @person.should be_valid
  #   @person.name = '+32.123E10'
  #   @person.should be_valid
  #   @person.should be_valid
  #   @person.name = '.0123'
  # end
  # 
  
  it "should support validates_presence for String attribute" do
    Person.set_validations { validate_presence(:name) }
    @person.should_not be_valid
    @person.name = ''
    @person.should_not be_valid
    @person.name = nil
    @person.should_not be_valid
    @person.name = "blah"
    @person.should be_valid
  end
  
  it "should support validates_presence for int attribute" do    
    Person.set_validations { validate_presence(:age) }
    @person.should be_valid # age default to 0
    # @person.age = nil # impossible "primitives do not accept null"
    # @person.should_not be_valid
    @person.age = 1234
    @person.should be_valid
    @person.age = 0
    @person.should be_valid
  end

  it "should support validates_unique with a single attribute" do
    Person.set_validations { validate_unique(:name) }
    
    @john = Person.new(:name => "John")
    @john.should be_valid
    @john.save
    # @john.should be_valid
    
    @john_clone = Person.new(:name => "John")
    @john_clone.should_not be_valid
    @john_clone.errors.full_messages.should == ['name is already taken']
    
    @john_clone.name = "John (clone)"
    @john_clone.should be_valid
  end
  
  it "should support validates_unique with multiple attributes" do
    Person.set_validations { validate_unique([:name, :age]) }
    
    @john = Person.new(:name => "John", :age => 20)
    @john.should be_valid
    @john.save
    # @john.should be_valid
    
    @john_clone = Person.new(:name => "John", :age => 20)
    @john_clone.should_not be_valid
    @john_clone.errors.full_messages.should == ['name and age are already taken']
    
    @john_clone = Person.new(:name => "John", :age => 25)
    @john_clone.should be_valid
  end

end 
