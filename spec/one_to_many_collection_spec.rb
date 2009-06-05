require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rdb4o::OneToManyCollection do
  before(:all) do
    reconnect_database
  end

  before(:each) do
    Person.destroy_all!
    Cat.destroy_all!

    @eric = Person.create(:name => "Eric Cartman", :age => 8)
  end

  it "should return collection" do
    @eric.cats.should be_an(Rdb4o::OneToManyCollection)
  end

  it "should create new collection with correct model class" do
    @eric.cats.model.should == Cat
  end

  it "should update relations" do
    kitty = Cat.new(:name => "Kitty")
    kitty.person.should == nil
    @eric.cats << kitty
    @eric.cats.size.should == 1
    kitty.person.should == @eric
  end

  it "should allow only unique objects" do
    kitty = Cat.new(:name => "Kitty")
    kitty.person.should == nil
    @eric.cats << kitty
    @eric.cats << kitty
    @eric.cats << kitty
    @eric.cats.size.should == 1
  end

  it "should update relations" do
    kitty = Cat.new(:name => "Kitty")
    kitty.person = @eric
    @eric.cats.should_not include(kitty)
    kitty.save
    @eric.cats.should include(kitty)
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
    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 1
  end

  specify "collection" do
    @eric.cats.size.should == 0
    kitty = @eric.cats.create(:name => 'Kitty')
    reconnect_database

    eric = Person.all.first
    c = eric.cats.first
    c.name.should == kitty.name
    c.age.should == kitty.age
    c.person.name.should == @eric.name
  end

  specify "#all with conditions" do
    @eric.cats.create(:name => 'Kitty')
    @eric.cats.create(:name => 'Kitty')
    @eric.cats.create(:name => 'Ozzy')
    Cat.create(:name => 'Kitty')
    Cat.create(:name => 'Ozzy')
    reconnect_database

    eric = Person.all.first
    eric.cats.all(:name => 'Kitty').size.should == 2
    eric.cats.all(:name => 'Ozzy').size.should == 1
  end

  specify "#all with proc" do
    @eric.cats.create(:name => 'Kitty', :age => 3)
    @eric.cats.create(:name => 'Kitty', :age => 4)
    @eric.cats.create(:name => 'Ozzy', :age => 5)
    Cat.create(:name => 'Kitty')
    Cat.create(:name => 'Ozzy', :age => 5)
    reconnect_database

    eric = Person.all.first
    eric.cats.all {|p| p.name == 'Kitty'}.size.should == 2
    eric.cats.all {|p| p.name == 'Ozzy'}.size.should == 1
    eric.cats.all {|p| p.age > 3}.size.should == 2
  end

  specify "#all should return only objects that match class" do
    @eric.cats.create(:name => 'Kyle')
    @eric.cats.create(:name => 'Stan')
    @eric.cats.create(:name => 'Kenny')
    Cat.create(:name => 'Foo')
    Cat.create(:name => 'Bar')
    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 3
    Cat.all.size.should == 5
  end

  specify "#destroy_all! should destroy all objects" do
    @eric.cats.create(:name => 'Jimmy', :age => 35)
    @eric.cats.create(:name => 'Jimmy', :age => 40)
    @eric.cats.create(:name => 'Timmy', :age => 45)
    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 3
    eric.cats.destroy_all!
    reconnect_database

    eric = Person.all.first
    eric.cats.size.should == 0
  end

end
