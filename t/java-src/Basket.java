package bookletski;

import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

public class Basket {
    Map basket;

    public Basket() {
        basket = new HashMap();
    }
    
    public boolean contains(Book book) {
        return basket.containsKey(book.getId());
    }

    public void add(Book book) {
        basket.put(book.getId(), book);
    }

    public void add(int id) {
        Book b = BookManager.getInstance().get(id);
        if (b != null) {
            basket.put(b.getId(), b);
        }
    }

    public void remove(Book book) {
        basket.remove(book.getId());
    }

    public void remove(int id) {
        Book b = BookManager.getInstance().get(id);
        if (b != null) {
            basket.remove(b.getId());
        }
    }

    public void clear() {
        basket.clear();
    }

    public boolean isEmpty() {
        return basket.isEmpty();
    }
    
    public Collection contents() {
        return basket.values();
    }
}
