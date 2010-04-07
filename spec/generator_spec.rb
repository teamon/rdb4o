require File.dirname(__FILE__) + '/spec_helper.rb'

describe Jrodb::Model::Generator do
  before(:all) do

    class Eric
      include Jrodb::Model

      field :name, "String"
      field :age, Fixnum
    end

    class Kyle
      include Jrodb::Model

      field :name, "String"
      field :age, Float
    end

    class Stan
      include Jrodb::Model

      field :name, "String"
      field :age, "int"
    end

  end

  it "should generate .java file" do
    file = Jrodb::Model::Generator.generate!(Eric)

    file.should include("import com.jrodb.JrodbModel;")
    file.should include("public class Eric extends JrodbModel")
    file.should include("public Eric() {}")

    file.should include("private int age;")
    file.should include("public void setAge(int age) { this.age = age; }")
    file.should include("public int getAge() { return this.age; }")

    file.should include("private String name;")
    file.should include("public void setName(String name) { this.name = name; }")
    file.should include("public String getName() { return this.name; }")

    file.should_not include("package")

    file = Jrodb::Model::Generator.generate!(Kyle)

    file.should include("import com.jrodb.JrodbModel;")
    file.should include("public class Kyle extends JrodbModel")
    file.should include("public Kyle() {}")

    file.should include("private float age;")
    file.should include("public void setAge(float age) { this.age = age; }")
    file.should include("public float getAge() { return this.age; }")

    file.should include("private String name;")
    file.should include("public void setName(String name) { this.name = name; }")
    file.should include("public String getName() { return this.name; }")

    file.should_not include("package")
  end

  it "should generate .java file with package" do
    file = Jrodb::Model::Generator.generate!(Eric, "app.models")
    file.should include("package app.models.java;")
  end

  it "should have list of all classes" do
    Jrodb::Model::Generator.classes.should include(Eric, Kyle, Stan)
  end

  # it "should generate all .java files" do
  #   files = Jrodb::Model::Generator.generate_all!.join
  #
  #   files.should include("public class Eric extends JrodbModel")
  #   files.should include("public class Kyle extends JrodbModel")
  #   files.should include("public class Stan extends JrodbModel")
  # end

end
