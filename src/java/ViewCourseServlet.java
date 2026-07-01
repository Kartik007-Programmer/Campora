
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import mypackage.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ViewCourseServl"
        + "et")
public class ViewCourseServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DAO dao = new DAO();
            int id = Integer.parseInt(request.getParameter("id"));
            int HighlightID = Integer.parseInt(request.getParameter("highlightId"));
            Course course = dao.getCourseById(id);

            if (course != null) {
                request.setAttribute("course", course);
                // Pass search query if it exists
                          String searchQuery = request.getParameter("searchQuery");
                if (searchQuery != null) {
          request.setAttribute("searchQuery", searchQuery);
               
                response.sendRedirect("view_courses.jsp?searchQuery="+searchQuery+"&highlightId="+HighlightID);
                }
       
                } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Add logging
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
}
