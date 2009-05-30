package app.models.java;

import com.rdb4o.Rdb4oModel;

public class Cat extends Rdb4oModel {

  public Cat() {
      // Set all stirng empty and all integers to 0
  }
  
  private String _name;
  public void setName(String name) { this._name = name; }
  public String getName() { return this._name; }

  private String _color;
  public void setColor(String color) { this._color = color; }
  public String getColor() { return this._color; }

  private int _age;
  public void setAge(int age) { this._age = age; }
  public int getAge() { return this._age; }

  private Person _person;
  public void setPerson(Person person) { this._person = person; }
  public Person getPerson() { return this._person; }

  
}
