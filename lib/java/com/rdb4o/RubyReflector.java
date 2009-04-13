package com.rdb4o;

// import com.db4o.reflect.*;
import com.db4o.*;
import com.db4o.reflect.jdk.*;

public class RubyReflector extends JdkReflector {

    public RubyReflector() {
		super(Db4o.class.getClassLoader());
		System.out.println("RubyReflector: flame on!");
    }

	// public Object deepClone(Object obj){
	// 	System.out.println("-> deepClone");
	// 	return super.deepClone(obj);
	// }

}