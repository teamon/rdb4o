package app.models.java;

import com.rdb4o.Rdb4oModel;

public class Dog extends Rdb4oModel {
  public Dog() {}

  String name;
  Person owner;

  public void setName(String name) { this.name = name; }
  public String getName() { return this.name; }
  public void setOwner(Person owner) { this.owner = owner; }
  public Person getOwner() { return this.owner; }

}
