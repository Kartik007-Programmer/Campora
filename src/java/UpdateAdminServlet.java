import mypackage.Admin;
import mypackage.DAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/UpdateAdminServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 50    // 50 MB
)
public class UpdateAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        
        try {
            // Get parameters
            int adminId = Integer.parseInt(request.getParameter("adminId"));
            String adminName = request.getParameter("adminName");
            String adminUsername = request.getParameter("adminUsername");
            String adminPassword = request.getParameter("adminPassword");
            Part photoPart = request.getPart("adminPhoto");
            String deletePhoto = request.getParameter("deletePhoto");
            
            // Validate input
            if (adminName == null || adminName.trim().isEmpty() ||
                adminUsername == null || adminUsername.trim().isEmpty()) {
                
                out.println("<script>alert('Name and username are required!'); window.history.back();</script>");
                return;
            }
            
            DAO dao = new DAO();
            
            // Check if username already exists for another admin
            Admin existingAdmin = dao.getAdminById(adminId);
            if (existingAdmin == null) {
                out.println("<script>alert('Admin not found!'); window.history.back();</script>");
                return;
            }
            
            // Check if username is being changed and if it already exists for another admin
            if (!existingAdmin.getAdminUsername().equals(adminUsername)) {
                if (dao.adminUsernameExists(adminUsername)) {
                    out.println("<script>alert('Username already exists! Please choose another username.'); window.history.back();</script>");
                    return;
                }
            }
            
            // Read photo if provided
            byte[] adminPhoto = null;
            if (photoPart != null && photoPart.getSize() > 0) {
                // New photo uploaded
                adminPhoto = photoPart.getInputStream().readAllBytes();
            } else if ("true".equals(deletePhoto)) {
                // User wants to delete existing photo
                adminPhoto = new byte[0];
            } else {
                // Keep existing photo
                adminPhoto = existingAdmin.getAdminPhoto();
            }
            
            // Create Admin object
            Admin admin = new Admin();
            admin.setAdminId(adminId);
            admin.setAdminName(adminName);
            admin.setAdminUsername(adminUsername);
            
            // Only update password if provided
            if (adminPassword != null && !adminPassword.trim().isEmpty()) {
                admin.setAdminPassword(adminPassword);
            } else {
                admin.setAdminPassword(existingAdmin.getAdminPassword());
            }
            
            admin.setAdminPhoto(adminPhoto);
            
            // Update admin
            boolean success = dao.updateAdmin(admin);
            
            if (success) {
                
                // Store success message in session and redirect
                session.setAttribute("successMessage", "Admin updated successfully!");
                response.sendRedirect("ViewAdmin.jsp?id=" + adminId);
            } else {
                // Store error message in session and redirect back
                session.setAttribute("errorMessage", "Failed to update admin!");
                response.sendRedirect("EditAdminProfile.jsp?id=" + adminId);
            }
            
        } catch (NumberFormatException e) {
            out.println("<script>alert('Invalid admin ID!'); window.history.back();</script>");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('Database error: " + e.getMessage() + "'); window.history.back();</script>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error occurred: " + e.getMessage() + "'); window.history.back();</script>");
        } finally {
            out.close();
        }
    }
}