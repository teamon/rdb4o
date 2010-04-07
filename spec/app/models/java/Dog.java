package app.models.java;

import com.jrodb.JrodbModel;

public class Dog extends JrodbModel {
  public Dog() {}

  private String name;

  public void setName(String name) { this.name = name; }
  public String getName() { return this.name; }

}
