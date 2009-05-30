package app.models.java;

import com.rdb4o.Rdb4oModel;

public class Dog extends Rdb4oModel {

  public Dog() {
      // Set all stirng empty and all integers to 0
  }
  
  private String _name;
  public void setName(String name) { this._name = name; }
  public String getName() { return this._name; }

  private Person _owner;
  public void setOwner(Person owner) { this._owner = owner; }
  public Person getOwner() { return this._owner; }

  
}
