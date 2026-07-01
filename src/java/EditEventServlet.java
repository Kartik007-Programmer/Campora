import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.Date;
import java.util.List;
import mypackage.Event;
import mypackage.DAO;

@WebServlet("/EditEventServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10) // 10MB
public class EditEventServlet extends HttpServlet {

    private DAO eventDAO;

    @Override
    public void init() throws ServletException {
        eventDAO = new DAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle session clearing
        if ("true".equals(req.getParameter("clearSession"))) {
            req.getSession().removeAttribute("editEventId");
            resp.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        try {
            List<Event> allEvents = eventDAO.getAllEvents();
            req.setAttribute("allEvents", allEvents);

            String idParam = req.getParameter("id");
            String source = req.getParameter("source");
            
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                Event event = eventDAO.getEventById(id);
                
                if (event != null) {
                    req.setAttribute("event", event);
                    req.getSession().setAttribute("editEventId", id);
                    
                    if ("manage".equals(source)) {
                        req.getRequestDispatcher("manage_events.jsp").forward(req, resp);
                        return;
                    }
                }
            }
            
            req.getRequestDispatcher("manage_events.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading events.");
            req.getRequestDispatcher("manage_events.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String eventIdStr = req.getParameter("eventId");
        int eventId = 0;
        
        try {
            // --- Parameter Parsing ---
            eventId = Integer.parseInt(eventIdStr);
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String dateStr = req.getParameter("date");
            String category = req.getParameter("category");
            double price = Double.parseDouble(req.getParameter("price"));
            Date date = Date.valueOf(dateStr);

            // --- Fetch Existing Event to get old image if no new one is provided ---
            Event existingEvent = eventDAO.getEventById(eventId);
            if (existingEvent == null) {
                req.getSession().setAttribute("error", "Event with ID " + eventId + " not found.");
                resp.sendRedirect(req.getContextPath() + "manage_events.jsp");
                return;
            }
            
            // --- Create Event Object with Updated Data ---
            Event event = new Event();
            event.setId(eventId);
            event.setTitle(title);
            event.setDescription(description);
            event.setDate(date);
            event.setCategory(category);
            event.setPrice(price);
            
            // --- Handle File Upload ---
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // A new image was uploaded
                try (InputStream fileContent = filePart.getInputStream()) {
                    event.setImage(fileContent.readAllBytes());
                }
            } else {
                // No new image, retain the existing one
                event.setImage(existingEvent.getImage());
            }

            // --- Update in Database ---
            boolean success = eventDAO.updateEvent(event);
            
            if (success) {
                req.getSession().setAttribute("success", "Event updated successfully!");
                // Store the course ID to highlight it after redirect
                req.getSession().setAttribute("editEventId", eventIdStr);
            } else {
                req.getSession().setAttribute("error", "Failed to update event. No changes were made.");
            }

        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid data format provided. Please check your inputs.");
            e.printStackTrace();
        } catch (Exception e) {
            req.getSession().setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            e.printStackTrace();
        }

        // --- Redirect back to the manage page, with highlighting ---
        String redirectURL = "manage_events.jsp";
        if (eventId > 0) {
            redirectURL += "?highlightId=" + eventId;
        }
        resp.sendRedirect(redirectURL);
    }
}