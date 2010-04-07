require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Jrodb::Collection::OneToMany do
  before(:all) do
    reconnect_database
  end

  before(:each) do
    Jrodb.logger.off!
    Person.destroy_all!
    Cat.destroy_all!

    @eric = Person.create(:name => "Eric", :age => 8)
    Jrodb.logger.on!
  end

  it "should return collection" do
    @eric.cats.should be_an(Jrodb::Collection::OneToMany)
  end

  it "should create new collection with correct model class" do
    @eric.cats.model.should == Cat
  end

  specify "#new should create new object with parameters" do
    kitty = @eric.cats.new(:name => "Kitty", :age => 1)
    kitty.should be_an(Cat)
    kitty.name.should == "Kitty"
    kitty.age.should == 1
    kitty.person.should == @eric
    kitty.new?.should == true
  end

  specify "#new should not raise error when trying to set undefined attribute, just ignore that" do
    lambda {
      kitty = @eric.cats.new(:name => "Kitty", :age => 1, :not_existing => "blue")
      kitty.age.should == 1
    }.should_not raise_error
  end

  specify "#create should create new object and save it" do
    kitty = @eric.cats.create(:name => "Kitty")
    kitty.should be_an(Cat)
    kitty.name.should == "Kitty"
    kitty.person.should == @eric
    kitty.new?.should == false
  end

  it "should add created item to collection" do
    kitty = @eric.cats.create(:name => "Kitty")

    with_reconnect {
      eric = Person.all.first
      eric.cats.size.should == 1
    }
  end

  specify "collection" do
    @eric.cats.size.should == 0
    kitty = @eric.cats.create(:name => 'Kitty')

    with_reconnect {
      eric = Person.all.first
      c = eric.cats.first
      c.name.should == kitty.name
      c.age.should == kitty.age
      c.person.name.should == @eric.name
    }
  end

  specify "#all with conditions" do
    @eric.cats.create(:name => 'Kitty')
    @eric.cats.create(:name => 'Kitty')
    @eric.cats.create(:name => 'Ozzy')
    Cat.create(:name => 'Kitty')
    Cat.create(:name => 'Ozzy')

    with_reconnect {
      eric = Person.all.first
      eric.cats.all(:name => 'Kitty').size.should == 2
      eric.cats.all(:name => 'Ozzy').size.should == 1
    }
  end

  specify "#all with proc" do
    @eric.cats.create(:name => 'Kitty', :age => 3)
    @eric.cats.create(:name => 'Kitty', :age => 4)
    @eric.cats.create(:name => 'Ozzy', :age => 5)
    Cat.create(:name => 'Kitty')
    Cat.create(:name => 'Ozzy', :age => 5)

    with_reconnect {
      eric = Person.all.first
      eric.cats.all {|p| p.name == 'Kitty'}.size.should == 2
      eric.cats.all {|p| p.name == 'Ozzy'}.size.should == 1
      eric.cats.all {|p| p.age > 3}.size.should == 2
    }
  end

  specify "#all should return only objects that match class" do
    @eric.cats.create(:name => 'Kyle')
    @eric.cats.create(:name => 'Stan')
    @eric.cats.create(:name => 'Kenny')
    Cat.create(:name => 'Foo')
    Cat.create(:name => 'Bar')

    with_reconnect {
      eric = Person.all.first
      eric.cats.size.should == 3
      Cat.all.size.should == 5
    }
  end

  specify "#destroy_all! should destroy all objects" do
    @eric.cats.create(:name => 'Jimmy', :age => 35)
    @eric.cats.create(:name => 'Jimmy', :age => 40)
    @eric.cats.create(:name => 'Timmy', :age => 45)
    Cat.all.size.should == 3
    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 3
    eric.cats.destroy_all!

    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 0
    Cat.all.size.should == 0
  end

  specify "#destroy should remove object form collection" do
    @eric.cats.create(:name => 'Jimmy', :age => 35)
    @eric.cats.create(:name => 'Jimmy', :age => 40)
    @eric.cats.create(:name => 'Timmy', :age => 45)

    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 3
    cat = Cat.all.first
    cat.destroy
    eric.cats.size.should == 2

    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 2
  end

  specify "collection.new" do
    cat = @eric.cats.new

    cat.person.should == @eric
    @eric.cats.size.should == 0

    reconnect_database

    Cat.all.size.should == 0
    @eric = Person.all.first
    @eric.cats.size.should == 0
  end

  specify "collection.create" do
    cat = @eric.cats.create(:name => "Kitty")

    cat.should_not be_new
    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat

    reconnect_database

    Cat.all.size.should == 1
    cat = Cat.all.first
    @eric = Person.all.first

    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat
  end

  specify "collection << item" do
    cat = Cat.new
    @eric.cats << cat
    @eric.cats << cat
    @eric.cats << cat

    cat.should_not be_new
    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat

    reconnect_database

    Cat.all.size.should == 1
    cat = Cat.all.first
    @eric = Person.all.first

    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat
  end

  specify "item.parent = parent" do
    cat = Cat.new
    cat.person = @eric
    cat.save

    cat.should_not be_new
    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat

    reconnect_database

    Cat.all.size.should == 1
    cat = Cat.all.first
    @eric = Person.all.first

    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat
  end

  specify "Item.create" do
    cat = Cat.create(:person => @eric)

    cat.should_not be_new
    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat

    reconnect_database

    Cat.all.size.should == 1
    cat = Cat.all.first
    @eric = Person.all.first

    cat.person.should == @eric
    @eric.cats.size.should == 1
    @eric.cats.first.should == cat
  end

  specify "item.parent = new_parent" do
    kyle = Person.create(:name => "Kyle", :age => 8)
    cat = Cat.create(:person => @eric)

    cat.person = kyle
    cat.save

    cat.person.should == kyle
    @eric.cats.size.should == 0
    kyle.cats.size.should == 1
    kyle.cats.first.should == cat

    reconnect_database

    Cat.all.size.should == 1
    cat = Cat.all.first
    @eric = Person.all(:name => "Eric").first
    kyle = Person.all(:name => "Kyle").first

    cat.person.should == kyle
    @eric.cats.size.should == 0
    kyle.cats.size.should == 1
    kyle.cats.first.should == cat
  end

  specify "collection.delete(item)" do
    cat = Cat.create(:person => @eric)
    @eric.cats.delete(cat)

    @eric.cats.size.should == 0

    reconnect_database

    @eric = Person.all.first
    cat = Cat.all.first

    Cat.all.size.should == 1
    cat.person.should == nil
    @eric.cats.size.should == 0
  end

  specify "collection.destroy_all!" do
    Cat.create(:person => @eric)
    Cat.create(:person => @eric)
    Cat.create(:person => @eric)

    @eric.cats.size.should == 3
    @eric.cats.destroy_all!
    @eric.cats.size.should == 0

    reconnect_database

    @eric = Person.all.first

    Cat.all.size.should == 0
    @eric.cats.size.should == 0
  end


  specify "item.destroy" do
    cat = Cat.create(:person => @eric)
    cat.destroy

    @eric.cats.size.should == 0

    reconnect_database

    @eric = Person.all.first

    Cat.all.size.should == 0
    @eric.cats.size.should == 0
  end

end
