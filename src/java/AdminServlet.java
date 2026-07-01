import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import mypackage.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private final DAO studentDao = new DAO();
    private Admin admin = new Admin();

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false); // don't create new session

        String action = req.getParameter("action");

        try {
            if (session != null && Boolean.TRUE.equals(session.getAttribute("admin"))) {
                List<Student> students = studentDao.getAllStudents();
                req.setAttribute("students", students);
                req.getRequestDispatcher("adminDashboard.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("LoginForm.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, "Database error in doGet", ex);
            req.setAttribute("error", "Database error occurred.");
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        try {
            if ("login".equals(action)) {
                handleLogin(req, resp, session);
            } else if ("updateStatus".equals(action)) {
                handleStatusUpdate(req, resp, session);
            } else {
                req.getRequestDispatcher("LoginForm.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, "Database error in doPost", ex);
            req.setAttribute("error", "An internal error occurred.");
            req.getRequestDispatcher("pages/error_page/error.jsp").forward(req, resp);
        }
    }
    
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException, ServletException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");


        admin = studentDao.getAdminByUsername(username); // Gets admin by username

        if (admin != null && admin.getAdminPassword().equals(password)) {
            session.setAttribute("admin",username );
            resp.sendRedirect("Admin_penal.jsp");
          
        } else {
            req.setAttribute("error", "Invalid username or password");
            RequestDispatcher rd = req.getRequestDispatcher("LoginForm.jsp");
            rd.forward(req, resp);
        }
    }

        private void handleStatusUpdate(HttpServletRequest req, HttpServletResponse resp, HttpSession session) 
            throws SQLException, IOException, ServletException {

            try {
                int studentId = Integer.parseInt(req.getParameter("studentId"));
                String status = req.getParameter("status");

                boolean success = false;

                if ("APPROVED".equalsIgnoreCase(status)) {
                    success = studentDao.approveStudentIfPossible(studentId);
                    if (success) {
                        session.setAttribute("success", "Student approved successfully.");
                    } else {
                        session.setAttribute("error", "Approval limit reached for this course.");
                    }
                } else {
                    // Directly update for REJECTED or PENDING
                    success = studentDao.updateStatus(studentId, status);
                    if (success) {
                        session.setAttribute("success", "Status updated to " + status);
                    } else {
                        session.setAttribute("error", "Failed to update status.");
                    }
                }

                // Redirect back to the manage students page instead of forwarding to the servlet
                resp.sendRedirect("manage_students.jsp");

            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid student ID format.");
                resp.sendRedirect(req.getContextPath() + "manage_students.jsp");
            }
        }
}
