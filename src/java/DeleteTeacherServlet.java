import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import mypackage.DAO;


@WebServlet("/DeleteTeacherServlet")
public class DeleteTeacherServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int teacherId = Integer.parseInt(req.getParameter("id"));
        try {
            DAO dao = new DAO();
            boolean deleted = dao.deleteTeacher(teacherId);

            if (deleted) {
                resp.sendRedirect("AddTeacherViewTeachers?success=Teacher+deleted+successfully");
            } else {
                resp.sendRedirect("AddTeacherViewTeachers?error=Failed+to+delete+teacher");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("AddTeacherViewTeachers?error=Database+error");
        } 
    }   
}
