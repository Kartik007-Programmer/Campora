import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import mypackage.*;

@WebServlet("/ViewStudentServlet")
public class ViewStudentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DAO dao = new DAO();
            int id = Integer.parseInt(request.getParameter("id"));
            String searchQuery = request.getParameter("searchQuery");
            int HighlightID = Integer.parseInt(request.getParameter("highlightId"));
            Student student = dao.getStudentById(id);
            
            if (student != null) {
                request.setAttribute("student", student);
                request.setAttribute("searchQuery", searchQuery);
                
                response.sendRedirect("view_students.jsp?searchQuery="+searchQuery+"&highlightId="+HighlightID);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Student not found");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }
}