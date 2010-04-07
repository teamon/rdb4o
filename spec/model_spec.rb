require File.dirname(__FILE__) + '/spec_helper.rb'

describe Jrodb::Model do
  before(:all) do
    reconnect_database
  end

  before(:each) do
    Person.destroy_all!
    Cat.destroy_all!
  end

  specify "Array field" do
    Person.create(:colors => ["red", "green", "blue", 1, 4, true, nil])
    reconnect_database
    Person.all.first.colors.should == ["red", "green", "blue", "1", "4", "true", ""]
  end

  describe "Class" do
    specify "#new should create new object with parameters" do
      stan = Person.new(:name => "Stan Marsh", :age => 8)
      stan.name.should == "Stan Marsh"
      stan.age.should == 8
      stan.new?.should == true
    end

    specify "#new should not raise error when trying to set undefined attribute, just ignore that" do
      lambda {
        stan = Person.new(:name => "Stan", :age => 8, :color => "blue")
        stan.age.should == 8
      }.should_not raise_error
    end

    specify "#create should create new object and save it" do
      stan = Person.create(:name => 'Stan')
      stan.name.should == 'Stan'
      stan.new?.should == false
    end

    specify "#all" do
      Person.all.size.should == 0
      stan = Person.create(:name => 'Stan')
      reconnect_database

      p = Person.all.first
      p.name.should == stan.name
      p.age.should == stan.age
    end

    specify "#all with conditions" do
      Person.create(:name => 'Timmy')
      Person.create(:name => 'Timmy')
      Person.create(:name => 'Eric')
      reconnect_database
      Person.all(:name => 'Timmy').size.should == 2
      Person.all(:name => 'Eric').size.should == 1
    end

    specify "#all with proc" do
      Person.create(:name => 'Jimmy', :age => 35)
      Person.create(:name => 'Jimmy', :age => 40)
      Person.create(:name => 'Timmy', :age => 45)
      reconnect_database
      Person.all {|p| p.name == 'Jimmy'}.size.should == 2
      Person.all {|p| p.name == 'Timmy'}.size.should == 1
      Person.all {|p| p.age > 38}.size.should == 2
    end

    specify "#all should return only objects that match class" do
      Person.create(:name => 'Kyle')
      Person.create(:name => 'Stan')
      Person.create(:name => 'Kenny')
      Cat.create(:name => 'Foo')
      Cat.create(:name => 'Bar')
      reconnect_database
      Person.all { true }.size.should == 3
      Cat.all { true }.size.should == 2
    end

    specify "#destroy_all! should destroy all objects" do
      Person.create(:name => 'Jimmy', :age => 35)
      Person.create(:name => 'Jimmy', :age => 40)
      Person.create(:name => 'Timmy', :age => 45)
      Person.all.size.should == 3
      Person.destroy_all!
      Person.all.size.should == 0
    end

    specify "#get_by_db4o_id" do
      jimmy = Person.create(:name => 'Jimmy', :age => 8)
      id = jimmy.db4o_id
      reconnect_database

      p = Person.get_by_db4o_id(id)
      p.name.should == jimmy.name
      p.age.should == jimmy.age
    end

    specify "#get_by_uuid" do
      pending
      jimmy = Person.create(:name => 'Jimmy', :age => 35)
      uuid = jimmy.uuid
      reconnect_database

      p = Person.get_by_uuid(uuid)
      p.name.should == jimmy.name
      p.age.should == jimmy.age
    end

    it "should hava java_type" do
      Person.java_type.should == "app.models.java.Person"
    end
  end

  describe "Instance" do
    specify "#update instance attributes" do
      stan = Person.new
      stan.name = "Eric"
      stan.age = 1

      stan.update(:name => "Stan", :age => 8)
      stan.name.should == "Stan"
      stan.age.should == 8
    end

    specify "#save should save record" do
      Person.all.size.should == 0

      eric = Person.new(:name => 'Eric Cartman')
      eric.new?.should == true
      eric.save.should == true
      eric.new?.should == false

      reconnect_database

      p = Person.all.first
      p.name.should == eric.name
      p.age.should == eric.age
    end

    specify "#destroy should delete object form database" do
      kyle = Person.create(:name => 'Kyle')
      kyle.destroy
      reconnect_database
      Person.all.size.should == 0
    end

    it "should dump attributes" do
      eric = Person.create(:name => "Eric", :age => "8")
      reconnect_database
      Person.all.first.name.should == "Eric"
      Person.all.first.age.should == 8
    end

    specify "#db4o_id" do
      eric = Person.new
      eric.db4o_id.should == 0
      eric.save
      eric.db4o_id.should_not == 0
    end

    specify "#uuid" do
      pending
      john = Person.new
      john.uuid.should == 0
      john.save
      john.uuid.should_not == 0
    end

  end

end




#
#   before(:all) do
#     Jrodb::Db4o.configure.generateUUIDs(Java::JavaLang::Integer::MAX_VALUE)
#     Jrodb::Db4o.configure.objectClass(Person).generateUUIDs(true);
#     Jrodb::Database.setup(:dbfile => "model_spec.db")
#   end
