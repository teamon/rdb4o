require File.dirname(__FILE__) + '/../spec_helper.rb'

def reload
  reconnect_database
  @collection = Person.collection(true)
end

describe Rdb4o::Collection do
  before(:all) do
    reconnect_database
      
    class Cat
      scope(:young) {|c| c.age <= 2}
      scope(:old) {|c| c.age > 4}
      scope :black, :color => "black"
      scope :white, :color => "white"
      scope(:colorful) {|c| c.color != "black" && c.color != "white"}
      scope(:four_letters) {|c| c.name.size == 4}
      scope :kitties, :name => "Kitty"
    end
  end
  
  before(:each) do
    Cat.destroy_all!
    
    @abby = Cat.create(:name => "Abby", :age => 1, :color => "black")
    @aiko = Cat.create(:name => "Aiko", :age => 2, :color => "black")
    @bali = Cat.create(:name => "Bali", :age => 3, :color => "white")
    @kitty1 = Cat.create(:name => "Kitty", :age => 7, :color => "white")
    @kitty2 = Cat.create(:name => "Kitty", :age => 1, :color => "black")
    @garfield = Cat.create(:name => "Garfield", :age => 2, :color => "orange")
    @miko = Cat.create(:name => "Miko", :age => 6, :color => "black")
  end
  
  specify "young" do
    young = Cat.young
    young.size.should == 4
    young.should include(@abby)
    young.should include(@aiko)
    young.should include(@kitty2)
    young.should include(@garfield)
  end
  
  specify "old" do
    old = Cat.old
    old.size.should == 2
    old.should include(@kitty1)
    old.should include(@miko)
  end
  
  specify "young + old" do
    Cat.young.old.size.should == 0
    Cat.old.young.size.should == 0
  end
  
  specify "black" do
    black = Cat.black
    black.size.should == 4
    black.should include(@abby)
    black.should include(@aiko)
    black.should include(@kitty2)
    black.should include(@miko)
  end
  
  specify "white" do
    white = Cat.white
    white.size.should == 2
    white.should include(@bali)
    white.should include(@kitty1)
  end
  
  specify "black + white" do
    # overwrite conditions hash!
    Cat.black.white.size.should == 2
    Cat.white.black.size.should == 4
  end
  
  specify "colorful" do
    colorful = Cat.colorful
    colorful.size.should == 1
    colorful.should include(@garfield)
  end
  
  specify "colorful + black/white" do
    Cat.colorful.black.size.should == 0
    Cat.colorful.white.size.should == 0
  end

  specify "four_letters" do
    four_letters = Cat.four_letters
    four_letters.size.should == 4
    four_letters.should include(@abby)
    four_letters.should include(@aiko)
    four_letters.should include(@bali)
    four_letters.should include(@miko)
  end
  
  specify "kitties" do
    kitties = Cat.kitties
    kitties.size.should == 2
    kitties.should include(@kitty1)
    kitties.should include(@kitty2)
  end
  
  specify "young + black" do
    young_black = Cat.young.black
    young_black.size.should == 3
    young_black.should include(@abby)
    young_black.should include(@aiko)
    young_black.should include(@kitty2)
  end
  
  specify "young + white" do
    Cat.young.white.size.should == 0
  end
  
  specify "old + black" do
    old_black = Cat.old.black
    old_black.size.should == 1
    old_black.should include(@miko)
  end

  specify "colorful + old" do
    Cat.colorful.old.size.should == 0
  end
  
  specify "colorful + young" do
    colorful_young = Cat.colorful.young
    colorful_young.size.should == 1
    colorful_young.size.should include(@garfield)
  end
  
  specify "black + kitties" do
    black_kitties = Cat.black.kitties
    black_kitties.size.should == 1
    black_kitties.should include(@kitty2)
  end
  
  specify "four_letter + young + black" do
    to_long_to_write = Cat.four_letters.young.black
    to_long_to_write.size.should == 2
    to_long_to_write.should include(@abby)
    to_long_to_write.should include(@aiko)
  end
end
