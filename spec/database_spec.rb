require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rdb4o::Database do
  it "should require dbfile" do
    lambda {
      Rdb4o::Database.setup
    }.should raise_error(ArgumentError)
  end

  it "should create database" do
    Rdb4o::Database.setup(:dbfile => "test.db")
    File.exists?("test.db").should == true
    Rdb4o::Database.close
  end

  it "should setup server"

  it "#[] should return database connection" do
    Rdb4o::Database.setup(:dbfile => "test.db")
    Rdb4o::Database[:default].connection.should be_a_kind_of(Java::ComDb4oInternal::IoAdaptedObjectContainer)
    Rdb4o::Database.close
  end

  describe "Query" do
    before(:each) do
      reconnect_database
      @db = Rdb4o::Database[:default]
    end

    after(:each) do
      Dir["*.db"].each {|path| File.delete(path) }
    end

    it "should store object in database" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      @db.store(eric)
      @db.query(Person).size.should == 1
      @db.query(Person)[0].getName.should == "Eric"

      kyle = Person.new
      kyle.setName("Kyle")
      kyle.setAge(8)

      @db.store(kyle)
      @db.query(Person).size.should == 2
      @db.query(Person)[1].getName.should == "Kyle"

    end

    it "should update object" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      @db.store(eric)
      @db.query(Person).size.should == 1

      eric = @db.query(Person)[0]
      @db.delete(eric)

      @db.query(Person).size.should == 0
    end

    it "should delete object" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      @db.store(eric)
      @db.query(Person).size.should == 1

      eric = @db.query(Person)[0]
      eric.getName.should == "Eric"

      eric.setName("Eric Cartman")
      @db.store(eric)

      @db.query(Person)[0].getName.should == "Eric Cartman"
    end

    it "should query by class name" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      kitty = Cat.new
      kitty.setName("Kitty")
      kitty.setAge(1)

      @db.store(eric)
      @db.store(kitty)

      @db.query(Person).size.should == 1
      @db.query(Cat).size.should == 1
    end

    it "should query by conditions" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      kyle = Person.new
      kyle.setName("Kyle")
      kyle.setAge(8)

      @db.store(eric)
      @db.store(kyle)

      @db.query(Person, {:name => nil}).size.should == 0
      @db.query(Person, :name => "Eric").size.should == 1
      @db.query(Person, :name => "Kyle").size.should == 1
      @db.query(Person, :name => "Stan").size.should == 0
      @db.query(Person, :age => 3).size.should == 0
      @db.query(Person, :age => 8).size.should == 2
    end

    it "should query by proc" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      kyle = Person.new
      kyle.setName("Kyle")
      kyle.setAge(8)

      kitty = Cat.new
      kitty.setName("Kitty")
      kitty.setAge(1)

      @db.store(eric)
      @db.store(kyle)
      @db.store(kitty)

      @db.query(nil, {}, [lambda{|obj| true}]).size.should == 3
      @db.query(Person, {}, [lambda{|obj| true}]).size.should == 2
      @db.query(Cat, {}, [lambda{|obj| true}]).size.should == 1
      @db.query(Person, {}, [lambda{|obj| false}]).size.should == 0
      @db.query(Cat, {}, [lambda{|obj| false}]).size.should == 0
      @db.query(nil, {}, [lambda{|obj| false}]).size.should == 0
    end

    it "should query by class name, conditions and proc" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      kyle = Person.new
      kyle.setName("Kyle")
      kyle.setAge(8)

      kitty = Cat.new
      kitty.setName("Kitty")
      kitty.setAge(1)

      @db.store(eric)
      @db.store(kyle)
      @db.store(kitty)
      @db.query(nil, {:age => 8}, [lambda{|obj| true}]).size.should == 2
      @db.query(nil, {:age => 8}, [lambda{|obj| obj.name == "Eric"}]).size.should == 1
      @db.query(nil, {:age => 8}, [lambda{|obj| obj.name == "Kitty"}]).size.should == 0
      @db.query(nil, {:age => 1}, [lambda{|obj| obj.name == "Eric"}]).size.should == 0
      @db.query(nil, {:age => 8}, [lambda{|obj| obj.name =~ /^K/}]).size.should == 1
      @db.query(nil, {}, [lambda{|obj| obj.name =~ /^K/}]).size.should == 2
      @db.query(Person, {}, [lambda{|obj| obj.name =~ /^K/}]).size.should == 1
    end
    
    it "should raise argument error" do
      lambda {
        @db.query(nil, {}, [], [:name], lambda{})
      }.should raise_error(ArgumentError)
    end
    
    it "should return objects in order using order_fields" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      kyle = Person.new
      kyle.setName("Kyle")
      kyle.setAge(4)

      kyle2 = Person.new
      kyle2.setName("Kyle")
      kyle2.setAge(2)
      
      @db.store(eric)
      @db.store(kyle)
      @db.store(kyle2)
      
      @db.query(nil, {}, [], [:name]).map{|e| e.name}.should == ["Eric", "Kyle", "Kyle"]
      @db.query(nil, {}, [], [:age]).map{|e| e.name}.should == ["Kyle", "Kyle", "Eric"]
      @db.query(nil, {}, [], [:name, :age]).map{|e| e.name}.should == ["Eric", "Kyle", "Kyle"]
      @db.query(nil, {}, [], [:name, :age]).map{|e| e.age}.should == [8, 2, 4]
    end

    it "should return objects in order" do
      eric = Person.new
      eric.setName("Eric")
      eric.setAge(8)

      kyle = Person.new
      kyle.setName("Kyle")
      kyle.setAge(4)

      kitty = Cat.new
      kitty.setName("Kitty")
      kitty.setAge(1)

      @db.store(eric)
      @db.store(kyle)
      @db.store(kitty)
      
      @db.query(nil, {}, [], [], lambda{|a,b| a.age <=> b.age}).map{|e| e.name}.should == ["Kitty", "Kyle", "Eric"]
      @db.query(nil, {}, [], [], lambda{|a,b| b.age <=> a.age}).map{|e| e.name}.should == ["Eric", "Kyle", "Kitty"]
      @db.query(Person, {}, [], [], lambda{|a,b| a.age <=> b.age}).map{|e| e.name}.should == ["Kyle", "Eric"]
    end
    
    it "should use LIMIT"
    it "should use OFFSET"

  end

end
