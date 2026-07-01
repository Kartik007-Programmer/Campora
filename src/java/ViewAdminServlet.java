import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import mypackage.*;

@WebServlet("/ViewAdminServlet")
public class ViewAdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DAO dao = new DAO();
            int id = Integer.parseInt(request.getParameter("id"));
            Admin admin = dao.getAdminById(id);

            if (admin != null) {
                request.setAttribute("admin", admin);
                // Pass search query if it exists
                String searchQuery = request.getParameter("searchQuery");
                if (searchQuery != null) {
                    request.setAttribute("searchQuery", searchQuery);
                }
                request.getRequestDispatcher("ViewAdmin.jsp")
                       .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Admin not found");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Add logging
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
}
