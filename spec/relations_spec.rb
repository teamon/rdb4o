require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Relations" do
  before(:all) do
    reconnect_database
  end
  
  before(:each) do
    Person.destroy_all!
    Cat.destroy_all!
    
    @collection = Person._collection
  end

  

  
end
