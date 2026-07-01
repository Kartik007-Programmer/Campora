import mypackage.Admin;
import mypackage.DAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.SQLException;

@WebServlet("/DeleteAdminServlet")
public class DeleteAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        
        try {
            // Get admin ID to delete
            int adminId = Integer.parseInt(request.getParameter("adminId"));
            String confirmPassword = request.getParameter("confirmPassword");
            String fileName = request.getParameter("fileName");

             // Get current admin username from session (as String)
            String adminUsername = (String) session.getAttribute("admin");
            if (adminUsername == null || adminUsername.isEmpty()) {
                out.println("<script>alert('Session expired! Please login again.'); window.location='LoginForm.jsp';</script>");
                return;
            }
            
            DAO dao = new DAO();
            
            // Get current admin object from database using username
            Admin currentAdmin = dao.getAdminByUsername(adminUsername);
            
            if (currentAdmin == null) {
                out.println("<script>alert('Session expired! Please login again.'); window.location='LoginForm.jsp';</script>");
                return;
            }
            
            // Prevent deletion of current logged-in admin
            if (currentAdmin.getAdminId() == adminId) {
                out.println("<script>alert('You cannot delete your own account!'); window.history.back();</script>");
                return;
            }
            
            // Prevent deletion of main admin (ID = 1)
            if (adminId == 1) {
                out.println("<script>alert('Cannot delete main administrator!'); window.history.back();</script>");
                return;
            }
            
            // Optional: Confirm with password for extra security
            if (confirmPassword != null && !confirmPassword.isEmpty()) {
                if (!confirmPassword.equals(currentAdmin.getAdminPassword())) {
                    out.println("<script>alert('Incorrect password! Deletion cancelled.'); window.history.back();</script>");
                    return;
                }
            }
            
            // Delete admin
            boolean success = dao.deleteAdmin(adminId);
            
            if (success) {
              // Use session to show alert and redirect to ViewAllAdmins.
                session.setAttribute("DeleteSuccess", "Admin deleteed successfully!");
                session.setMaxInactiveInterval(5);
                response.sendRedirect(fileName);
             } else {
                session.setAttribute("DeleteFailed", "Failed to delete admin!");
                session.setMaxInactiveInterval(5); 
                response.sendRedirect(fileName);
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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        doPost(request, response);
        
    }
}