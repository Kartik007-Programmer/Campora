
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import mypackage.DAO;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    
        String URL = DAO.getUrl();
        String USER = DAO.getUser();
        String PASSWORD = DAO.getPassword();
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD)) {
            PreparedStatement ps = con.prepareStatement("UPDATE students SET password = ? WHERE email = ?");
            ps.setString(1, password); // Ideally hash password
            ps.setString(2, email);
            ps.executeUpdate();

            // Optionally delete OTP record
            PreparedStatement ps2 = con.prepareStatement("DELETE FROM password_reset_tokens WHERE email = ?");
            ps2.setString(1, email);
            ps2.executeUpdate();

            resp.setContentType("text/html");
            PrintWriter out = resp.getWriter();
            out.println("<html><body>");
            out.println("<script type='text/javascript'>");
            out.println("alert('Password successfully updated.');");
            out.println("window.location.href = 'pages/regiseterlogin_page/LoginForm.jsp';"); // Optional: redirect after alert
            out.println("</script>");
            out.println("</body></html>");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
    
}
