package eu.teamon.jrodb.neodatis;

import eu.teamon.jrodb.JrodbModel;
import org.neodatis.odb.core.query.nq.SimpleNativeQuery;

public abstract class RubyPredicate {
    public boolean match(Object obj) {
        //System.out.println("predicate...");
        //return true;
        return rubyMatch(obj);
    }

    public abstract boolean rubyMatch(Object obj);
}
