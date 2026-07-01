
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mypackage.DAO;
import mypackage.Student;

@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {
    private DAO studentDao;

    @Override
    public void init() throws ServletException {
        studentDao = new DAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("username");
        String password = req.getParameter("password");
        
        try {
            Student student = studentDao.getStudentByEmailAndPassword(email, password);
            
            if (student != null) {
                HttpSession session = req.getSession();
                session.setAttribute("student", student);
                RequestDispatcher rd = req.getRequestDispatcher("StudentDashboard.jsp");
                rd.forward(req, resp);          
            } else {
                req.setAttribute("error", "Invalid student credentials");
                RequestDispatcher rd = req.getRequestDispatcher("pages/regiseterlogin_page/LoginForm.jsp");
                rd.forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred. Please try again.");
            req.getRequestDispatcher("pages/regiseterlogin_page/LoginForm.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("student") != null) {
            resp.sendRedirect("StudentDashboard.jsp");
        } else {
            session.setAttribute("admin", true);
            req.getRequestDispatcher("pages/regiseterlogin_page/LoginForm.jsp").forward(req, resp);
        }
    }   
       
}
