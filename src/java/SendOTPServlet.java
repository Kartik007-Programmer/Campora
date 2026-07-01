
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
import jakarta.servlet.http.HttpSession;
import mypackage.DAO;


@WebServlet("/SendOTPServlet")
public class SendOTPServlet extends HttpServlet {

    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String URL = DAO.getUrl();
        String USER = DAO.getUser();
        String PASSWORD = DAO.getPassword();
        String email = req.getParameter("email");

        // Step 1: Check if email exists in users table
        boolean emailExists = false;

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD)) {
            PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM students WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            emailExists = rs.next(); // true if email is found
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!emailExists) {
            // Email not registered, show error
            resp.getWriter().println("This email is not registered in our system.");
            return;
        }

        // Step 2: Generate OTP
        String otp = String.format("%06d", new Random().nextInt(999999));
        Timestamp expiryTime = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // 5 minutes

        // Step 3: Store OTP in DB
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD)) {
            PreparedStatement ps = con.prepareStatement("REPLACE INTO password_reset_tokens (email, otp, expiration) VALUES (?, ?, ?)");
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.setTimestamp(3, expiryTime);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Step 4: Send OTP via Email
        final String from = "kartiksirabatti009@gmail.com";
        final String password = "tinozbcnehbtusbq"; // Use App Password (NOT your Gmail password)

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Password Reset OTP");
            message.setText("Your OTP code is: " + otp + "\nIt is valid for 5 minutes.");

            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }


        // Step 5: Store timestamp in session for countdown timer
        HttpSession session1 = req.getSession();
        session1.setAttribute("otpGeneratedTime", System.currentTimeMillis());

        // Step 6: Redirect to OTP verification page
        boolean isResend = req.getParameter("resent") != null;
        resp.sendRedirect("pages/regiseterlogin_page/verify-otp.jsp?email=" + email + (isResend ? "&resent=true" : ""));
    
    }

    
}
