import java.sql.*;
import java.util.*;
public class Connection_Database {
    private static final String URL = "jdbc:mysql://localhost:3306/kartik_coures";
    private static final String USER = "root";
    private static final String PASSWORD = "";

        public static void main(String[] args) {
        
        Connection connection = null;

        try {
            // Establish connection to the database
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            if (connection != null) {
                System.out.println("Connected to the database successfully!");
            } else {
                System.out.println("Failed to make connection!");
            }
        } catch (SQLException e) {
            // Handle exceptions
            System.out.println("Connection failed!");
            e.printStackTrace();
        } finally {
            // Close the connection
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
