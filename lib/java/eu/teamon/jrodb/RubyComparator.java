package eu.teamon.jrodb;

import com.db4o.query.*;

public abstract class RubyComparator implements com.db4o.query.QueryComparator<JrodbModel> {
    public int compare(JrodbModel first, JrodbModel second) {
        return rubyCompare(first, second);
    }

    public abstract int rubyCompare(JrodbModel first, JrodbModel second);
}
