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

  # it "should take an :allow_blank option" do
  #   Person.set_validations { 
  #     validates_format(/.+_.+/, :name, :allow_blank => true)
  #   }
  #     
  #   @person.name = 'abc_'
  #   @person.should_not be_valid
  #   @person.name = '1_1'
  #   @person.should be_valid
  #   o = Object.new
  #   @person.name = o
  #   @person.should_not be_valid
  #   def o.blank?
  #     true
  #   end
  #   @person.should be_valid
  # end
  
  # specify "should take an :allow_missing option" do
  #   Person.set_validations{validates_format(/.+_.+/, :name, :allow_missing=>true)}
  #   @person.values.clear
  #   @person.should be_valid
  #   @person.name = nil
  #   @person.should_not be_valid
  #   @person.name = '1_1'
  #   @person.should be_valid
  # end
  # 
  # specify "should take an :allow_nil option" do
  #   Person.set_validations{validates_format(/.+_.+/, :name, :allow_nil=>true)}
  #   @person.name = 'abc_'
  #   @person.should_not be_valid
  #   @person.name = '1_1'
  #   @person.should be_valid
  #   @person.name = nil
  #   @person.should be_valid
  # end
  # 
  # specify "should take a :message option" do
  #   Person.set_validations{validates_format(/.+_.+/, :name, :message=>"is so blah")}
  #   @person.name = 'abc_'
  #   @person.should_not be_valid
  #   @person.errors.full_messages.should == ['value is so blah']
  #   @person.name = '1_1'
  #   @person.should be_valid
  # end
  # 
  # specify "should take multiple attributes in the same call" do
  #   Person.columns :name, :name2
  #   Person.set_validations{validates_presence([:name, :name2])}
  #   @person.should_not be_valid
  #   @person.name = 1
  #   @person.should_not be_valid
  #   @person.value2 = 1
  #   @person.should be_valid
  # end
  # 
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
  # specify "should support validates_presence" do
  #   Person.set_validations{validates_presence(:name)}
  #   @person.should_not be_valid
  #   @person.name = ''
  #   @person.should_not be_valid
  #   @person.name = 1234
  #   @person.should be_valid
  #   @person.name = nil
  #   @person.should_not be_valid
  #   @person.name = true
  #   @person.should be_valid
  #   @person.name = false
  #   @person.should be_valid
  #   @person.name = Time.now
  #   @person.should be_valid
  # end
  # 
  # it "should support validates_unique with a single attribute" do
  #   Person.columns(:id, :username, :password)
  #   Person.set_dataset MODEL_DB[:items]
  #   Person.set_validations{validates_unique(:username)}
  #   Person.dataset.extend(Module.new {
  #     def fetch_rows(sql)
  #       @db << sql
  #       
  #       case sql
  #       when /COUNT.*username = '0records'/
  #         yield({:v => 0})
  #       when /COUNT.*username = '1record'/
  #         yield({:v => 1})
  #       end
  #     end
  #   })
  #   
  #   @user = Person.new(:username => "0records", :password => "anothertest")
  #   @user.should be_valid
  #   @user = Person.load(:id=>3, :username => "0records", :password => "anothertest")
  #   @user.should be_valid
  # 
  #   @user = Person.new(:username => "1record", :password => "anothertest")
  #   @user.should_not be_valid
  #   @user.errors.full_messages.should == ['username is already taken']
  #   @user = Person.load(:id=>4, :username => "1record", :password => "anothertest")
  #   @user.should_not be_valid
  #   @user.errors.full_messages.should == ['username is already taken']
  # 
  #   ds1 = Person.dataset.filter([[:username, '0records']])
  #   ds2 = ds1.exclude(:id=>1)
  #   Person.dataset.should_receive(:filter).with([[:username, '0records']]).twice.and_return(ds1)
  #   ds1.should_receive(:exclude).with(:id=>1).once.and_return(ds2)
  # 
  #   @user = Person.load(:id=>1, :username => "0records", :password => "anothertest")
  #   @user.should be_valid
  #   MODEL_DB.sqls.last.should == "SELECT COUNT(*) FROM items WHERE ((username = '0records') AND (id != 1)) LIMIT 1"
  #   @user = Person.new(:username => "0records", :password => "anothertest")
  #   @user.should be_valid
  #   MODEL_DB.sqls.last.should == "SELECT COUNT(*) FROM items WHERE (username = '0records') LIMIT 1"
  # end
  # 
  # it "should support validates_unique with multiple attributes" do
  #   Person.columns(:id, :username, :password)
  #   Person.set_dataset MODEL_DB[:items]
  #   Person.set_validations{validates_unique([:username, :password])}
  #   Person.dataset.extend(Module.new {
  #     def fetch_rows(sql)
  #       @db << sql
  #       
  #       case sql
  #       when /COUNT.*username = '0records'/
  #         yield({:v => 0})
  #       when /COUNT.*username = '1record'/
  #         yield({:v => 1})
  #       end
  #     end
  #   })
  #   
  #   @user = Person.new(:username => "0records", :password => "anothertest")
  #   @user.should be_valid
  #   @user = Person.load(:id=>3, :username => "0records", :password => "anothertest")
  #   @user.should be_valid
  # 
  #   @user = Person.new(:username => "1record", :password => "anothertest")
  #   @user.should_not be_valid
  #   @user.errors.full_messages.should == ['username and password is already taken']
  #   @user = Person.load(:id=>4, :username => "1record", :password => "anothertest")
  #   @user.should_not be_valid
  #   @user.errors.full_messages.should == ['username and password is already taken']
  # 
  #   ds1 = Person.dataset.filter([[:username, '0records'], [:password, 'anothertest']])
  #   ds2 = ds1.exclude(:id=>1)
  #   Person.dataset.should_receive(:filter).with([[:username, '0records'], [:password, 'anothertest']]).twice.and_return(ds1)
  #   ds1.should_receive(:exclude).with(:id=>1).once.and_return(ds2)
  # 
  #   @user = Person.load(:id=>1, :username => "0records", :password => "anothertest")
  #   @user.should be_valid
  #   MODEL_DB.sqls.last.should == "SELECT COUNT(*) FROM items WHERE (((username = '0records') AND (password = 'anothertest')) AND (id != 1)) LIMIT 1"
  #   @user = Person.new(:username => "0records", :password => "anothertest")
  #   @user.should be_valid
  #   MODEL_DB.sqls.last.should == "SELECT COUNT(*) FROM items WHERE ((username = '0records') AND (password = 'anothertest')) LIMIT 1"
  # end
end 
