
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.util.List;
import mypackage.Event;
import mypackage.DAO;

@WebServlet("/AddEventServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10) // 10MB

public class AddEventServlet extends HttpServlet {
    private DAO EventDAO;
    
    @Override
    public void init() throws ServletException {
        EventDAO = new DAO();
    }

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Event> event = EventDAO.getAllEvents();
            req.setAttribute("Event", event);
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
        }
        // Forward success/error messages
        if (req.getParameter("success") != null) {
            req.setAttribute("success", req.getParameter("success"));
        }
        if (req.getParameter("error") != null) {
            req.setAttribute("error", req.getParameter("error"));
        }
        req.getRequestDispatcher("ViewEvents.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Read form fields
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String dateStr = req.getParameter("date");
            String priceStr = req.getParameter("price");        
            String category = req.getParameter("category");

            // Validate date
            if (dateStr == null || dateStr.trim().isEmpty()) {
                req.setAttribute("error", "Date is required");
                req.getRequestDispatcher("EventForm.jsp").forward(req, resp);
                return;
            }

            // Parse date and price
            Date date = Date.valueOf(dateStr);
            double price = Double.parseDouble(priceStr);

            // Read image as byte array
            Part imagePart = req.getPart("image");
            byte[] imageBytes = null;
            try (InputStream inputStream = imagePart.getInputStream()) {
                imageBytes = inputStream.readAllBytes();
            }

            // Prepare Event object
            Event event = new Event();
            event.setTitle(title);
            event.setDescription(description);
            event.setDate(date);
            event.setPrice(price);
            event.setCategory(category); 
            event.setImage(imageBytes);

            // Save to DB
            
            if (EventDAO.addEvent(event)) {
                resp.sendRedirect("AddEventServlet?success=Event added successfully");
            } else {
                req.setAttribute("error", "Failed to add event. Please try again.");
                req.getRequestDispatcher("EventForm.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid price format");
            req.getRequestDispatcher("EventForm.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("EventForm.jsp").forward(req, resp);
        }

    }
      
}
