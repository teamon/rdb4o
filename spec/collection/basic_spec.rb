require File.dirname(__FILE__) + '/../spec_helper.rb'

def with_reconnect
  yield
  @collection = Person.collection
  reconnect_database
  yield
end

describe Rdb4o::Collection do
  before(:all) do
    reconnect_database
  end

  before(:each) do
    Person.destroy_all!
    Cat.destroy_all!

    @collection = Person.collection
  end

  it "should return collection" do
    Person.all.should be_an(Rdb4o::Collection::Basic)
  end

  it "should create new collection with correct model class" do
    @collection.model.should == Person
  end
  
  specify "#new should create new object with parameters" do
    stan = @collection.new(:name => "Stan Marsh", :age => 8)
    stan.should be_an(Person)
    stan.name.should == "Stan Marsh"
    stan.age.should == 8
    stan.new?.should == true
  end
  
  specify "#new should not raise error when trying to set undefined attribute, just ignore that" do
    lambda {
      stan = @collection.new(:name => "Stan", :age => 8, :not_existing => "blue")
      stan.age.should == 8
    }.should_not raise_error
  end
  
  specify "#create should create new object and save it" do
    stan = @collection.create(:name => 'Stan')
    stan.should be_an(Person)
    stan.name.should == 'Stan'
    stan.new?.should == false
  end
  
  it "should add created item to collection" do
    @collection.size.should == 0
    person = @collection.create(:name => "Stan")
    @collection.size.should == 1
  end
  
  specify "#all" do
    @collection.size.should == 0
    stan = @collection.create(:name => 'Stan')
    
    with_reconnect {
      p = @collection.first
      p.name.should == stan.name
      p.age.should == stan.age      
    }
  end
  
  specify "#all with conditions" do
    @collection.create(:name => 'Timmy')
    @collection.create(:name => 'Timmy')
    @collection.create(:name => 'Eric')
    
    with_reconnect {
      @collection.all(:name => 'Timmy').size.should == 2
      @collection.all(:name => 'Eric').size.should == 1
    }
  end
  
  specify "#all with proc" do
    @collection.create(:name => 'Jimmy', :age => 35)
    @collection.create(:name => 'Jimmy', :age => 40)
    @collection.create(:name => 'Timmy', :age => 45)
    
    with_reconnect {
      @collection.all {|p| p.name == 'Jimmy'}.size.should == 2
      @collection.all {|p| p.name == 'Timmy'}.size.should == 1
      @collection.all {|p| p.age > 38}.size.should == 2
    }
  end
  
  specify "#all should return only objects that match class" do
    cats = Cat.collection
  
    @collection.create(:name => 'Kyle')
    @collection.create(:name => 'Stan')
    @collection.create(:name => 'Kenny')
    cats.create(:name => 'Foo')
    cats.create(:name => 'Bar')
    
    with_reconnect {
      @collection.all { true }.size.should == 3
      cats.all { true }.size.should == 2
    }
  end

  specify "#destroy_all! should destroy all objects" do
    @collection.create(:name => 'Jimmy', :age => 35)
    @collection.create(:name => 'Jimmy', :age => 40)
    @collection.create(:name => 'Timmy', :age => 45)
    @collection.size.should == 3
    @collection.destroy_all!
    
    with_reconnect {
      @collection.size.should == 0
    }
  end

end
