
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import mypackage.DAO;

@WebServlet("/DeleteCourseServlet")
public class DeleteCourseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
         int courseId = Integer.parseInt(req.getParameter("courseId"));
         
         try {
            DAO courseDAO = new DAO();
            boolean deleted = courseDAO.deleteCourse(courseId);
            
            if (deleted) {
               resp.sendRedirect("AddCourseViewCourses?success=Course+deleted+successfully");
            } else {
               resp.sendRedirect("AddCourseViewCourses?error=Failed+to+delete+course");
            }
        
         } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("AddCourseViewCourses?error=Database+error");
        }
    }
     
}