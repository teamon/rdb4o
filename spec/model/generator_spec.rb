require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Rdb4o::Model::Generator do
  before(:all) do
    
    class Eric
      include Rdb4o::Model
      
      field :name, "String"
      field :age, "int"
    end
  end

  it "should generate .java file" do
    file = Rdb4o::Model::Generator.generate!(Eric)
    
    file.should include("import com.rdb4o.Rdb4oModel;")
    file.should include("public class Eric extends Rdb4oModel")
    file.should include("public Eric() {}")
    
    file.should include("int age;")
    file.should include("public void setAge(int age) { this.age = age; }")
    file.should include("public int getAge(int age) { return this.age; }")
    
    file.should include("String name;")
    file.should include("public void setName(String name) { this.name = name; }")
    file.should include("public String getName(String name) { return this.name; }")
    
    file.should_not include("package")
  end
  
  it "should generate .java file with package" do
    file = Rdb4o::Model::Generator.generate!(Eric, "app.models")
    file.should include("package app.models.java;")
  end

end
