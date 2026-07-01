
import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import mypackage.*;



@WebServlet("/StudentServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10) // 10MB

public class StudentServlet extends HttpServlet {
    private DAO studentDao;
    @Override
    public void init() throws ServletException {           
        studentDao = new DAO();

    }
     
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                  
        try {
        Student student = new Student();
        student.setStatus("PENDING");

        // First Name and Last Name
        student.setFirstName(req.getParameter("StudentFirstName"));
        student.setLastName(req.getParameter("StudentLastName"));

        // Mobile Number
        String mobileStr = req.getParameter("StudentMobile").replaceAll("\\D+", "");
        if (mobileStr.length() < 10) {
            throw new IllegalArgumentException("Mobile number must be at least 10 digits");
        }
        student.setMobile(Long.parseLong(mobileStr));

        // Email
        String email = req.getParameter("StudentEmail");
        if (email == null || !email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            handleError("Invalid email format", req, resp);
            return;
        }
        student.setEmail(email);

        // Check if email already exists
        if (studentDao.emailExists(email)) {
            handleError("Email already registered", req, resp);
            return;
        }

        // Password
        student.setPassword(req.getParameter("StudentPassword"));

        // Course, Qualification
        student.setCourse(req.getParameter("StudentCourse"));
        student.setQualification(req.getParameter("StudentQualification"));

        // DOB
        String dobStr = req.getParameter("StudentDOB");
        if (dobStr == null || dobStr.isEmpty()) {
            throw new IllegalArgumentException("Date of birth is required");
        }
        student.setDob(Date.valueOf(dobStr));

        // Gender
        student.setGender(req.getParameter("StudentGender"));

        // Last Year Percentage
        student.setLastYearPercentage(Double.parseDouble(req.getParameter("StudentLYP")));

        // Address
        student.setAddressLine1(req.getParameter("StudentAddressLine1"));
        student.setAddressLine2(req.getParameter("StudentAddressLine2"));
        student.setLandmark(req.getParameter("StudentLandmark"));
        student.setPincode(req.getParameter("StudentPincode"));
        student.setState(req.getParameter("StudentState"));
        student.setCity(req.getParameter("StudentCity"));

        // Remember Me (checkbox might be null if unchecked)
        student.setRememberMe(req.getParameter("StudentRemember") != null);

        // Photo Upload
        Part filePart = req.getPart("StudentPhoto");
        if (filePart != null && filePart.getSize() > 0) {
            if (filePart.getSize() > 4 * 1024 * 1024) {
                throw new ServletException("File size exceeds 4MB limit");
            }
            try (InputStream is = filePart.getInputStream()) {
                student.setPhoto(is.readAllBytes());
            }
        }

        // Save to DB
        if (studentDao.addStudent(student)) {
            req.setAttribute("StudentFirstName", student.getFirstName());
            req.getRequestDispatcher("success.jsp").forward(req, resp);
        } else {
            handleError("Registration failed. Please try again.", req, resp);
        }
        } catch (SQLException e) {
            e.printStackTrace(); // Add this line
            handleError("Database error occurred. Please try again later.", req, resp);    
        } catch (NumberFormatException e) {
            handleError("Invalid number format: " + e.getMessage(), req, resp);
        } catch (IllegalArgumentException e) {
            handleError("Invalid input: " + e.getMessage(), req, resp);
        } catch (Exception e) {
            handleError("System error: " + e.getMessage(), req, resp);
        }
    }

    private void handleError(String message, HttpServletRequest req, 
        HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("error", message);
        req.getRequestDispatcher("StudentForm.jsp").forward(req, resp);
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("StudentForm.jsp");
    }
 
}