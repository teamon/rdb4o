require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Order" do
  before(:all) do
    reconnect_database
    Person.create(:name => "Kyle", :age => 1)
    Person.create(:name => "Kenny", :age => 2)
    Person.create(:name => "Stan", :age => 3)
    Person.create(:name => "Eric", :age => 3)
  end
  
  it "should order by field" do
    Person.all.order(:name).map {|e| e.name}.should == ["Eric", "Kenny", "Kyle", "Stan"]
    Person.all.order(:age, :name).map {|e| e.name}.should == ["Kyle", "Kenny", "Eric", "Stan"]
  end
    
  it "should order by proc" do
    Person.all.order{|a,b| a.name <=> b.name }.map {|e| e.name}.should == ["Eric", "Kenny", "Kyle", "Stan"]
    Person.all.order{|a,b| a.name.split(//).last <=> b.name.split(//).last }.map {|e| e.name}.should == ["Eric", "Kyle", "Stan", "Kenny"]
  end

end

