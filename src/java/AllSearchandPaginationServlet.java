import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import mypackage.*;

@WebServlet("/AllSearchandPagination")
public class AllSearchandPaginationServlet extends HttpServlet {
    private final DAO dao = new DAO();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String type = request.getParameter("type");
        if (type == null) type = "courses"; // default fallback
        
        String search = request.getParameter("search");
        String pageParam = request.getParameter("page");
        
        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try { currentPage = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException e) { }
        }

        try {
            switch (type) {
                case "courses" -> {
                    handleCourses(request, search, currentPage, true);
                    request.getRequestDispatcher("/view_courses.jsp").forward(request, response);
                }
                case "courses-mg" -> {
                    handleCourses(request, search, currentPage, false);
                    request.getRequestDispatcher("/manage_courses.jsp").forward(request, response);
                }
                    
                case "events" -> {
                    handleEvents(request, search, currentPage, true);
                    request.getRequestDispatcher("/view_events.jsp").forward(request, response);
                }
                case "events-mg" -> {
                    handleEvents(request, search, currentPage, false);
                    request.getRequestDispatcher("/manage_events.jsp").forward(request, response);
                }    
                case "students" -> {
                    handleStudents(request, search, currentPage, true);
                    request.getRequestDispatcher("/view_students.jsp").forward(request, response);
                }
                case "students-mg" -> {
                    handleStudents(request, search, currentPage, false);
                    request.getRequestDispatcher("/manage_students.jsp").forward(request, response);
                }    
                case "teachers" -> {
                    handleTeachers(request, search, currentPage, true);
                    request.getRequestDispatcher("/view_teacher.jsp").forward(request, response);
                }
                
                case "teachers-mg" -> {
                    handleTeachers(request, search, currentPage, false);
                    request.getRequestDispatcher("/manage_teacher.jsp").forward(request, response);
                }                
                    
                default -> response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown view type");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error loading data: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 1. COURSES HANDLING (Using existing getAllCourses)
    private void handleCourses(HttpServletRequest request, String search, int currentPage, boolean IsPaginated) throws SQLException {
        List<Course> list = dao.getAllCourses();
        String catFilter = request.getParameter("categoryFilter");
        String ratFilter = request.getParameter("ratingFilter");
        String durFilter = request.getParameter("durationFilter");

        request.setAttribute("ccategories", dao.getAllCategoriesOfCourses(true));

        var stream = list.stream();
        if (search != null && !search.trim().isEmpty()) {
            String s = search.toLowerCase().trim();
            stream = stream.filter(c -> (c.getName() != null && c.getName().toLowerCase().contains(s)) ||
                                        (c.getCategory() != null && c.getCategory().toLowerCase().contains(s)) ||
                                        (c.getDescription() != null && c.getDescription().toLowerCase().contains(s)));
        }
        if (catFilter != null && !catFilter.trim().isEmpty()) {
            stream = stream.filter(c -> c.getCategory() != null && c.getCategory().equalsIgnoreCase(catFilter.trim()));
        }
        if (ratFilter != null && !ratFilter.trim().isEmpty()) {
            try { int r = Integer.parseInt(ratFilter.trim()); stream = stream.filter(c -> c.getStar() >= r); } catch(NumberFormatException e){}
        }
        if (durFilter != null && !durFilter.trim().isEmpty()) {
            String range = durFilter.trim();
            stream = stream.filter(c -> {
                int m = c.getDurationMonths();
                return "1-3".equals(range) ? (m >= 1 && m <= 3) : "4-6".equals(range) ? (m >= 4 && m <= 6) : 
                       "7-12".equals(range) ? (m >= 7 && m <= 12) : "12+".equals(range) ? (m > 12) : true;
            });
        }
        if(IsPaginated){
            paginate(request, stream.collect(Collectors.toList()), currentPage, "paginatedCourses");        
        }else{
            request.setAttribute("courses",stream.collect(Collectors.toList()));
        }
    }

    // 2. EVENTS HANDLING (Using existing getAllEvents)
    private void handleEvents(HttpServletRequest request, String search, int currentPage, boolean IsPaginated) throws SQLException {
        List<Event> list = dao.getAllEvents();
        String statusFilter = request.getParameter("statusFilter");
        String categoryFilter = request.getParameter("categoryFilter");
        Date today = new Date();
        request.setAttribute("today", today);

        List<String> uniqueCategories = list.stream()
                                        .map(Event::getCategory)
                                        .filter(c -> c != null && !c.trim().isEmpty())
                                        .distinct()
                                        .collect(Collectors.toList());
        request.setAttribute("category", uniqueCategories);
        
        var stream = list.stream();
        if (search != null && !search.trim().isEmpty()) {
            String s = search.toLowerCase().trim();
            stream = stream.filter(e -> (e.getTitle() != null && e.getTitle().toLowerCase().contains(s)) ||
                                        (e.getCategory()!= null && e.getCategory().toLowerCase().contains(s)) ||
                                        (e.getDescription() != null && e.getDescription().toLowerCase().contains(s)));
        }
        
        if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
            stream = stream.filter(e -> e.getCategory() != null && e.getCategory().equalsIgnoreCase(categoryFilter.trim()));
        }
        
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            stream = stream.filter(e -> {
                if (e.getDate() == null) return false;
                return "Upcoming".equalsIgnoreCase(statusFilter) ? e.getDate().after(today) : e.getDate().before(today);
            });
        }
        if(IsPaginated){
            paginate(request, stream.collect(Collectors.toList()), currentPage, "paginatedEvents");
        }else{
            request.setAttribute("events",stream.collect(Collectors.toList()));
        }
    }

    // 3. STUDENTS HANDLING (Using existing getAllStudents)
    private void handleStudents(HttpServletRequest request, String search, int currentPage, boolean IsPaginated) throws SQLException {
        List<Student> list = dao.getAllStudents();
        String genderFilter = request.getParameter("genderFilter");
        String courseFilter = request.getParameter("courseFilter");

        // Get courses for the filter dropdown
        request.setAttribute("courses", dao.getAllCourses());
        request.setAttribute("pendingStudents", dao.getPendingStudents());

        var stream = list.stream();
        if (search != null && !search.trim().isEmpty()) {
            String s = search.toLowerCase().trim();
            stream = stream.filter(st -> (st.getFirstName()!= null && st.getFirstName().toLowerCase().contains(s)) ||
                                         (st.getLastName()!= null && st.getLastName().toLowerCase().contains(s)) ||
                                         (st.getEmail() != null && st.getEmail().toLowerCase().contains(s)) ||
                                         (Long.toString(st.getMobile()) != null && Long.toString(st.getMobile()).contains(s)) ||
                                         (st.getCourse() != null && st.getCourse().toLowerCase().contains(s)));
        }
        if (genderFilter != null && !genderFilter.trim().isEmpty()) {
            stream = stream.filter(st -> st.getGender() != null && st.getGender().equalsIgnoreCase(genderFilter.trim()));
        }
        if (courseFilter != null && !courseFilter.trim().isEmpty()) {
            stream = stream.filter(st -> st.getCourse() != null && st.getCourse().equalsIgnoreCase(courseFilter.trim()));
        }
        
        if(IsPaginated){
            paginate(request, stream.collect(Collectors.toList()), currentPage, "paginatedStudents");
        }else{
            request.setAttribute("students",stream.collect(Collectors.toList()));
        }
    }

    // 4. TEACHERS HANDLING (Using existing getAllTeachers)
    private void handleTeachers(HttpServletRequest request, String search, int currentPage, boolean IsPaginated) throws SQLException {
        List<Teacher> list = dao.getAllTeachers();
        String genderFilter = request.getParameter("genderFilter");
        String statusFilter = request.getParameter("statusFilter");
        String subjectFilter = request.getParameter("subjectFilter");

        var stream = list.stream();
        if (search != null && !search.trim().isEmpty()) {
            String s = search.toLowerCase().trim();
            stream = stream.filter(t -> (t.getFullName() != null && t.getFullName().toLowerCase().contains(s)) ||
                                        (t.getEmail() != null && t.getEmail().toLowerCase().contains(s)) ||
                                        (t.getSubject() != null && t.getSubject().toLowerCase().contains(s)) ||
                                        (t.getQualification()!= null && t.getQualification().toLowerCase().contains(s)));
        }
        if (genderFilter != null && !genderFilter.trim().isEmpty()) {
            stream = stream.filter(t -> t.getGender() != null && t.getGender().equalsIgnoreCase(genderFilter.trim()));
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            stream = stream.filter(t -> t.getStatus() != null && t.getStatus().equalsIgnoreCase(statusFilter.trim()));
        }
        if (subjectFilter != null && !subjectFilter.trim().isEmpty()) { // Add this
            stream = stream.filter(t -> t.getSubject() != null && t.getSubject().equalsIgnoreCase(subjectFilter.trim()));
        }
        
        if(IsPaginated){
            paginate(request, stream.collect(Collectors.toList()), currentPage, "paginatedTeachers");
        }else{
            request.setAttribute("teachers",stream.collect(Collectors.toList()));
        }
    }

    // Universal Pagination Helper
    private void paginate(HttpServletRequest request, List<?> filteredList, int currentPage, String attributeName) {
        int totalItems = filteredList.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;

        int startIndex = (currentPage - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, totalItems);

        List<?> paginated = (totalItems > 0) ? filteredList.subList(startIndex, endIndex) : Collections.emptyList();

        request.setAttribute(attributeName, paginated);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("startItem", totalItems == 0 ? 0 : startIndex + 1);
        request.setAttribute("endItem", endIndex);
    }
}
