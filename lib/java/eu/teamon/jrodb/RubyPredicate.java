package eu.teamon.jrodb;

import com.db4o.query.*;

public abstract class RubyPredicate extends com.db4o.query.Predicate<JrodbModel> {
    public boolean match(JrodbModel obj) {
        //System.out.println("sprawdzam..");
        //return true;
        return rubyMatch(obj);
    }

    public abstract boolean rubyMatch(JrodbModel obj);
}
