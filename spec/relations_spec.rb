require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Relations" do
  before(:all) do
    
    class CoolSong; end
    class Fish; end
    
    class Genius
      include Rdb4o::Model

      field :name, String

      has_many :songs
      has_many :cool_songs, :key => :composer
      has_many :friends, :class => Fish
    end
    
    class Song
      include Rdb4o::Model

      field :title, String

      belongs_to :genius
      belongs_to :author, :class => Genius
      belongs_to :composer
    end

  end

  describe "belongs_to" do

    it "should create correct field" do
      Song.fields.should have_key(:genius)
      Song.fields[:genius].type.should == Genius
    end

    it "should create correct accessor" do
      s = Song.new
      g = Genius.new(:name => "Kanye")
      s.genius = g
      s.genius.should == g
    end

    it "should respect :class option" do
      Song.fields.should have_key(:author)
      Song.fields[:author].type.should == Genius
    end

    it "should create correct accessor with :class option" do
      s = Song.new
      g = Genius.new(:name => "Kanye")
      s.author = g
      s.author.should == g
    end

  end

  describe "has_many" do

    it "should create correct accessor" do
      Genius.new.songs.should be_an(Rdb4o::Collection::OneToMany)
    end

    it "should respect :key option" do
      Genius.new.cool_songs.foreign_key.should == :composer
    end
    
    it "should respect :class option" do
      Genius.new.friends.model.should == Fish
    end

  end

end
