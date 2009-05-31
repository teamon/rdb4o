require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Rdb4o::Model::Field do
  before(:all) do
    class Kenny
      include Rdb4o::Model
    end
    
    class Kyle
      include Rdb4o::Model
      
      field :name, String
      field :age, Fixnum
    end
  end

  describe "Class" do
    
    it "should have empty fields" do
      Kenny.fields.should be_empty
    end
    
    it "should have fields" do
      Kyle.fields.should have_key(:name)
      Kyle.fields[:name].should be_a Rdb4o::Model::Field
      Kyle.fields[:name].type.should == String
      
      Kyle.fields.should have_key(:age)
      Kyle.fields[:age].should be_a Rdb4o::Model::Field
      Kyle.fields[:age].type.should == Fixnum
    end
  end
  
  describe "Instance" do
    
    it "should have attributes hash" do
      k = Kyle.new
      pending "It will work have when object creation will be done"
      k.attributes.should have_key(:name)
      k.attributes.should have_key(:age)
      
      k.attributes[:name] = "Kyle Broflovski"
      k.attributes[:name].should == "Kyle Broflovski"
      
      k.attributes[:age] = 8
      k.attributes[:age].should == 8
    end
    
    it "should have accessors and attributes" do
      k = Kyle.new
      
      k.name = "Kyle Broflovski"
      k.name.should == "Kyle Broflovski"
      k.attributes[:name].should == "Kyle Broflovski"
      
      k.age = 8
      k.age.should == 8
      k.attributes[:age].should == 8
    end
    
  end

end
