package bookletski;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DbConnection {
    static {
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        }
        catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/bookletski", "bookletski", "bookletski");
    }
}
