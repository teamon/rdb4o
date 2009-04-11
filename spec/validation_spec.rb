# Taken from Sequel

require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rdb4o::Model::Errors do
  before do
    @errors = Rdb4o::Model::Errors.new
  end
  
  it "should be clearable using #clear" do
    @errors.add(:a, 'b')
    @errors.should == {:a=>['b']}
    @errors.clear
    @errors.should == {}
  end
  
  it "should be empty if no errors are added" do
    @errors.should be_empty
    @errors[:blah] << "blah"
    @errors.should_not be_empty
  end

  it "should return errors for a specific attribute using #on or #[]" do
    @errors[:blah].should == []
    @errors.on(:blah).should == []

    @errors[:blah] << 'blah'
    @errors[:blah].should == ['blah']
    @errors.on(:blah).should == ['blah']

    @errors[:bleu].should == []
    @errors.on(:bleu).should == []
  end

  it "should accept errors using #[] << or #add" do
    @errors[:blah] << 'blah'
    @errors[:blah].should == ['blah']

    @errors.add :blah, 'zzzz'
    @errors[:blah].should == ['blah', 'zzzz']
  end

  it "should return full messages using #full_messages" do
    @errors.full_messages.should == []

    @errors[:blow] << 'blieuh'
    @errors[:blow] << 'blich'
    @errors[:blay] << 'bliu'
    msgs = @errors.full_messages
    msgs.size.should == 3
    msgs.should include('blow blieuh', 'blow blich', 'blay bliu')
  end

  it "should return the number of error messages using #count" do
    @errors.count.should == 0
    @errors.add(:a, 'b')
    @errors.count.should == 1
    @errors.add(:a, 'c')
    @errors.count.should == 2
    @errors.add(:b, 'c')
    @errors.count.should == 3
  end

  it "should return the array of error messages for a given attribute using #on" do
    @errors.add(:a, 'b')
    @errors.on(:a).should == ['b']
    @errors.add(:a, 'c')
    @errors.on(:a).should == ['b', 'c']
    @errors.add(:b, 'c')
    @errors.on(:a).should == ['b', 'c']
  end

  it "should return nil if there are no error messages for a given attribute using #on" do
    @errors.on(:a).should == nil
    @errors.add(:b, 'b')
    @errors.on(:a).should == nil
  end
end

describe Rdb4o::Model do
  before do
    # class Person (see app/models/java/Person.java)
    class Person
      def validate
        errors.add(:age, 'too low') if age < 18
      end
    end
    
    @person = Person.new
    
  end
  
  it "should supply a #valid? method that returns true if validations pass" do
    @person.age = 10
    @person.should_not be_valid
    @person.age = 20
    @person.should be_valid
  end

  it "should provide an errors object" do
    @person.age = 20
    @person.should be_valid
    @person.errors.should be_empty

    @person.age = 10
    @person.should_not be_valid
    @person.errors[:age].should == ['too low']
    @person.errors.on(:age).should == ['too low']
    @person.errors[:blah].should be_empty
  end
end

