import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.DriverManager;
import mypackage.DAO;

@WebServlet("/delete-student")
public class DeleteStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String idParam = request.getParameter("id");
            DAO d = new DAO();
        String URL = d.getUrl();
        String USER = d.getUser();
        String PASSWORD = d.getPassword();
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("students.jsp?error=Missing+student+ID");
        return;
    }

    int studentId = Integer.parseInt(idParam);

    try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);) {
        String sql = "DELETE FROM students WHERE id = ?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setInt(1, studentId);

        int rowsDeleted = statement.executeUpdate();

        if (rowsDeleted > 0) {
            response.sendRedirect("StudentServlet?message=Student+deleted+successfully");
        } else {
            response.sendRedirect("StudentServlet?error=Student+not+found");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("StudentServlet?error=Database+error");
    }
}

}
