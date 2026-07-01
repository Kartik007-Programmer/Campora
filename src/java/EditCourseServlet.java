import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.sql.*;
import java.util.*;
import mypackage.Course;
import mypackage.DAO;

@WebServlet("/EditCourseServlet")
@MultipartConfig
public class EditCourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DAO courseDAO = new DAO();
        try {
            // Load all courses first
            List<Course> courseList = courseDAO.getAllCourses();
            req.setAttribute("courseList", courseList);
            
            // Check if specific course is selected
            String courseIdStr = req.getParameter("id");
            if (courseIdStr != null && !courseIdStr.isEmpty()) {
                try {
                    int courseId = Integer.parseInt(courseIdStr);
                    Course selectedCourse = courseDAO.getCourseById(courseId);
                    
                    if (selectedCourse != null) {
                        // Store the course ID in session to trigger edit mode
                        req.getSession().setAttribute("editCourseId", courseId);
                        // Add the course to attributes
                        req.setAttribute("course", selectedCourse);
                    } else {
                        req.getSession().setAttribute("error", "Course not found");
                    }
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("error", "Invalid course ID");
                }
            }
            
            // Forward to manage_courses.jsp
            req.getRequestDispatcher("manage_courses.jsp").forward(req, resp);
            
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Database error: " + e.getMessage());
            resp.sendRedirect("manage_courses.jsp");
        }
    }

@Override 
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    try {
        System.out.println("Starting course update...");
        
        // Validate parameters
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        String name = req.getParameter("courseName");
        double fees = Double.parseDouble(req.getParameter("courseFees"));
        double star = Double.parseDouble(req.getParameter("courseStar"));
        String description = req.getParameter("courseDescription");
        int durationMonths = Integer.parseInt(req.getParameter("durationMonths"));
        String category = req.getParameter("courseCategory");
        int maxStudents = Integer.parseInt(req.getParameter("maxStudents"));

        System.out.println("Parameters received: " + name + ", " + fees + ", " + star + ", " + durationMonths + ", " + category + ", " + maxStudents);
        
        // Get existing course first
        DAO courseDAO = new DAO();
        Course existingCourse = courseDAO.getCourseById(courseId);
        if (existingCourse == null) {
            throw new ServletException("Course not found with ID: " + courseId);
        }
        
        // Create updated course
        Course course = new Course();
        course.setId(courseId);
        course.setName(name);
        course.setFees(fees);
        course.setStar(star);
        course.setDescription(description);
        course.setDurationMonths(durationMonths);   
        course.setCategory(category);            
        course.setMaxStudents(maxStudents);      

        // Handle image update
        Part filePart = req.getPart("courseImg");
        if (filePart != null && filePart.getSize() > 0) {
            System.out.println("New image provided, updating image...");
            try (InputStream fileContent = filePart.getInputStream()) {
                course.setImg(fileContent.readAllBytes());
            }
        } else {
            System.out.println("No new image, keeping existing image...");
            // Keep existing image
            course.setImg(existingCourse.getImg());
        }
        
        // Update course
        System.out.println("Attempting to update course in database...");
        boolean updated = courseDAO.updateCourse(course);
        
        if (updated) {
            System.out.println("Course updated successfully!");
            req.getSession().setAttribute("success", "Course updated successfully");
            // Store the course ID to highlight it after redirect
            req.getSession().setAttribute("editCourseId", courseId);
        } else {
            System.out.println("Failed to update course - no rows affected");
            req.getSession().setAttribute("error", "Failed to update course - no changes made");
        }
    } catch (NumberFormatException e) {
        System.err.println("Number format error: " + e.getMessage());
        req.getSession().setAttribute("error", "Invalid number format: " + e.getMessage());
    } catch (SQLException e) {
        System.err.println("SQL error: " + e.getMessage());
        System.err.println("SQL State: " + e.getSQLState());
        System.err.println("Error Code: " + e.getErrorCode());
        e.printStackTrace();
        req.getSession().setAttribute("error", "Database error: " + e.getMessage());
    } catch (Exception e) {
        System.err.println("General error: " + e.getMessage());
        e.printStackTrace();
        req.getSession().setAttribute("error", "Error updating course: " + e.getMessage());
    }
    
    // Redirect back to manage courses page
    resp.sendRedirect(req.getContextPath() + "manage_courses.jsp");
}
}