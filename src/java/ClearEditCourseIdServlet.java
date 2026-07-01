import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ClearEditCourseIdServlet")
public class ClearEditCourseIdServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Clear the editCourseId from session
        request.getSession().removeAttribute("editCourseId");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}