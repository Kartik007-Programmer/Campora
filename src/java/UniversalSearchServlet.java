
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import mypackage.*;


@WebServlet("/UniversalSearchServlet")
public class UniversalSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String searchQuery = req.getParameter("searchQuery");
        
        // Check if search query is empty or only whitespace
        if (searchQuery == null || searchQuery.trim().isEmpty()) {
            // Return empty results without performing search
            req.setAttribute("results", new ArrayList<>());
            req.setAttribute("searchQuery", "");
            req.setAttribute("totalResults", 0);
            req.setAttribute("countTeachers", 0);
            req.setAttribute("countCourses", 0);
            req.setAttribute("countEvents", 0);
            req.setAttribute("countStudents", 0);
            req.setAttribute("countAdmins", 0);
            
            req.getRequestDispatcher("universalSearchResults_1.jsp").forward(req, resp);
            return;
        }
        searchQuery = searchQuery.trim();

        try {
            DAO dao = new DAO();

            List<SearchResult> results = new ArrayList<>();


            // Add action items FIRST (so they appear at the top)
            if (searchQuery.toLowerCase().contains("add") || searchQuery.toLowerCase().contains("new")) {
                if (searchQuery.toLowerCase().contains("course")) {
                    results.add(createAddActionResult("course", "Add New Course", "add_courses.jsp"));
                }
                if (searchQuery.toLowerCase().contains("teacher")) {
                    results.add(createAddActionResult("teacher", "Add New Teacher", "add_teacher.jsp"));
                }
                if (searchQuery.toLowerCase().contains("event")) {
                    results.add(createAddActionResult("event", "Add New Event", "add_events.jsp"));
                }
                if (searchQuery.toLowerCase().contains("student")) {
                    results.add(createAddActionResult("student", "Add New Student", "add_students.jsp"));
                }
            }
            
for (Teacher t : dao.searchTeachers(searchQuery)) {
    results.add(new SearchResult(
        String.valueOf(t.getId()),
        "teacher",
        t.getFullName(),
        t.getSubject(),
        t.getEmail(),
        t.getImageBase64(),
        "", "", // meta1/meta2 not used
        "ViewTeacherServlet?id=" + t.getId() + "&searchQuery=" + URLEncoder.encode(searchQuery, "UTF-8") + "&highlightId=" + t.getId()
    ));
}

            // Courses
for (Course c : dao.searchCourses(searchQuery)) {
    results.add(new SearchResult(
        String.valueOf(c.getId()),
        "course",
        c.getName(),
        c.getDescription(),
        "", // No email
        c.getImageBase64(),
        "$" + c.getFees(),
        c.getDurationMonths()+ " months",
        "ViewCourseServlet?id=" + c.getId() + "&searchQuery=" + URLEncoder.encode(searchQuery, "UTF-8") + "&highlightId=" + c.getId()
    ));
}

            // Events
            for (Event e : dao.searchEvents(searchQuery)) {
                results.add(new SearchResult(
                    String.valueOf(e.getId()),
                    "event",
                    e.getTitle(),
                    e.getCategory(),
                    "", // No email
                    e.getImageBase64(),
                    "$" + e.getPrice(),
                    new java.text.SimpleDateFormat("MMM dd, yyyy").format(e.getDate()),
                    "ViewEventServlet?id=" + e.getId() + "&searchQuery=" + URLEncoder.encode(searchQuery, "UTF-8") + "&highlightId=" + e.getId()
                ));
            }

            // Students
            for (Student s : dao.searchStudents(searchQuery)) {
                results.add(new SearchResult(
                    String.valueOf(s.getId()),
                    "student",
                    s.getFirstName() + " " + s.getLastName(),
                    s.getCourse(),
                    s.getEmail(),
                    s.getImageBase64(),
                    s.getStatus(),
                    "", // meta2 unused
                    "ViewStudentServlet?id=" + s.getId() + "&searchQuery=" + URLEncoder.encode(searchQuery, "UTF-8") + "&highlightId=" + s.getId()
                ));
            }

            // Admins
            for (Admin a : dao.searchAdmins(searchQuery)) {
                results.add(new SearchResult(
                    String.valueOf(a.getAdminId()),
                    "admin",
                    a.getAdminName(),
                    "@" + a.getAdminUsername(),
                    "", // No email
                    a.getImageBase64(),
                    "Administrator",
                    "", // meta2
                    "ViewAdminServlet?id=" + a.getAdminId()
                ));
            }


            req.setAttribute("countTeachers", dao.searchTeachers(searchQuery).size());
            req.setAttribute("countCourses", dao.searchCourses(searchQuery).size());
            req.setAttribute("countEvents", dao.searchEvents(searchQuery).size());
            req.setAttribute("countStudents", dao.searchStudents(searchQuery).size());
            req.setAttribute("countAdmins", dao.searchAdmins(searchQuery).size());

            req.setAttribute("results", results);
            req.setAttribute("searchQuery", searchQuery);
            req.setAttribute("totalResults", results.size());

            req.getRequestDispatcher("universalSearchResults_1.jsp").forward(req, resp);
            
        } catch (SQLException e) {
            Logger.getLogger(UniversalSearchServlet.class.getName())
                  .log(Level.SEVERE, "SQL Error during search", e);
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        } catch (Exception e) {
            Logger.getLogger(UniversalSearchServlet.class.getName())
                  .log(Level.SEVERE, "Unexpected error during search", e);
            req.setAttribute("error", "Unexpected error: " + e.getMessage());
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }
    
    private SearchResult createAddActionResult(String type, String title, String url) {
        return new SearchResult(
            "add-" + type,       // ID
            "action",           // Special type
            title,               // Title
            "Click to create a new " + type, // Description
            "",                 // No email
            "",                 // No image
            "Action",           // Meta1
            "",                 // Meta2
            url                // Target URL
        );
    }    

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
         doGet(req, resp);
    }
    
}
    
