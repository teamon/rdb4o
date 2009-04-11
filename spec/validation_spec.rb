require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rdb4o::Validation do
  
  before(:all) do
    Rdb4o::Database.setup(:dbfile => "validation_spec.db")
  end

  it "should respond to #valid?" do
    Person.new.should respond_to(:valid?)
  end

end
