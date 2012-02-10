package bookletski;

import java.util.Set;
import java.util.TreeSet;
import java.util.Map;
import java.util.List;
import java.util.LinkedList;
import java.sql.*;

public final class BookManager {
    private static BookManager singleton;

    private BookManager() {
    }
    
    public static synchronized BookManager getInstance() {
        if (singleton == null) {
            singleton = new BookManager();
        }

        return singleton;
    }

    public Book get(int id) {
        Book b = new Book();
        Connection c = null;
        Statement s = null;
        ResultSet rs = null;

        try {
            c = DbConnection.getConnection();
            s = c.createStatement();
            rs = s.executeQuery("SELECT id, title, isbn, authors, difficulty, description FROM books WHERE id = " + id);
            
            /* Get data */
            if (rs.next()) {
                b.setId(new Integer(rs.getInt(1)));
                b.setTitle(rs.getString(2));
                b.setISBN(rs.getString(3));
                b.setAuthors(rs.getString(4));
                b.setDifficulty(rs.getString(5));
                b.setDescription(rs.getString(6));
                
                rs.close();
                
                /* Fetch categories */
                rs = s.executeQuery("SELECT categories.topic FROM categories INNER JOIN book_category_map ON id = category_id WHERE book_id = " + id);
                Set cs = new TreeSet();
                while (rs.next()) {
                    cs.add(rs.getString(1));
                }
                b.setCategories(cs);
            }
        }
        catch (SQLException e) {
            System.err.println(e.getMessage());
            return new Book();
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (s != null) {
                    s.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
            }
        }

        return b;
    }
    
    public List find(Map query) {
        List l = new LinkedList();

        Connection c = null;
        Statement s = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            c = DbConnection.getConnection();

            /* Quick search */
            if (query.isEmpty()) {
                s = c.createStatement();
                rs = s.executeQuery("SELECT id, title, isbn, authors FROM books ORDER BY title ASC");
                while (rs.next()) {
                    Book b = new Book();
                    b.setId(new Integer(rs.getInt(1)));
                    b.setTitle(rs.getString(2));
                    b.setISBN(rs.getString(3));
                    b.setAuthors(rs.getString(4));
                    l.add(b);
                }
            }
            else {
                String isbn       = (String) query.get("isbn");
                String title      = (String) query.get("title");
                String author     = (String) query.get("author");
                String difficulty = (String) query.get("difficulty");
                String category   = (String) query.get("category");

                /* Construct query */
                String sqlQuery = "SELECT id, title, isbn, authors FROM books";
                if (category != null) {
                    sqlQuery += " INNER JOIN book_category_map ON id = book_id";
                }

                sqlQuery += " WHERE 1 = 1";

                int placeholder = 1;
                int isbn_pos, title_pos, author_pos, difficulty_pos, category_pos;
                isbn_pos = title_pos = author_pos = difficulty_pos = category_pos = 0;
                
                if (isbn != null && isbn.length() > 0) {
                    sqlQuery += " AND isbn LIKE ?";
                    isbn = "%" + isbn + "%";
                    isbn_pos = placeholder++;
                }
                if (title != null && title.length() > 0) {
                    sqlQuery += " AND title LIKE ?";
                    title = "%" + title + "%";
                    title_pos = placeholder++;
                }
                if (author != null && author.length() > 0) {
                    sqlQuery += " AND authors LIKE ?";
                    author = "%" + author + "%";
                    author_pos = placeholder++;
                }
                if (difficulty != null && difficulty.length() > 0) {
                    sqlQuery += " AND difficulty = ?";
                    difficulty_pos = placeholder++;
                }
                if (category != null && category.length() > 0) {
                    sqlQuery += " AND category_id = (SELECT categories.id FROM categories WHERE categories.topic = ?)";
                    category_pos = placeholder++;
                }
                
                sqlQuery += " ORDER BY title ASC";

                ps = c.prepareStatement(sqlQuery);
                
                if (isbn_pos > 0) {
                    ps.setString(isbn_pos, isbn);
                }
                if (title_pos > 0) {
                    ps.setString(title_pos, title);
                }
                if (author_pos > 0) {
                    ps.setString(author_pos, author);
                }
                if (difficulty_pos > 0) {
                    ps.setString(difficulty_pos, difficulty);
                }
                if (category_pos > 0) {
                    ps.setString(category_pos, category);
                }
                
                rs = ps.executeQuery();
                
                while (rs.next()) {
                    Book b = new Book();
                    b.setId(new Integer(rs.getInt(1)));
                    b.setTitle(rs.getString(2));
                    b.setISBN(rs.getString(3));
                    b.setAuthors(rs.getString(4));
                    l.add(b);
                }
            }
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new IllegalArgumentException(e.getMessage());
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (s != null) {
                    rs.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        
        return l;
    }

    public Set getUniqueCategories() {
        Set categories = new TreeSet();
        Connection c = null;
        Statement s = null;
        ResultSet rs = null;

        try {
            c = DbConnection.getConnection();
            s = c.createStatement();
            rs = s.executeQuery("SELECT topic FROM categories");
            while (rs.next()) {
                categories.add(rs.getString(1));
            }
        }
        catch (SQLException e) {
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (s != null) {
                    s.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
            }
        }

        return categories;
    }

    public Set getUniqueDifficulties() {
        Set difficulties = new TreeSet();
        Connection c = null;
        Statement s = null;
        ResultSet rs = null;
        try {
            c = DbConnection.getConnection();
            s = c.createStatement();
            rs = s.executeQuery("SELECT DISTINCT(difficulty) FROM books");
            while (rs.next()) {
                difficulties.add(rs.getString(1));
            }
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (s != null) {
                    s.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
            }
        }

        return difficulties;
    }
}
