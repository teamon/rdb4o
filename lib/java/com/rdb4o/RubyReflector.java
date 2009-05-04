package com.rdb4o;

import com.db4o.internal.*;
import com.db4o.reflect.*;

public class RubyReflector implements Reflector {
	private Reflector _parent;
	private ReflectorConfiguration _config;
	
	// public RubyReflector(ClassLoader classLoader){
	// 	this(new ClassLoaderJdkLoader(classLoader));
	// }
	// 
	// /**
	//      * Constructor
	//      * @param classLoader class loader
	//      */
	// public RubyReflector(JdkLoader classLoader){
	// 	_classLoader = classLoader;
	// 	_config = null;
	// 	
	// }
	// 
	// // private RubyReflector(JdkLoader classLoader, ReflectorConfiguration config){
	// // // 	_classLoader = classLoader;
	// // // 	_config = config;
	// // }
	// // 
	
	public void setParent(Reflector reflector){
		_parent = reflector;
	}
	
	public ReflectorConfiguration configuration(){
		return _config;
	}
	
	public boolean isCollection(ReflectClass candidate) {
		return false;
	}
	
	public ReflectClass forObject(Object a_object) {
		
	}
	
	public ReflectClass forClass(Class clazz){

	}
	
	public ReflectClass forName(String className) {
		
	}
	
}
