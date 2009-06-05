package app.models.java;

import com.rdb4o.Rdb4oModel;

public class Person extends Rdb4oModel {
  public Person() {}

  private String name;
  private int age;
  private String[] colors;
  private Cat[] cats;

  public void setName(String name) { this.name = name; }
  public String getName() { return this.name; }
  public void setAge(int age) { this.age = age; }
  public int getAge() { return this.age; }
  public void setColors(String[] colors) { this.colors = colors; }
  public String[] getColors() { return this.colors; }
  public void setCats(Cat[] cats) { this.cats = cats; }
  public Cat[] getCats() { return this.cats; }

}
