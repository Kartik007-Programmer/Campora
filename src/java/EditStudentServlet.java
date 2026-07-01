
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
import java.util.logging.Level;
import java.util.logging.Logger;
import mypackage.DAO;
import mypackage.Student;


@MultipartConfig
@WebServlet("/edit-student")
public class EditStudentServlet extends HttpServlet {
    private DAO dao;

    @Override
    public void init() {
        dao = new DAO();
    }

protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String idParam = request.getParameter("id");
    if (idParam != null) {
        int id = Integer.parseInt(idParam);

        DAO dao = new DAO();
        Student student;
       
        try {
            student = dao.getStudentById(id);
            List<Student> studentlist = dao.getAllStudents();
            request.setAttribute("student", student);
            request.setAttribute("studentList", studentlist);
        } catch (SQLException ex) {
            Logger.getLogger(EditStudentServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

       
        request.getRequestDispatcher("edit-student-form.jsp").forward(request, response);
    } else {
        request.getRequestDispatcher("manage_students.jsp").forward(request, response);
        
    }
}

   @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Student s = new Student();
        int Id = Integer.parseInt(req.getParameter("id"));
        s.setId(Id);
        s.setFirstName(req.getParameter("firstName"));
        s.setLastName(req.getParameter("lastName"));
        s.setEmail(req.getParameter("email"));
        s.setMobile(Long.parseLong(req.getParameter("mobile")));
        s.setPassword(req.getParameter("password"));
        s.setGender(req.getParameter("gender"));
        s.setDob(java.sql.Date.valueOf(req.getParameter("dob")));
        s.setCourse(req.getParameter("course"));
        s.setQualification(req.getParameter("qualification"));
        s.setLastYearPercentage(Double.parseDouble(req.getParameter("lastYearPercentage")));
        s.setAddressLine1(req.getParameter("addressLine1"));
        s.setAddressLine2(req.getParameter("addressLine2"));
        s.setLandmark(req.getParameter("landmark"));
        s.setPincode(req.getParameter("pincode"));
        s.setState(req.getParameter("state"));
        s.setCity(req.getParameter("city"));
        s.setRememberMe("on".equals(req.getParameter("rememberMe")));
        s.setStatus(req.getParameter("status"));
        
        // Get existing course first
        DAO studentDAO = new DAO();
        
    try {
            Student existingstudent = studentDAO.getStudentById(Id);
            if (existingstudent == null) {
                throw new ServletException("student not found");
            }
      
            // Handle image update
            Part filePart = req.getPart("studentImg");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream fileContent = filePart.getInputStream()) {
                    s.setPhoto(fileContent.readAllBytes());
                }
            } else {
                // Keep existing image
                s.setPhoto(existingstudent.getPhoto());
            }
            
            // Checking the Student was Update or not 
            boolean ok = dao.updateStudent(s);
            if (ok) {
                req.getSession().setAttribute("success", "Student updated successfully");
                resp.sendRedirect(req.getContextPath() + "/manage_students.jsp?highlightId=" + s.getId());
                           return; 
            } else {
                req.setAttribute("error", "Update failed");
                doGet(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
     // req.getRequestDispatcher("Admin_penal.jsp").forward(req, resp);
    }
}























































































