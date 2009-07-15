package com.rdb4o;

import com.db4o.query.*;

public abstract class RubyComparator implements com.db4o.query.QueryComparator<Rdb4oModel> {
    public int compare(Rdb4oModel first, Rdb4oModel second) {
        return rubyCompare(first, second);
    }

    public abstract int rubyCompare(Rdb4oModel first, Rdb4oModel second);
}
