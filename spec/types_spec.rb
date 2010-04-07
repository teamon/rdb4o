require File.dirname(__FILE__) + '/spec_helper.rb'

describe Jrodb::Types do
  before(:all) do
    class Chef
      include Jrodb::Model

      field :name, String
      field :age, Fixnum
      field :speed, Float
      field :dead, Boolean

      field :size, "int"
      field :sign, "char"

      field :colors, [String]
    end
  end

  describe "Type" do

    it "should return correct type for name" do
      Jrodb::Type.for(String).should == Jrodb::Types::String
      Jrodb::Type.for(Fixnum).should == Jrodb::Types::Fixnum
      Jrodb::Type.for(Integer).should == Jrodb::Types::Fixnum
      Jrodb::Type.for(Float).should == Jrodb::Types::Float

      Jrodb::Type.for("String").should == Jrodb::Types::String
      Jrodb::Type.for("Fixnum").should == Jrodb::Types::Fixnum
      Jrodb::Type.for("Integer").should == Jrodb::Types::Fixnum
      Jrodb::Type.for("Float").should == Jrodb::Types::Float
      Jrodb::Type.for("Boolean").should == Jrodb::Types::Boolean

      Jrodb::Type.for("int").should == "int"
      Jrodb::Type.for("char").should == "char"

      Jrodb::Type.for([String]).superclass.should == Jrodb::Types::Array
      Jrodb::Type.for([String]).type.should == String
      Jrodb::Type.for(["int"]).superclass.should == Jrodb::Types::Array
      Jrodb::Type.for(["int"]).type.should == "int"
    end

    it "should return correct java_type" do
      Jrodb::Type.java_type_for(String).should == "String"
      Jrodb::Type.java_type_for(Fixnum).should == "int"
      Jrodb::Type.java_type_for(Integer).should == "int"
      Jrodb::Type.java_type_for(Float).should == "float"

      Jrodb::Type.java_type_for("String").should == "String"
      Jrodb::Type.java_type_for("Fixnum").should == "int"
      Jrodb::Type.java_type_for("Integer").should == "int"
      Jrodb::Type.java_type_for("Float").should == "float"
      Jrodb::Type.java_type_for("Boolean").should == "boolean"

      Jrodb::Type.java_type_for("int").should == "int"
      Jrodb::Type.java_type_for("char").should == "char"

      Jrodb::Type.java_type_for([String]).should == "String[]"
      Jrodb::Type.java_type_for(["int"]).should == "int[]"
    end

  end

  describe "Field" do
    it "should have correct java_type" do
      Chef.fields[:name].java_type.should == "String"
      Chef.fields[:age].java_type.should == "int"
      Chef.fields[:speed].java_type.should == "float"
      Chef.fields[:dead].java_type.should == "boolean"
      Chef.fields[:size].java_type.should == "int"
      Chef.fields[:sign].java_type.should == "char"
      Chef.fields[:colors].java_type.should == "String[]"
    end
  end

  describe "dump" do
    specify "String" do
      Jrodb::Types::String.dump("some string").should == "some string"
      Jrodb::Types::String.dump(4).should == "4"
      Jrodb::Types::String.dump(:symbol).should == "symbol"
      Jrodb::Types::String.dump(5.9).should == "5.9"
      Jrodb::Types::String.dump(true).should == "true"
      Jrodb::Types::String.dump(nil).should == nil
    end

    specify "Fixnum" do
      Jrodb::Types::Fixnum.dump("some string").should == 0
      Jrodb::Types::Fixnum.dump("3").should == 3
      Jrodb::Types::Fixnum.dump(4).should == 4
      Jrodb::Types::Fixnum.dump(:symbol).should == 0
      Jrodb::Types::Fixnum.dump(5.9).should == 5
      Jrodb::Types::Fixnum.dump(true).should == 0
      Jrodb::Types::Fixnum.dump(nil).should == 0
    end

    specify "Float" do
      Jrodb::Types::Float.dump("some string").should == 0.0
      Jrodb::Types::Float.dump(4).should == 4.0
      Jrodb::Types::Float.dump(:symbol).should == 0.0
      Jrodb::Types::Float.dump(5.9).should == be_approx_equal(5.9, 0.00000000001)
      Jrodb::Types::Float.dump(true).should == 0.0
      Jrodb::Types::Float.dump(nil).should == 0.0
    end

    specify "Boolean" do
      Jrodb::Types::Boolean.dump("some string").should == true
      Jrodb::Types::Boolean.dump(4).should == true
      Jrodb::Types::Boolean.dump(:symbol).should == true
      Jrodb::Types::Boolean.dump(5.9).should == true
      Jrodb::Types::Boolean.dump(true).should == true
      Jrodb::Types::Boolean.dump(false).should == false
      Jrodb::Types::Boolean.dump(nil).should == false

      c = Chef.new
      c.dead = nil
      c.dead?.should == false
      c.dead = true
      c.dead?.should == true
      c.dead = 1
      c.dead?.should == true
    end
  end

end
