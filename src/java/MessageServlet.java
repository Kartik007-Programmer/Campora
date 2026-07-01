
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import mypackage.*;


@WebServlet("/MessageServlet")
public class MessageServlet extends HttpServlet {
    private DAO messageDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new DAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
       
        // Check if this is an AJAX request to mark message as viewed
        String messageIdParam = req.getParameter("messageId");
        
         if (messageIdParam != null && !messageIdParam.trim().isEmpty()) {
            // This is an AJAX call to mark message as viewed
            handleMarkAsViewed(req, resp);
        } else {
            // This is a regular form submission to send a new message
            handleMessageSubmission(req, resp);
        }
    }
    
    private void handleMessageSubmission(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String subject = req.getParameter("subject");
        String messageText = req.getParameter("message");

        Message message = new Message();
        message.setFullName(fullName);
        message.setEmail(email);
        message.setSubject(subject);
        message.setMessage(messageText);

        PrintWriter out = resp.getWriter();
        HttpSession session = req.getSession();
        try {
            boolean status = messageDAO.insertMessage(message);
            if(status){
                session.setAttribute("MessageSuccess", "Message Sent Successfully...");
                session.setMaxInactiveInterval(5);
                resp.sendRedirect("index.jsp");
            } else {
                session.setAttribute("MessageFailed", "Sending Message Failed!");
                session.setMaxInactiveInterval(5);
                resp.sendRedirect("index.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("MessageFailed", "Database error: " + e.getMessage());
            session.setMaxInactiveInterval(5);
            resp.sendRedirect("index.jsp");
        } 
    }
    
    private void handleMarkAsViewed(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        
        try {
            String messageIdParam = req.getParameter("messageId");
            int messageId = Integer.parseInt(messageIdParam);
            
            // Mark the message as viewed
            boolean success = messageDAO.markMessageAsViewed(messageId);
            
            // Return simple JSON response
            if (success) {
                out.print("{\"success\": true, \"message\": \"Message marked as viewed\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to mark message as viewed\"}");
            }
            
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Invalid message ID\"}");
            e.printStackTrace();
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Database error\"}");
            e.printStackTrace();
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Unexpected error\"}");
            e.printStackTrace();
        } finally {
            out.flush();
        }
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle GET request for marking message as viewed (optional)
        String messageIdParam = req.getParameter("messageId");
        
        if (messageIdParam != null && !messageIdParam.trim().isEmpty()) {
            // Also allow GET requests for simplicity
            handleMarkAsViewed(req, resp);
        } else {
            resp.sendRedirect("ViewAllMessage.jsp");
        }   
    }
}
