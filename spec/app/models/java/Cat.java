package app.models.java;

import com.rdb4o.Rdb4oModel;

public class Cat extends Rdb4oModel {
  public Cat() {}

  private String name;
  private String color;
  private int age;
  private Person person;

  public void setName(String name) { this.name = name; }
  public String getName() { return this.name; }
  public void setColor(String color) { this.color = color; }
  public String getColor() { return this.color; }
  public void setAge(int age) { this.age = age; }
  public int getAge() { return this.age; }
  public void setPerson(Person person) { this.person = person; }
  public Person getPerson() { return this.person; }

}
