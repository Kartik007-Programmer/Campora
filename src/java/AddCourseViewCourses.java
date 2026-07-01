
import mypackage.DAO;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import mypackage.Course;
import java.sql.*;
import jakarta.servlet.annotation.MultipartConfig;


@WebServlet("/AddCourseViewCourses")
@MultipartConfig(maxFileSize = 1024 * 1024 * 20) 
public class AddCourseViewCourses extends HttpServlet  {
   

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    DAO courseDAO = new DAO();
    String idParam = req.getParameter("id");

    try {
        // If an "id" parameter is present, fetch and show that course only
        if (idParam != null && idParam.matches("\\d+")) {
            int id = Integer.parseInt(idParam);
            Course course = courseDAO.getCourseById(id);

            if (course != null) {
                List<Course> courses = new ArrayList<>();
                courses.add(course);
                req.setAttribute("courses", courses);
                req.setAttribute("highlightId", id); // used in JSP for highlighting
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found");
                return;
            }

        } else {
            // Otherwise, fetch and display all courses
            List<Course> courses = courseDAO.getAllCourses();
            req.setAttribute("courses", courses);
        }

        // Forward any messages
        if (req.getParameter("success") != null) {
            req.setAttribute("success", req.getParameter("success"));
        }
        if (req.getParameter("error") != null) {
            req.setAttribute("error", req.getParameter("error"));
        }

        // Forward to display page
        req.getRequestDispatcher("view_courses.jsp").forward(req, resp);

    } catch (SQLException e) {
        throw new ServletException("Database error", e);
    } catch (Exception e) {
        e.printStackTrace();
        resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
    }
     }
    

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException {
        try {
        String courseName = req.getParameter("courseName");
        double courseFees = Double.parseDouble(req.getParameter("courseFees"));
        double courseStar = Double.parseDouble(req.getParameter("courseStar"));
        String courseDescription = req.getParameter("courseDescription");
        int durationMonths = Integer.parseInt(req.getParameter("durationMonths"));
        String courseCategory = req.getParameter("courseCategory");
        int maxStudents = Integer.parseInt(req.getParameter("maxStudents"));


        Part filePartImg = req.getPart("courseImg");
        if (filePartImg.getSize() > 1024 * 1024 * 20) { // 2MB limit
           req.setAttribute("error", "Image size must be less than 2MB");
           req.getRequestDispatcher("index.jsp").forward(req, resp);
        return;
        }
        
            InputStream fileContent = filePartImg.getInputStream();
            byte[] courseImg = fileContent.readAllBytes();

            // Create Course object
            Course CourseObj = new Course();
            CourseObj.setName(courseName);
            CourseObj.setImg(courseImg); // Set the image bytes
            CourseObj.setFees(courseFees);
            CourseObj.setStar(courseStar);
            CourseObj.setDescription(courseDescription);
            CourseObj.setDurationMonths(durationMonths);
            CourseObj.setCategory(courseCategory);
            CourseObj.setMaxStudents(maxStudents);

            
            // Save course data into the database
            DAO courseDAO = new DAO();
            courseDAO.addCourse(CourseObj);
            
            List<Course> courses = courseDAO.getAllCourses();
            req.setAttribute("courses", courses);
            req.getRequestDispatcher("displayCourses.jsp").forward(req, resp);
       
            
            // Redirect to display.jsp to show the updated list of courses             
    //        resp.sendRedirect("displayCourses.jsp");
            
            
    } catch (SQLException e) {
        req.setAttribute("error", "Database error: " + e.getMessage());
        req.getRequestDispatcher("pages/error_page/error.jsp").forward(req, resp);
    } catch (Exception e) {
        req.setAttribute("error", "System error: " + e.getMessage());
        req.getRequestDispatcher("pages/error_page/error.jsp").forward(req, resp);
    }
  }
 
}