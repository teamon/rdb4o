package app.models.java;

import com.jrodb.JrodbModel;

public class Person extends JrodbModel {
  public Person() {}

  private String name;
  private int age;
  private String[] colors;

  public void setName(String name) { this.name = name; }
  public String getName() { return this.name; }
  public void setAge(int age) { this.age = age; }
  public int getAge() { return this.age; }
  public void setColors(String[] colors) { this.colors = colors; }
  public String[] getColors() { return this.colors; }

}
