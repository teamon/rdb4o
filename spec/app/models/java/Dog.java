package app.models.java;

import com.rdb4o.Rdb4oModel;

public class Dog extends Rdb4oModel {
  public Dog() {}

  private String name;

  public void setName(String name) { this.name = name; }
  public String getName() { return this.name; }

}
