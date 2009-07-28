require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Rdb4o::Collection do
  before(:all) do
    reconnect_database

    class Cat
      scope(:young) {|c| c.age <= 2}
      scope(:old) {|c| c.age > 4}
      scope :black, :conditions => {:color => "black"}
      scope :white, :conditions => {:color => "white"}
      scope(:colorful) {|c| c.color != "black" && c.color != "white"}
      scope(:four_letters) {|c| c.name.size == 4}
      scope :kitties, :conditions => {:name => "Kitty"}

      scope :a2z, :order => [:name.asc]
      scope :z2a, :order => [:name.desc]
      scope :youngest_first, :order => [:age.asc]
      scope :colors, :order => lambda {|a,b| a.color <=> b.color }
    end
  end

  describe "Scope with Collection::Basic" do

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

    specify "a2z" do
      Cat.a2z.map{|e| e.name}.should == %w(Abby Aiko Bali Garfield Kitty Kitty Miko)
    end

    specify "z2a" do
      Cat.z2a.map{|e| e.name}.should == %w(Miko Kitty Kitty Garfield Bali Aiko Abby)
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
      colorful_young.should include(@garfield)
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

    specify "scope with conditions" do
      cats = Cat.black.all(:age => 1)
      cats.size.should == 2
      cats.should include(@abby)
      cats.should include(@kitty2)
    end

    specify "scope with proc" do
      cats = Cat.black.all {|c| c.age == 1 }
      cats.size.should == 2
      cats.should include(@abby)
      cats.should include(@kitty2)
    end

    it "should create new object with conditions" do
      cat = Cat.black.new
      cat.color.should == "black"

      cat = Cat.kitties.new
      cat.name.should == "Kitty"
    end

  end

  describe "Scope with OneToMany" do
    before(:each) do
      Person.destroy_all!
      Cat.destroy_all!

      @eric = Person.create(:name => "Eric", :age => 8)

      @abby = @eric.cats.create(:name => "Abby", :age => 1, :color => "black")
      @aiko = @eric.cats.create(:name => "Aiko", :age => 2, :color => "black")
      @bali = @eric.cats.create(:name => "Bali", :age => 3, :color => "white")
      @kitty1 = @eric.cats.create(:name => "Kitty", :age => 7, :color => "white")
      @kitty2 = @eric.cats.create(:name => "Kitty", :age => 1, :color => "black")
      @garfield = @eric.cats.create(:name => "Garfield", :age => 2, :color => "orange")
      @miko = @eric.cats.create(:name => "Miko", :age => 6, :color => "black")

      @xabby = Cat.create(:name => "Abby", :age => 1, :color => "black")
      @xaiko = Cat.create(:name => "Aiko", :age => 2, :color => "black")
      @xbubu = Cat.create(:name => "Bubu", :age => 2, :color => "black")
      @xbali = Cat.create(:name => "Bali", :age => 3, :color => "white")
      @xkitty1 = Cat.create(:name => "Kitty", :age => 7, :color => "white")
      @xkitty2 = Cat.create(:name => "Kitty", :age => 1, :color => "black")
      @xkitty3 = Cat.create(:name => "Kitty", :age => 1, :color => "black")
      @xgarfield = Cat.create(:name => "Garfield", :age => 2, :color => "orange")
      @xmiko = Cat.create(:name => "Miko", :age => 6, :color => "black")
    end

    specify "young" do
      young = @eric.cats.young
      young.size.should == 4
      young.should include(@abby)
      young.should include(@aiko)
      young.should include(@kitty2)
      young.should include(@garfield)
    end

    specify "old" do
      old = @eric.cats.old
      old.size.should == 2
      old.should include(@kitty1)
      old.should include(@miko)
    end

    specify "young + old" do
      @eric.cats.young.old.size.should == 0
      @eric.cats.old.young.size.should == 0
    end

    specify "black" do
      black = @eric.cats.black
      black.size.should == 4
      black.should include(@abby)
      black.should include(@aiko)
      black.should include(@kitty2)
      black.should include(@miko)
    end

    specify "white" do
      white = @eric.cats.white
      white.size.should == 2
      white.should include(@bali)
      white.should include(@kitty1)
    end

    specify "black + white" do
      # overwrite conditions hash!
      @eric.cats.black.white.size.should == 2
      @eric.cats.white.black.size.should == 4
    end

    specify "colorful" do
      colorful = @eric.cats.colorful
      colorful.size.should == 1
      colorful.should include(@garfield)
    end

    specify "colorful + black/white" do
      @eric.cats.colorful.black.size.should == 0
      @eric.cats.colorful.white.size.should == 0
    end

    specify "four_letters" do
      four_letters = @eric.cats.four_letters
      four_letters.size.should == 4
      four_letters.should include(@abby)
      four_letters.should include(@aiko)
      four_letters.should include(@bali)
      four_letters.should include(@miko)
    end

    specify "kitties" do
      kitties = @eric.cats.kitties
      kitties.size.should == 2
      kitties.should include(@kitty1)
      kitties.should include(@kitty2)
    end

    specify "young + black" do
      young_black = @eric.cats.young.black
      young_black.size.should == 3
      young_black.should include(@abby)
      young_black.should include(@aiko)
      young_black.should include(@kitty2)
    end

    specify "young + white" do
      @eric.cats.young.white.size.should == 0
    end

    specify "old + black" do
      old_black = @eric.cats.old.black
      old_black.size.should == 1
      old_black.should include(@miko)
    end

    specify "colorful + old" do
      @eric.cats.colorful.old.size.should == 0
    end

    specify "colorful + young" do
      colorful_young = @eric.cats.colorful.young
      colorful_young.size.should == 1
      colorful_young.should include(@garfield)
    end

    specify "black + kitties" do
      black_kitties = @eric.cats.black.kitties
      black_kitties.size.should == 1
      black_kitties.should include(@kitty2)
    end

    specify "four_letter + young + black" do
      to_long_to_write = @eric.cats.four_letters.young.black
      to_long_to_write.size.should == 2
      to_long_to_write.should include(@abby)
      to_long_to_write.should include(@aiko)
    end

    specify "scope with conditions" do
      cats = @eric.cats.black.all(:age => 1)
      cats.size.should == 2
      cats.should include(@abby)
      cats.should include(@kitty2)
    end

    specify "scope with proc" do
      cats = @eric.cats.black.all {|c| c.age == 1 }
      cats.size.should == 2
      cats.should include(@abby)
      cats.should include(@kitty2)
    end

    it "should create new object with conditions" do
      cat = @eric.cats.black.new
      cat.color.should == "black"
      cat.person.should == @eric

      cat = @eric.cats.kitties.new
      cat.name.should == "Kitty"
      cat.person.should == @eric
    end
  end
end
