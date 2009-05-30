package app.models.java;

import com.rdb4o.Rdb4oModel;

public class Person extends Rdb4oModel {

  public Person() {
      // Set all stirng empty and all integers to 0
  }
  
  private String _name;
  public void setName(String name) { this._name = name; }
  public String getName() { return this._name; }

  private int _age;
  public void setAge(int age) { this._age = age; }
  public int getAge() { return this._age; }

  
}
