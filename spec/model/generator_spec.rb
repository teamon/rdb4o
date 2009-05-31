require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Rdb4o::Model::Generator do
  before(:all) do
    
    class Eric
      include Rdb4o::Model
      
      field :name, "String"
      field :age, "int"
    end
    
    class Kyle
      include Rdb4o::Model
      
      field :name, "String"
      field :age, "int"
    end
     
    class Stan
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
    file.should include("public int getAge() { return this.age; }")
    
    file.should include("String name;")
    file.should include("public void setName(String name) { this.name = name; }")
    file.should include("public String getName() { return this.name; }")
    
    file.should_not include("package")
  end
  
  it "should generate .java file with package" do
    file = Rdb4o::Model::Generator.generate!(Eric, "app.models")
    file.should include("package app.models.java;")
  end
  
  it "should have list of all classes" do
    Rdb4o::Model::Generator.classes.should include(Eric, Kyle, Stan)
  end
  
  it "should generate all .java files" do
    files = Rdb4o::Model::Generator.generate_all!.join
    
    files.should include("public class Eric extends Rdb4oModel")
    files.should include("public class Kyle extends Rdb4oModel")
    files.should include("public class Stan extends Rdb4oModel")
  end

end
