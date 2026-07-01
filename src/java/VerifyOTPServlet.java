import java.sql.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import mypackage.DAO;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String otp = req.getParameter("otp"); // Changed to match JSP
        
        System.out.println("DEBUG - Email: " + email); // Debug logging
        System.out.println("DEBUG - OTP: " + otp); // Debug logging

        try (Connection con = DriverManager.getConnection(DAO.getUrl(), DAO.getUser(), DAO.getPassword())) {
            String sql = "SELECT * FROM password_reset_tokens WHERE email = ? AND otp = ? AND expiration > NOW()";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, otp);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // OTP is valid - redirect to password reset
                resp.sendRedirect("pages/regiseterlogin_page/reset-passwordForm.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
            } else {
                // Invalid OTP - show error
                req.setAttribute("error", "Invalid or expired OTP code");
                req.getRequestDispatcher("pages/regiseterlogin_page/verify-otp.jsp?email=" + URLEncoder.encode(email, "UTF-8")).forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred");
            req.getRequestDispatcher("pages/regiseterlogin_page/verify-otp.jsp?email=" + URLEncoder.encode(email, "UTF-8")).forward(req, resp);
        }
    }
}