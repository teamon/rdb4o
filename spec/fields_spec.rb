require File.dirname(__FILE__) + '/spec_helper.rb'

describe Jrodb::Model::Field do
  before(:all) do
    class Kenny
      include Jrodb::Model
    end

    class Kyle
      include Jrodb::Model

      field :name, String
      field :age, Fixnum
    end
  end

  describe "fields" do

    it "should have empty fields" do
      Kenny.fields.should be_empty
    end

    it "should have fields" do
      Kyle.fields.should have_key(:name)
      Kyle.fields.should have_key(:age)
    end
  end



  describe "Field" do
    # Isnt checking for class lame in ruby world?
    # it "should have correct class" do
    #   Kyle.fields[:name].should be_a(Jrodb::Model::Field)
    #   Kyle.fields[:age].should be_a(Jrodb::Model::Field)
    # end

    it "should have correct type" do
      Kyle.fields[:name].type.should == Jrodb::Types::String
      Kyle.fields[:age].type.should == Jrodb::Types::Fixnum
    end

    it "should respond to java type" do
      Kyle.fields[:name].should respond_to(:java_type)
      Kyle.fields[:age].should respond_to(:java_type)
    end

  end

  describe "Instance" do

    it "should have attributes hash" do
      k = Kyle.new

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
