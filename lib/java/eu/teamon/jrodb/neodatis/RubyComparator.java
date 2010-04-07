package eu.teamon.jrodb.neodatis;

import eu.teamon.jrodb.JrodbModel;

public abstract class RubyComparator {
	public int compare(JrodbModel first, JrodbModel second) {
        return rubyCompare(first, second);
    }

    public abstract int rubyCompare(JrodbModel first, JrodbModel second);
}