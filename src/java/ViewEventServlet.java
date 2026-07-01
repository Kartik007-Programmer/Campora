import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import mypackage.*;

@WebServlet("/ViewEventServlet")
public class ViewEventServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DAO dao = new DAO();
            int id = Integer.parseInt(request.getParameter("id"));
            String searchQuery = request.getParameter("searchQuery");
            Event event = dao.getEventById(id);
            
            if (event != null) {
                request.setAttribute("event", event);
                request.setAttribute("searchQuery", searchQuery);
                response.sendRedirect("view_events.jsp?searchQuery="+searchQuery);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }
}