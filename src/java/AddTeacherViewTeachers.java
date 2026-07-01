
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import mypackage.Course;
import mypackage.DAO;
import mypackage.Teacher;

@WebServlet("/AddTeacherViewTeachers")
@MultipartConfig(maxFileSize = 1024 * 1024 * 20) 

public class AddTeacherViewTeachers extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            DAO courseDAO = new DAO();
            List<Teacher> teachers = courseDAO.getAllTeachers();
            req.setAttribute("teachers", teachers);
      
            // Forward success/error messages
            if (req.getParameter("success") != null) {
                req.setAttribute("success", req.getParameter("success"));
            }
            if (req.getParameter("error") != null) {
                req.setAttribute("error", req.getParameter("error"));
            }
            
            req.getRequestDispatcher("add_teacher.jsp").forward(req, resp);
            
          } catch (SQLException e) {
            throw new ServletException("Database error", e);
         }              
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
     try {  
        String fullname = req.getParameter("TeacherFullname");
        String email = req.getParameter("TeacherEmail");
        long phone = Long.parseLong(req.getParameter("TeacherPhone"));
        String subject = req.getParameter("TeacherSubject");
        String qualification = req.getParameter("TeacherQualification");
        String gender = req.getParameter("TeacherGender");
        String password = req.getParameter("TeacherPassword");
        String status = "Active";
   
        Part filePartImg = req.getPart("TeacherProfile_image");
        if (filePartImg.getSize() > 1024 * 1024 * 20) { // 2MB limit
           req.setAttribute("error", "Image size must be less than 2MB");
           req.getRequestDispatcher("TeacherForm.jsp").forward(req, resp);
        return;
        }
        
        InputStream fileContent = filePartImg.getInputStream();
        byte[] TeacherProfile_image = fileContent.readAllBytes();

        // Create Teacher object
        Teacher TeacherObj = new Teacher();
        TeacherObj.setFullName(fullname);
        TeacherObj.setEmail(email);
        TeacherObj.setPhone(phone);
        TeacherObj.setSubject(subject);
        TeacherObj.setQualification(qualification);
        TeacherObj.setGender(gender);
        TeacherObj.setPassword(password);
        TeacherObj.setProfileImage(TeacherProfile_image);
        TeacherObj.setStatus(status);

        // Save course data into the database
        DAO courseDAO = new DAO();
        courseDAO.addTeacher(TeacherObj);
        
        List<Teacher> teachers = courseDAO.getAllTeachers();
        req.setAttribute("teachers", teachers);
        req.getRequestDispatcher("add_teacher.jsp").forward(req, resp);
        
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("pages/error_page/error.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "System error: " + e.getMessage());
            req.getRequestDispatcher("pages/error_page/error.jsp").forward(req, resp);
        }
    }
       

}
