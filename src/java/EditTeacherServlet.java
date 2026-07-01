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
import mypackage.Teacher;
import mypackage.DAO;

@WebServlet("/EditTeacherServlet")
@MultipartConfig
public class EditTeacherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DAO teacherDAO = new DAO();
        try {
            // Load all teachers first
            List<Teacher> teacherList = teacherDAO.getAllTeachers();
            req.setAttribute("teacherList", teacherList);
            req.setAttribute("teachers", teacherList); 

            
            // Check if specific teacher is selected
            String teacherIdStr = req.getParameter("id");
            if (teacherIdStr != null && !teacherIdStr.isEmpty()) {
                try {
                    int teacherId = Integer.parseInt(teacherIdStr);
                    Teacher selectedTeacher = teacherDAO.getTeacherById(teacherId);
                    
                    if (selectedTeacher != null) {
                        // Store the teacher ID in session to trigger edit mode
                        req.getSession().setAttribute("editTeacherId", teacherId);
                        // Add the teacher to attributes
                        req.setAttribute("teacher", selectedTeacher);
                    } else {
                        req.getSession().setAttribute("error", "Teacher not found");
                    }
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("error", "Invalid teacher ID");
                }
            }
            
            // Forward to manage_teachers.jsp (or your teacher management page)
            req.getRequestDispatcher("manage_teacher.jsp").forward(req, resp);
            
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Database error: " + e.getMessage());
            resp.sendRedirect("manage_teacher.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int teacherId = Integer.parseInt(req.getParameter("teacherId"));
            String fullName = req.getParameter("teacherFullName");
            String email = req.getParameter("teacherEmail");
            long phone = Long.parseLong(req.getParameter("teacherPhone"));
            String subject = req.getParameter("teacherSubject");
            String qualification = req.getParameter("teacherQualification");
            String gender = req.getParameter("teacherGender");
            String password = req.getParameter("teacherPassword");
            String status = req.getParameter("teacherStatus");

            // Get existing teacher first
            DAO teacherDAO = new DAO();
            Teacher existingTeacher = teacherDAO.getTeacherById(teacherId);
            if (existingTeacher == null) {
                throw new ServletException("Teacher not found");
            }

            Teacher teacher = new Teacher();
            teacher.setId(teacherId);
            teacher.setFullName(fullName);
            teacher.setEmail(email);
            teacher.setPhone(phone);
            teacher.setSubject(subject);
            teacher.setQualification(qualification);
            teacher.setGender(gender);
            teacher.setPassword(password);
            teacher.setStatus(status);

            // Handle image update
            Part filePart = req.getPart("teacherProfileImage");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream fileContent = filePart.getInputStream()) {
                    teacher.setProfileImage(fileContent.readAllBytes());
                }
            } else {
                // Keep existing image
                teacher.setProfileImage(existingTeacher.getProfileImage());
            }

            boolean updated = teacherDAO.updateTeacher(teacher);
            
            if (updated) {
                req.getSession().setAttribute("success", "Teacher updated successfully");
            } else {
                req.getSession().setAttribute("error", "Failed to update teacher");
            }

        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid number format: " + e.getMessage());
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Database error: " + e.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Error updating teacher: " + e.getMessage());
        }
        
        resp.sendRedirect("manage_teacher.jsp");
    }
}