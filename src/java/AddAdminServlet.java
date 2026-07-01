import mypackage.Admin;
import mypackage.DAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/AddAdminServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 20) 

public class AddAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Get form parameters
            String adminName = request.getParameter("adminName");
            String adminUsername = request.getParameter("adminUsername");
            String adminPassword = request.getParameter("adminPassword");
            Part photoPart = request.getPart("adminPhoto");
            
            // Validate input
            if (adminName == null || adminName.trim().isEmpty() ||
                adminUsername == null || adminUsername.trim().isEmpty() ||
                adminPassword == null || adminPassword.trim().isEmpty()) {
                
                out.println("<script>alert('Please fill all required fields!'); window.history.back();</script>");
                return;
            }
            
            DAO dao = new DAO();
            
            // Check if username already exists
            if (dao.adminUsernameExists(adminUsername)) {
                out.println("<script>alert('Username already exists! Please choose another username.'); window.history.back();</script>");
                return;
            }
            
            // Read photo if provided
            byte[] adminPhoto = null;
            if (photoPart.getSize() > 1024 * 1024 * 20) { // 2MB limit
                out.println("<script>alert('Image size must be less than 2MB'); window.history.back();</script>");
                request.getRequestDispatcher("index.jsp").forward(request, response);
             return;
             }
            
            
            if (photoPart != null && photoPart.getSize() > 0) {
                adminPhoto = photoPart.getInputStream().readAllBytes();
            }
            
            // Create Admin object
            Admin admin = new Admin();
            admin.setAdminName(adminName);
            admin.setAdminUsername(adminUsername);
            admin.setAdminPassword(adminPassword);
            if (adminPhoto != null) {
                admin.setAdminPhoto(adminPhoto);
            }
            
            // Add admin to database
            boolean success = dao.addAdmin(admin);
            
            if (success) {
                Admin newAdmin = dao.getAdminByUsername(adminUsername);
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Admin added successfully!");
                response.sendRedirect("ViewAdmin.jsp?id="+newAdmin.getAdminId());
                        
            } else {
                out.println("<script>alert('Failed to add admin!'); window.history.back();</script>");
            }
            
        } catch (SQLException e) {
            
            e.printStackTrace();
            out.println("<script>alert('Database error occurred: " + e.getMessage() + "'); window.history.back();</script>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error occurred: " + e.getMessage() + "'); window.history.back();</script>");
        } finally {
            out.close();
        }
    }
}