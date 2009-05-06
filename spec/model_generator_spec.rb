require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rdb4o::ModelGenerator do

  describe "Class Methods" do
    it "should work.." do
      class Fish
        include Rdb4o::ModelGenerator
        
        field :name, "String"
        field :age, "int"
      end
      
      puts Fish.generate!

    end

  end
end
