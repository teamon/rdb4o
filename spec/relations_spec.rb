require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Relations" do
  before(:all) do
    class Song
      include Rdb4o::Model
      
      field :title, String
      
      belongs_to :genius
      belongs_to :author, :class => "Genius"
      
    end
    
    class Genius
      include Rdb4o::Model
      
      field :name, String
      
      has_many :fishes
    end
  end
  
  describe "belongs_to" do

    it "should create correct field" do
      Song.fields.should have_key(:genius)
      Song.fields[:genius].type.should == "Genius"
    end
    
    it "should create correct accessor" do
      s = Song.new
      g = Genius.new(:name => "Kanye")
      s.genius = g
      s.genius.should == g
    end
    
    it "should respect :class option" do
      Song.fields.should have_key(:author)
      Song.fields[:author].type.should == "Genius"
    end
  
  end
  
end
