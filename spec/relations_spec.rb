require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Relations" do
  before(:all) do

    class Song
      include Rdb4o::Model

      field :title, String

      belongs_to :genius
      belongs_to :author, :class => "Genius"
      belongs_to :composer, :foreign_name => :cool_songs
    end

    class Genius
      include Rdb4o::Model

      field :name, String

      has_many :songs
      has_many :cool_songs, :foreign_name => :composer
      has_many :friends, :class => "Fish"

    end

  end

  describe "belongs_to" do

    it "should create correct field" do
      Song.fields.should have_key(:genius)
      Song.fields[:genius].type.should == "Genius"
      Song.fields[:genius].options[:foreign_name].should == :songs
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
      Song.fields[:genius].options[:foreign_name].should == :songs
    end

    it "should create correct accessor with :class option" do
      s = Song.new
      g = Genius.new(:name => "Kanye")
      s.author = g
      s.author.should == g
    end

    it "should respect :foreign_name option" do
      Song.fields.should have_key(:composer)
      Song.fields[:composer].options[:foreign_name].should == :cool_songs
    end

  end

  describe "has_many" do

    it "should create correct field" do
      Genius.fields.should have_key(:songs)
      Genius.fields[:songs].type.should == ["Song"]
      Genius.fields[:songs].options[:foreign_name].should == :genius
    end

    it "should create correct accessor" do
      s = Song.new
      g = Genius.new(:name => "Kanye")
      g.songs.should be_an(Rdb4o::OneToManyCollection)
    end

    it "should respect :class option" do
      Genius.fields.should have_key(:friends)
      Genius.fields[:friends].type.should == ["Fish"]
      Genius.fields[:friends].options[:foreign_name].should == :genius
    end

    it "should respect :foreign_name option" do
      Genius.fields.should have_key(:cool_songs)
      Genius.fields[:cool_songs].options[:foreign_name].should == :composer
    end

  end

end
