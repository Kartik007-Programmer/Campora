import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import mypackage.*;

@WebServlet("/ViewTeacherServlet")
public class ViewTeacherServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DAO dao = new DAO();
            int id = Integer.parseInt(request.getParameter("id"));
            String searchQuery = request.getParameter("searchQuery");
            int HighlightID = Integer.parseInt(request.getParameter("highlightId"));

            Teacher teacher = dao.getTeacherById(id);

            if (teacher != null) {
                request.setAttribute("teacher", teacher);
                request.setAttribute("searchQuery", searchQuery); // Pass search query
             
                response.sendRedirect("view_teacher.jsp?searchQuery="+searchQuery+"&highlightId="+HighlightID);
            }
        } catch (Exception e) {
            // Error handling
        }

    }
}