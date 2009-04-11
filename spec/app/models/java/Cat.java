package app.models.java;
import com.rdb4o.Rdb4oModel;

public class Cat extends Rdb4oModel {

  public Cat () {
      // Set all stirng empty and all integers to 0
  }

	private String name;
	private String color;
	private int age;
	private Person owner;
          
  public void setName(String name) { this.name = name; }
  public String getName() { return this.name; }

	public void setColor(String color) { this.color = color; }
	public String getColor() { return this.color; }

  public void setAge(int age) { this.age = age; }
  public int getAge() { return this.age; }

  public void setOwner(Person owner) { this.owner = owner; }
  public Person getOwner() { return this.owner; }
}