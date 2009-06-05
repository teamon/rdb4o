require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rdb4o::Types do
  before(:all) do
    class Chef
      include Rdb4o::Model

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
      Rdb4o::Type.for(String).should == Rdb4o::Types::String
      Rdb4o::Type.for(Fixnum).should == Rdb4o::Types::Fixnum
      Rdb4o::Type.for(Integer).should == Rdb4o::Types::Fixnum
      Rdb4o::Type.for(Float).should == Rdb4o::Types::Float

      Rdb4o::Type.for("String").should == Rdb4o::Types::String
      Rdb4o::Type.for("Fixnum").should == Rdb4o::Types::Fixnum
      Rdb4o::Type.for("Integer").should == Rdb4o::Types::Fixnum
      Rdb4o::Type.for("Float").should == Rdb4o::Types::Float
      Rdb4o::Type.for("Boolean").should == Rdb4o::Types::Boolean

      Rdb4o::Type.for("int").should == "int"
      Rdb4o::Type.for("char").should == "char"

      Rdb4o::Type.for([String]).superclass.should == Rdb4o::Types::Array
      Rdb4o::Type.for([String]).type.should == String
      Rdb4o::Type.for(["int"]).superclass.should == Rdb4o::Types::Array
      Rdb4o::Type.for(["int"]).type.should == "int"
    end

    it "should return correct java_type" do
      Rdb4o::Type.java_type_for(String).should == "String"
      Rdb4o::Type.java_type_for(Fixnum).should == "int"
      Rdb4o::Type.java_type_for(Integer).should == "int"
      Rdb4o::Type.java_type_for(Float).should == "float"

      Rdb4o::Type.java_type_for("String").should == "String"
      Rdb4o::Type.java_type_for("Fixnum").should == "int"
      Rdb4o::Type.java_type_for("Integer").should == "int"
      Rdb4o::Type.java_type_for("Float").should == "float"
      Rdb4o::Type.java_type_for("Boolean").should == "boolean"

      Rdb4o::Type.java_type_for("int").should == "int"
      Rdb4o::Type.java_type_for("char").should == "char"

      Rdb4o::Type.java_type_for([String]).should == "String[]"
      Rdb4o::Type.java_type_for(["int"]).should == "int[]"
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
      Rdb4o::Types::String.dump("some string").should == "some string"
      Rdb4o::Types::String.dump(4).should == "4"
      Rdb4o::Types::String.dump(:symbol).should == "symbol"
      Rdb4o::Types::String.dump(5.9).should == "5.9"
      Rdb4o::Types::String.dump(true).should == "true"
      Rdb4o::Types::String.dump(nil).should == ""
    end

    specify "Fixnum" do
      Rdb4o::Types::Fixnum.dump("some string").should == 0
      Rdb4o::Types::Fixnum.dump("3").should == 3
      Rdb4o::Types::Fixnum.dump(4).should == 4
      Rdb4o::Types::Fixnum.dump(:symbol).should == 0
      Rdb4o::Types::Fixnum.dump(5.9).should == 5
      Rdb4o::Types::Fixnum.dump(true).should == 0
      Rdb4o::Types::Fixnum.dump(nil).should == 0
    end

    specify "Float" do
      Rdb4o::Types::Float.dump("some string").should == 0.0
      Rdb4o::Types::Float.dump(4).should == 4.0
      Rdb4o::Types::Float.dump(:symbol).should == 0.0
      Rdb4o::Types::Float.dump(5.9).should == be_approx_equal(5.9, 0.00000000001)
      Rdb4o::Types::Float.dump(true).should == 0.0
      Rdb4o::Types::Float.dump(nil).should == 0.0
    end

    specify "Boolean" do
      Rdb4o::Types::Boolean.dump("some string").should == true
      Rdb4o::Types::Boolean.dump(4).should == true
      Rdb4o::Types::Boolean.dump(:symbol).should == true
      Rdb4o::Types::Boolean.dump(5.9).should == true
      Rdb4o::Types::Boolean.dump(true).should == true
      Rdb4o::Types::Boolean.dump(false).should == false
      Rdb4o::Types::Boolean.dump(nil).should == false
    end
  end

end
