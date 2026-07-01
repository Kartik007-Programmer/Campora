
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import mypackage.DAO;
import java.io.IOException;

@WebServlet("/delete-event")
public class DeleteEventServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int eventId = Integer.parseInt(idParam);
                DAO dao = new DAO();
                boolean success = dao.deleteEvent(eventId);

                if (success) {
                    response.sendRedirect("AddEventServlet?message=Event+Deleted+Successfully");
                } else {
                    response.sendRedirect("AddEventServlet?error=Failed+to+Delete+Event");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AddEventServlet?error=Invalid+Event+ID");
            }
        } else {
            response.sendRedirect("AddEventServlet?error=Event+ID+Missing");
        }
    }
}
