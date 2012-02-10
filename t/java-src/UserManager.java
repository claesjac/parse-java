package bookletski;

import java.util.List;
import java.util.LinkedList;
import java.sql.*;

public final class UserManager {
    private static UserManager singleton;

    private UserManager() {
    }

    public static synchronized UserManager getInstance() {
        if (singleton == null) {
            singleton = new UserManager();
        }

        return singleton;
    }
    
    public boolean contains(String login) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            c = DbConnection.getConnection();
            ps = c.prepareStatement("SELECT login FROM users WHERE login = ?");
            ps.setString(1, login);

            rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }

        return false;
    }

    public User get(String login) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User u = null;
        
        try {
            c = DbConnection.getConnection();
            ps = c.prepareStatement("SELECT id, login, password, email, name FROM users WHERE login = ?");
            ps.setString(1, login);

            rs = ps.executeQuery();
            if (rs.next()) {
                u = new User();
                u.setId(new Integer(rs.getInt(1)));
                u.setLogin(rs.getString(2));
                u.setPassword(rs.getString(3));
                u.setEmail(rs.getString(4));
                u.setName(rs.getString(5));
            }
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }

        return u;
    }
    
    public boolean authenticate(String login, String password) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            c = DbConnection.getConnection();
            ps = c.prepareStatement("SELECT 1 FROM users WHERE login = ? and password = ?");
            ps.setString(1, login);
            ps.setString(2, password);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                return true;
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
                if (ps != null) {
                    ps.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }

        return false;        
    }

    public User create(String login, String password, String email, String name) throws SQLException {
        Connection c = null;
        PreparedStatement ps = null;

        try {
            c = DbConnection.getConnection();
            ps = c.prepareStatement("INSERT INTO users (login, password, email, name) VALUES(?, ?, ?, ?)");
            ps.setString(1, login);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, name);

            ps.execute();
        }
        catch (SQLException e) {
            throw e;
        }
        finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (c != null) {
                    c.close();
                }
            }
            catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        
        return get(login);
    }

    public List findUsersWithEmail(String email) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List l = new LinkedList();
        
        try {
            c = DbConnection.getConnection();
            ps = c.prepareStatement("SELECT id, login, password, email, name FROM users WHERE email = ?");
            ps.setString(1, email);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(new Integer(rs.getInt(1)));
                u.setLogin(rs.getString(2));
                u.setPassword(rs.getString(3));
                u.setEmail(rs.getString(4));
                u.setName(rs.getString(5));
                l.add(u);
            }
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
            return new LinkedList();
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
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
}
