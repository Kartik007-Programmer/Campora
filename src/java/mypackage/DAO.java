package mypackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class DAO {
    
    private static final String URL = "jdbc:mysql://localhost:3307/campora_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    static {
      try {
          Class.forName("com.mysql.cj.jdbc.Driver");
      } catch (ClassNotFoundException e) {
          throw new ExceptionInInitializerError("MySQL JDBC Driver not found "+e);
      }
    }

    // Static getter methods
    public static String getUrl() {
        return URL;
    }

    public static String getUser() {
        return USER;
    }

    public static String getPassword() {
        return PASSWORD;
    }

    // Method to add a course to database
    public void addCourse(Course course) throws SQLException {
        String sql = "INSERT INTO courses (name, image, fees, star, description, duration_months, category, max_students) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, course.getName());
            stmt.setBytes(2, course.getImg());
            stmt.setDouble(3, course.getFees());
            stmt.setDouble(4, course.getStar());
            stmt.setString(5, course.getDescription());
            stmt.setInt(6, course.getDurationMonths());
            stmt.setString(7, course.getCategory());
            stmt.setInt(8, course.getMaxStudents());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            // Log the exception details
            System.err.println("Error adding course: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();  // Print the stack trace for debugging
            throw e;  // Re-throw the exception so it can be handled upstream if necessary
        }        
    }

    // Method to retrieve all courses from the database
    public List<Course> getAllCourses() throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM courses";
        Course course = null;
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                course = new Course();
                course.setId(rs.getInt("id"));
                course.setName(rs.getString("name"));
                course.setImg(rs.getBytes("image"));
                course.setFees(rs.getDouble("fees"));
                course.setStar(rs.getDouble("star"));
                course.setDescription(rs.getString("description"));
                course.setDurationMonths(rs.getInt("duration_months"));
                course.setCategory(rs.getString("category"));
                course.setMaxStudents(rs.getInt("max_students"));

                courses.add(course);
            }
        } catch (SQLException e) {
            // Log the exception details
            System.err.println("Error fetching courses: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();  // Print the stack trace for debugging
            throw e;  // Re-throw the exception so it can be handled upstream if necessary
        }
        return courses;        
    }
    
    public boolean deleteCourse(int courseId) throws SQLException {
        String sql = "DELETE FROM courses WHERE id = ?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            int executed = stmt.executeUpdate();
            return executed > 0;
        }
    }
    
 public boolean updateCourse(Course course) throws SQLException {
    String sql = "UPDATE courses SET name=?, image=?, fees=?, star=?, description=?, duration_months=?, category=?, max_students=? WHERE id=?";

    try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
         PreparedStatement stmt = conn.prepareStatement(sql)) {
    
        System.out.println("Preparing update statement for course ID: " + course.getId());
        
        // Set all 9 parameters
        stmt.setString(1, course.getName());
        // Handle null image
        if (course.getImg() != null && course.getImg().length > 0) {
            stmt.setBytes(2, course.getImg());
        } else {
            stmt.setNull(2, Types.BLOB);
        }
        stmt.setDouble(3, course.getFees());
        stmt.setDouble(4, course.getStar());
        stmt.setString(5, course.getDescription());
        stmt.setInt(6, course.getDurationMonths());
        stmt.setString(7, course.getCategory());
        stmt.setInt(8, course.getMaxStudents());
        stmt.setInt(9, course.getId());
        
        System.out.println("Executing update...");
        int executed = stmt.executeUpdate();
        System.out.println("Rows affected: " + executed);
        
        return executed > 0;
    } catch (SQLException e) {
        System.err.println("SQL Error in updateCourse: " + e.getMessage());
        System.err.println("SQL State: " + e.getSQLState());
        System.err.println("Error Code: " + e.getErrorCode());
        throw e;
    }
}
    
    public Course getCourseById(int id) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id=?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {
            // retrun ID
            stmt.setInt(1, id);
            // fatch Data
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setName(rs.getString("name"));
                    course.setImg(rs.getBytes("image"));
                    course.setFees(rs.getDouble("fees"));
                    course.setStar(rs.getDouble("star"));
                    course.setDescription(rs.getString("description"));
                    course.setDurationMonths(rs.getInt("duration_months"));
                    course.setCategory(rs.getString("category"));
                    course.setMaxStudents(rs.getInt("max_students"));

                    return course;
                }
            }
        }
        return null;
    }

     public List<String> getAllCategoriesOfCourses(boolean Condition) throws SQLException {
        // Query the column definition to get ENUM values
        List<String> categories = new ArrayList<>();
        if(Condition){
            String sql = "SHOW COLUMNS FROM courses LIKE 'category'";
            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String type = rs.getString("Type"); 
                    type = type.substring(type.indexOf("(") + 1, type.lastIndexOf(")"));
                    String[] values = type.split(",");
                    for (String value : values) {
                        // Remove the single quotes around each enum value
                        categories.add(value.replace("'", "").trim());
                    }
                }
            }
        }else{
            String sql = "SELECT DISTINCT category FROM courses";
            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    categories.add(rs.getString("category"));
                }
            }
        }
        return categories;
    }

                         // Teachers  
     
    // Method to retrieve all Teachers from the database
    public List<Teacher> getAllTeachers() throws SQLException {
        List<Teacher> Teachers = new ArrayList<>();
        String sql = "SELECT * FROM teachers";
        Teacher teacher = null;
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                teacher = new Teacher();
                teacher.setId(rs.getInt("TeacherID"));
                teacher.setFullName(rs.getString("TeacherFullName"));
                teacher.setEmail(rs.getString("TeacherEmail"));
                teacher.setPhone(rs.getLong("TeacherPhone"));
                teacher.setSubject(rs.getString("TeacherSubject"));
                teacher.setQualification(rs.getString("TeacherQualification"));
                teacher.setGender(rs.getString("TeacherGender"));
                teacher.setPassword(rs.getString("TeacherPassword"));
                teacher.setProfileImage(rs.getBytes("TeacherProfileImage"));
                teacher.setStatus(rs.getString("TeacherStatus"));

                
                Teachers.add(teacher);
            }
        } catch (SQLException e) {
            // Log the exception details
            System.err.println("Error fetching teachers: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();  // Print the stack trace for debugging
            throw e;  // Re-throw the exception so it can be handled upstream if necessary
        }
        return Teachers;        
    }
    

    // Method to add a teacher to database
    public void addTeacher(Teacher teacher) throws SQLException {
        String sql = "INSERT INTO teachers (TeacherFullName, TeacherEmail, TeacherPhone, TeacherSubject, "
        + "TeacherQualification, TeacherGender, TeacherPassword, TeacherProfileImage, TeacherStatus) "
        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, teacher.getFullName());
            stmt.setString(2, teacher.getEmail());
            stmt.setLong(3, teacher.getPhone());
            stmt.setString(4, teacher.getSubject());
            stmt.setString(5, teacher.getQualification());
            stmt.setString(6, teacher.getGender());
            stmt.setString(7, teacher.getPassword());
            stmt.setBytes(8, teacher.getProfileImage());
            stmt.setString(9, teacher.getStatus());

            stmt.executeUpdate();
        } catch (SQLException e) {
            // Log the exception details
            System.err.println("Error adding teacher: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();  // Print the stack trace for debugging
            throw e;  // Re-throw the exception so it can be handled upstream if necessary
        }
    }
    
    public boolean deleteTeacher(int teacherId) throws SQLException {
        String sql = "DELETE FROM teachers WHERE TeacherID = ?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            int executed = stmt.executeUpdate();
            return executed > 0;
        }        
        
    }
    
    public boolean updateTeacher(Teacher teacher) throws SQLException {
        String sql = "UPDATE Teachers SET TeacherFullName = ?, TeacherEmail = ?, TeacherPhone = ?, "
        + "TeacherSubject = ?, TeacherQualification = ?, TeacherGender = ?, TeacherPassword = ?, "
        + "TeacherProfileImage = ?, TeacherStatus = ? WHERE TeacherID = ?";

        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, teacher.getFullName());
            stmt.setString(2, teacher.getEmail());
            stmt.setLong(3, teacher.getPhone());
            stmt.setString(4, teacher.getSubject());
            stmt.setString(5, teacher.getQualification());
            stmt.setString(6, teacher.getGender());
            stmt.setString(7, teacher.getPassword());
            stmt.setBytes(8, teacher.getProfileImage());
            stmt.setString(9, teacher.getStatus());
            stmt.setInt(10, teacher.getId());

            
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
        
    }
    
    public Teacher getTeacherById(int teacherId) throws SQLException {
        String sql = "SELECT * FROM Teachers WHERE TeacherID = ?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setId(rs.getInt("TeacherID"));
                teacher.setFullName(rs.getString("TeacherFullName"));
                teacher.setEmail(rs.getString("TeacherEmail"));
                teacher.setPhone(rs.getLong("TeacherPhone"));
                teacher.setSubject(rs.getString("TeacherSubject"));
                teacher.setQualification(rs.getString("TeacherQualification"));
                teacher.setGender(rs.getString("TeacherGender"));
                teacher.setPassword(rs.getString("TeacherPassword"));
                teacher.setProfileImage(rs.getBytes("TeacherProfileImage"));
                teacher.setStatus(rs.getString("TeacherStatus"));

                return teacher;
            } else {
                return null;
            }
        }
    }

                             // STUDENT    
    public boolean addStudent(Student student) throws SQLException {
           String sql = "INSERT INTO students (photo, first_name, last_name, mobile, email, password, gender, dob, " +
                 "course, qualification, last_year_percentage, address_line1, address_line2, landmark, pincode, " +
                 "state, city, remember_me, status) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(sql)) {
        
            // Set parameters
            if (student.getPhoto() != null && student.getPhoto().length > 0) {
                stmt.setBytes(1, student.getPhoto());
            } else {
                stmt.setNull(1, Types.BLOB);
            }
        
            stmt.setString(2, student.getFirstName());
            stmt.setString(3, student.getLastName());
            stmt.setLong(4, student.getMobile());
            stmt.setString(5, student.getEmail());
            stmt.setString(6, student.getPassword());
            stmt.setString(7, student.getGender()); 
            stmt.setDate(8, student.getDob());
            stmt.setString(9, student.getCourse());
            stmt.setString(10, student.getQualification());
            stmt.setDouble(11, student.getLastYearPercentage());
            stmt.setString(12, student.getAddressLine1());
            stmt.setString(13, student.getAddressLine2());
            stmt.setString(14, student.getLandmark());
            stmt.setString(15, student.getPincode());
            stmt.setString(16, student.getState());
            stmt.setString(17, student.getCity());
            stmt.setBoolean(18, student.isRememberMe());
            stmt.setString(19, student.getStatus());
      
                int rows = stmt.executeUpdate();
                return rows > 0;
        }catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            throw e;
        }
    }
    
    public List<Student> getAllStudents() throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT id, photo, first_name, last_name, mobile, email, password, gender, dob, " +
                 "course, qualification, last_year_percentage, address_line1, address_line2, landmark, " +
                 "pincode, state, city, remember_me, registration_date, status, processed_date " +
                 "FROM students";
    
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql)) {
        
            while (rs.next()) {
            Student student = new Student();
            student.setId(rs.getInt("id"));
            student.setPhoto(rs.getBytes("photo"));
            student.setFirstName(rs.getString("first_name"));
            student.setLastName(rs.getString("last_name"));
            student.setMobile(rs.getLong("mobile"));
            student.setEmail(rs.getString("email"));
            student.setPassword(rs.getString("password"));
            student.setGender(rs.getString("gender"));
            student.setDob(rs.getDate("dob"));
            student.setCourse(rs.getString("course"));
            student.setQualification(rs.getString("qualification"));
            student.setLastYearPercentage(rs.getDouble("last_year_percentage"));
            student.setAddressLine1(rs.getString("address_line1"));
            student.setAddressLine2(rs.getString("address_line2"));
            student.setLandmark(rs.getString("landmark")); 
            student.setPincode(rs.getString("pincode"));
            student.setState(rs.getString("state"));
            student.setCity(rs.getString("city"));
            student.setRememberMe(rs.getBoolean("remember_me"));
            student.setRegistrationDate(rs.getTimestamp("registration_date"));
            student.setStatus(rs.getString("status"));
            student.setProcessedDate(rs.getTimestamp("processed_date"));

            students.add(student);
         }
        }
        return students;
    }
    
    public boolean updateStatus(int studentId, String status) throws SQLException {
 
        if (!status.equals("APPROVED") && !status.equals("REJECTED") && !status.equals("PENDING")) {
           return false;
        }
            
        String sql = "UPDATE students SET status = ?, processed_date = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, studentId);
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static Integer getStudentIdByName(String studentName) throws SQLException {
        String sql = "SELECT id FROM students WHERE first_name = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentName);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("id");
            } else {
                System.out.println("Student not found.");
                return null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM students WHERE email = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }
    
    
    public Student getStudentByEmailAndPassword(String email, String password) throws SQLException {
        String sql = "SELECT * FROM students WHERE email = ? AND password = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, email);
        stmt.setString(2, password);

        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setPhoto(rs.getBytes("photo"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setMobile(rs.getLong("mobile"));
                student.setEmail(rs.getString("email"));
                student.setPassword(rs.getString("password"));
                student.setGender(rs.getString("gender"));
                student.setDob(rs.getDate("dob"));
                student.setCourse(rs.getString("course"));
                student.setQualification(rs.getString("qualification"));
                student.setLastYearPercentage(rs.getDouble("last_year_percentage"));
                student.setAddressLine1(rs.getString("address_line1"));
                student.setAddressLine2(rs.getString("address_line2"));
                student.setLandmark(rs.getString("landmark"));
                student.setPincode(rs.getString("pincode"));
                student.setState(rs.getString("state"));
                student.setCity(rs.getString("city"));
                student.setRememberMe(rs.getBoolean("remember_me"));
                student.setRegistrationDate(rs.getTimestamp("registration_date"));
                student.setStatus(rs.getString("status"));
                student.setProcessedDate(rs.getTimestamp("processed_date"));

                return student;
            }
        }
        }
        return null;
    }

    public Student getStudentById(int studentId) throws SQLException {
        String sql = "SELECT * FROM students WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Student student = new Student();
                    student.setId(rs.getInt("id"));
                    student.setPhoto(rs.getBytes("photo"));
                    student.setFirstName(rs.getString("first_name"));
                    student.setLastName(rs.getString("last_name"));
                    student.setMobile(rs.getLong("mobile"));
                    student.setEmail(rs.getString("email"));
                    student.setPassword(rs.getString("password"));
                    student.setGender(rs.getString("gender"));
                    student.setDob(rs.getDate("dob"));
                    student.setCourse(rs.getString("course"));
                    student.setQualification(rs.getString("qualification"));
                    student.setLastYearPercentage(rs.getDouble("last_year_percentage"));
                    student.setAddressLine1(rs.getString("address_line1"));
                    student.setAddressLine2(rs.getString("address_line2"));
                    student.setLandmark(rs.getString("landmark"));
                    student.setPincode(rs.getString("pincode"));
                    student.setState(rs.getString("state"));
                    student.setCity(rs.getString("city"));
                    student.setRememberMe(rs.getBoolean("remember_me"));
                    student.setRegistrationDate(rs.getTimestamp("registration_date"));
                    student.setStatus(rs.getString("status"));
                    student.setProcessedDate(rs.getTimestamp("processed_date"));
                  return student;
                }
            }
        }
      return null;
    }
    
    public boolean updateStudent(Student student) throws SQLException {
        String sql = "UPDATE students SET photo = ?, first_name = ?, last_name = ?, mobile = ?, email = ?, password = ?, " +
                     "gender = ?, dob = ?, course = ?, qualification = ?, last_year_percentage = ?, address_line1 = ?, " +
                     "address_line2 = ?, landmark = ?, pincode = ?, state = ?, city = ?, remember_me = ?, " +
                     "status = ?, processed_date = ? WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBytes(1, student.getPhoto());
            stmt.setString(2, student.getFirstName());
            stmt.setString(3, student.getLastName());
            stmt.setLong(4, student.getMobile());
            stmt.setString(5, student.getEmail());
            stmt.setString(6, student.getPassword());
            stmt.setString(7, student.getGender());
            stmt.setDate(8, new java.sql.Date(student.getDob().getTime()));
            stmt.setString(9, student.getCourse());
            stmt.setString(10, student.getQualification());
            stmt.setDouble(11, student.getLastYearPercentage());
            stmt.setString(12, student.getAddressLine1());
            stmt.setString(13, student.getAddressLine2());
            stmt.setString(14, student.getLandmark());
            stmt.setString(15, student.getPincode());
            stmt.setString(16, student.getState());
            stmt.setString(17, student.getCity());
            stmt.setBoolean(18, student.isRememberMe());
            stmt.setString(19, student.getStatus());
            stmt.setTimestamp(20, student.getProcessedDate());
            stmt.setInt(21, student.getId());

          return stmt.executeUpdate() > 0;
        }
    }
    
        // Get approved students
    public List<Student> getApprovedStudents() throws SQLException {
        String query = "SELECT * FROM students WHERE status = 'APPROVED'";
        return getStudentsByStatus(query);
    }

    // Get pending students
    public List<Student> getPendingStudents() throws SQLException {
        String query = "SELECT * FROM students WHERE status = 'PENDING'";
        return getStudentsByStatus(query);
    }

    // Common method to execute the query
    private List<Student> getStudentsByStatus(String query) throws SQLException {
        List<Student> students = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
              PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();
                    student.setId(rs.getInt("id"));
                    student.setPhoto(rs.getBytes("photo"));
                    student.setFirstName(rs.getString("first_name"));
                    student.setLastName(rs.getString("last_name"));
                    student.setMobile(rs.getLong("mobile"));
                    student.setEmail(rs.getString("email"));
                    student.setPassword(rs.getString("password"));
                    student.setGender(rs.getString("gender"));
                    student.setDob(rs.getDate("dob"));
                    student.setCourse(rs.getString("course"));
                    student.setQualification(rs.getString("qualification"));
                    student.setLastYearPercentage(rs.getDouble("last_year_percentage"));
                    student.setAddressLine1(rs.getString("address_line1"));
                    student.setAddressLine2(rs.getString("address_line2"));
                    student.setLandmark(rs.getString("landmark"));
                    student.setPincode(rs.getString("pincode"));
                    student.setState(rs.getString("state"));
                    student.setCity(rs.getString("city"));
                    student.setRememberMe(rs.getBoolean("remember_me"));
                    student.setRegistrationDate(rs.getTimestamp("registration_date"));
                    student.setStatus(rs.getString("status"));
                    student.setProcessedDate(rs.getTimestamp("processed_date"));
                  students.add(student);
            }
        }
        return students;
    }

    // get Total Enrolled Courses by Students.
    public Integer getTotalEnrolledCourses() throws SQLException {

        Set<String> enrolledCoursesSet = new HashSet<>();
        String sql = "SELECT course FROM students";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                enrolledCoursesSet.add(rs.getString("course"));
            }
        }

        return enrolledCoursesSet.size();
    }

        // Can We Approve Student or not. On the base of Course Limit of student Seat
    public boolean approveStudentIfPossible(int studentId) throws SQLException {
        String courseName = null;
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        
        // Step 1: Get the student's course
        String courseQuery = "SELECT course FROM students WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(courseQuery)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                courseName = rs.getString("course");
            } else {
                return false; // student not found
            }
        }

        // Step 2: Count approved students for the course
        int approvedCount = 0;
        String countQuery = "SELECT COUNT(*) FROM students WHERE course = ? AND status = 'APPROVED'";
        try (PreparedStatement stmt = conn.prepareStatement(countQuery)) {
            stmt.setString(1, courseName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                approvedCount = rs.getInt(1);
            }
        }

        // Step 3: Get max_students from courses table
        int maxAllowed = 0;
        String maxQuery = "SELECT max_students FROM courses WHERE name = ?";
        try (PreparedStatement stmt = conn.prepareStatement(maxQuery)) {
            stmt.setString(1, courseName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                maxAllowed = rs.getInt(1);
            } else {
                return false; // course not found
            }
        }

        // Step 4: Approve student if within limit
        if (approvedCount < maxAllowed) {
            String updateQuery = "UPDATE students SET status = 'APPROVED', processed_date = NOW() WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
                stmt.setInt(1, studentId);
                return stmt.executeUpdate() > 0;
            }
        } else {
            return false; // limit reached
        }
    }

                                //Events
        
    public boolean addEvent(Event event) throws SQLException{
        boolean status = false;

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)){
            String query = "INSERT INTO events (title, image, description, date, price, category) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, event.getTitle());
            ps.setBytes(2, event.getImage());               
            ps.setString(3, event.getDescription());
            ps.setDate(4, event.getDate());
            ps.setDouble(5, event.getPrice());
            ps.setString(6, event.getCategory());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Re-throw the exception
        }
    } 
        
    public List<Event> getAllEvents() throws SQLException{
        List<Event> events = new ArrayList<>();

        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD)) {
            // Step 1: Delete events whose date + 1 < today
            String deleteSQL = "DELETE FROM events WHERE date < CURDATE() - INTERVAL 1 DAY";
            PreparedStatement deleteStmt = con.prepareStatement(deleteSQL);
            deleteStmt.executeUpdate();

            // Step 2: Now fetch all valid events
            String query = "SELECT * FROM events ORDER BY id ASC ";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setDate(rs.getDate("date"));
                e.setPrice(rs.getDouble("price"));
                e.setImage(rs.getBytes("image"));
                e.setCategory(rs.getString("category"));
                events.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    // We Get Event By Id
    public Event getEventById(int id) throws SQLException {
        String sql = "SELECT * FROM events WHERE id = ?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setDate(rs.getDate("date"));
                e.setPrice(rs.getDouble("price"));
                e.setCategory(rs.getString("category"));
                e.setImage(rs.getBytes("image"));
              return e;
            }
        }
      return null;
    }
    
    // Update Event
    public boolean updateEvent(Event event ) throws SQLException {
        String sql = "UPDATE events SET title=?, description=?, date=?, price=?, category=?, image=? WHERE id=?";
        
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, event.getTitle());
            ps.setString(2, event.getDescription());
            ps.setDate(3, event.getDate());
            ps.setDouble(4, event.getPrice());
            ps.setString(5, event.getCategory());
            ps.setBytes(6, event.getImage());
            ps.setInt(7, event.getId());

          return ps.executeUpdate() > 0;
        }
    }
    
        public boolean deleteEvent(int eventId) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);) {
            String sql = "DELETE FROM events WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, eventId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
        
    public List<String> getAllCategoriesOfEvents(Boolean condition) throws SQLException {
        // Query the column definition to get ENUM values
        List<String> categories = new ArrayList<>();

        if(condition){
            String sql = "SHOW COLUMNS FROM events LIKE 'category'";
            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String type = rs.getString("Type"); 
                    type = type.substring(type.indexOf("(") + 1, type.lastIndexOf(")"));
                    String[] values = type.split(",");
                    for (String value : values) {
                        // Remove the single quotes around each enum value
                        categories.add(value.replace("'", "").trim());
                    }
                }
            }
              
        }else{
            String sql = "SELECT DISTINCT category FROM events";
            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    categories.add(rs.getString("category"));
                }
            }

        }
        return categories;  
    }
    
                       // Messages

    public static boolean insertMessage(Message message) throws SQLException {
        boolean status = false;
        // Updated query with auto-generated timestamp
        String query = "INSERT INTO messages (full_name, email, subject, message, created_at) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, message.getFullName());
            ps.setString(2, message.getEmail());
            ps.setString(3, message.getSubject());
            ps.setString(4, message.getMessage());

            int rowsAffected = ps.executeUpdate();

            // Get the generated ID
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        message.setId(generatedKeys.getInt(1));
                    }
                }
            }

            status = rowsAffected > 0;
        }
        return status;
    }
    
    // Retrieve all messages
    public List<Message> getAllMessages() throws SQLException {
        List<Message> messages = new ArrayList<>();

        // First, delete old viewed messages (viewed more than 1 day ago)
        deleteOldViewedMessages();

        String query = "SELECT * FROM messages ORDER BY created_at DESC";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setFullName(rs.getString("full_name")); 
                msg.setEmail(rs.getString("email")); 
                msg.setSubject(rs.getString("subject")); 
                msg.setMessage(rs.getString("message"));
                msg.setCreatedAt(rs.getTimestamp("created_at"));
                msg.setViewedAt(rs.getTimestamp("viewed_at"));
                msg.setIsViewed(rs.getBoolean("is_viewed"));

                messages.add(msg);
            }
        }
        return messages;
    }
    
    public boolean markMessageAsViewed(int messageId) throws SQLException {
        String query = "UPDATE messages SET is_viewed = TRUE, viewed_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, messageId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    public Message getMessageById(int messageId) throws SQLException {
        String query = "SELECT * FROM messages WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, messageId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setFullName(rs.getString("full_name")); 
                msg.setEmail(rs.getString("email")); 
                msg.setSubject(rs.getString("subject")); 
                msg.setMessage(rs.getString("message"));
                msg.setCreatedAt(rs.getTimestamp("created_at"));
                msg.setViewedAt(rs.getTimestamp("viewed_at"));
                msg.setIsViewed(rs.getBoolean("is_viewed"));

                // Mark the message as viewed when retrieving it
                markMessageAsViewed(messageId);

                return msg;
            }
        }
        return null;
    }
    
    private void deleteOldViewedMessages() throws SQLException {
        // Delete messages that were viewed more than 1 day ago
        String query = "DELETE FROM messages WHERE is_viewed = TRUE AND viewed_at < CURDATE();";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.executeUpdate();
        }
    }

   // Retrieve all unRead messages
    public List<Message> getAllUreadMessages() throws SQLException {
        List<Message> messages = new ArrayList<>();

        // First, delete old viewed messages (viewed more than 1 day ago)
        deleteOldViewedMessages();

        String query = "SELECT * FROM messages WHERE is_viewed = false";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setFullName(rs.getString("full_name")); 
                msg.setEmail(rs.getString("email")); 
                msg.setSubject(rs.getString("subject")); 
                msg.setMessage(rs.getString("message"));
                msg.setCreatedAt(rs.getTimestamp("created_at"));
                msg.setViewedAt(rs.getTimestamp("viewed_at"));
                msg.setIsViewed(rs.getBoolean("is_viewed"));

                messages.add(msg);
            }
        }
        return messages;
    }
    

                 //   Admin
    public Admin getAdminByUsername(String username) {
        String sql = "SELECT * FROM admin WHERE admin_username = ?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setAdminUsername(rs.getString("admin_username"));
                    admin.setAdminPassword(rs.getString("admin_password"));
                    admin.setAdminName(rs.getString("admin_name"));
                    admin.setAdminPhoto(rs.getBytes("admin_photo"));
                    return admin;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get total number of admins
    public int getTotalAdmins() {
        String sql = "SELECT COUNT(*) FROM admin";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Add a new admin method
    public boolean addAdmin(Admin admin) throws SQLException {
        String sql = "INSERT INTO admin (admin_photo, admin_name, admin_username, admin_password) VALUES (?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Handle photo (can be null)
            if (admin.getAdminPhoto() != null && admin.getAdminPhoto().length > 0) {
                stmt.setBytes(1, admin.getAdminPhoto());
            } else {
                stmt.setNull(1, Types.BLOB);
            }

            stmt.setString(2, admin.getAdminName());
            stmt.setString(3, admin.getAdminUsername());
            stmt.setString(4, admin.getAdminPassword());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding admin: " + e.getMessage());
            throw e;
        }
    }

    // Update admin method
    public boolean updateAdmin(Admin admin) throws SQLException {
        String sql = "UPDATE admin SET admin_photo = ?, admin_name = ?, admin_username = ?, admin_password = ? WHERE admin_id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Handle photo update - preserve existing if null is passed
            if (admin.getAdminPhoto() != null) {
                if (admin.getAdminPhoto().length > 0) {
                    stmt.setBytes(1, admin.getAdminPhoto());
                } else {
                    // Get current photo to preserve it
                    Admin currentAdmin = getAdminById(admin.getAdminId());
                    if (currentAdmin != null) {
                        stmt.setBytes(1, currentAdmin.getAdminPhoto());
                    } else {
                        stmt.setNull(1, Types.BLOB);
                    }
                }
            } else {
                stmt.setNull(1, Types.BLOB);
            }

            stmt.setString(2, admin.getAdminName());
            stmt.setString(3, admin.getAdminUsername());
            stmt.setString(4, admin.getAdminPassword());
            stmt.setInt(5, admin.getAdminId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating admin: " + e.getMessage());
            throw e;
        }
    }

    // Delete admin method with protection for main admin (admin_id = 1)
    public boolean deleteAdmin(int adminId) throws SQLException {
        // Prevent deletion of main admin (assuming admin_id = 1 is the main admin)
        if (adminId == 1) {
            System.err.println("Cannot delete main admin (admin_id = 1)");
            return false;
        }

        String sql = "DELETE FROM admin WHERE admin_id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, adminId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting admin: " + e.getMessage());
            throw e;
        }
    }

    // Optional: Get all admins method (for admin management)
    public List<Admin> getAllAdmins() throws SQLException {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM admin ORDER BY admin_id";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setAdminPhoto(rs.getBytes("admin_photo"));
                admin.setAdminName(rs.getString("admin_name"));
                admin.setAdminUsername(rs.getString("admin_username"));
                admin.setAdminPassword(rs.getString("admin_password"));
                admins.add(admin);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching admins: " + e.getMessage());
            throw e;
        }
        return admins;
    }

    // Optional: Check if username already exists (for validation)
    public boolean adminUsernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM admin WHERE admin_username = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error checking admin username: " + e.getMessage());
            throw e;
        }
        return false;
    }

    // Optional: Update admin method that doesn't change photo if not provided
    public boolean updateAdminWithoutPhotoChange(Admin admin) throws SQLException {
        String sql = "UPDATE admin SET admin_name = ?, admin_username = ?, admin_password = ? WHERE admin_id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, admin.getAdminName());
            stmt.setString(2, admin.getAdminUsername());
            stmt.setString(3, admin.getAdminPassword());
            stmt.setInt(4, admin.getAdminId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating admin: " + e.getMessage());
            throw e;
        }
    }
    //      _+_+_+_     FOR SEARCH OPTION     _+_+_+_
    

        // === TEACHERS ===
    public static List<Teacher> searchTeachers(String query) throws SQLException {
        List<Teacher> list = new ArrayList<>();
    
        // Check if query is null or empty
        if (query == null || query.trim().isEmpty()) {
            return list; // Return empty list
        }

        String sql = "SELECT * FROM teachers WHERE TeacherFullName  LIKE ? OR TeacherSubject  LIKE ? OR TeacherEmail  LIKE ?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {
            String wildcard = "%" + query + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ps.setString(3, wildcard);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Teacher t = new Teacher();
                t.setId(rs.getInt("TeacherID"));
                t.setFullName(rs.getString("TeacherFullName"));
                t.setEmail(rs.getString("TeacherEmail"));
                t.setSubject(rs.getString("TeacherSubject"));
                t.setProfileImage(rs.getBytes("TeacherProfileImage"));
                list.add(t);
            }
        }
        return list;
    }

    // === COURSES ===
    public static List<Course> searchCourses(String query) throws SQLException {
        List<Course> list = new ArrayList<>();
        
        // Check if query is null or empty
        if (query == null || query.trim().isEmpty()) {
            return list; // Return empty list
        }
        
        String sql = "SELECT * FROM courses WHERE name LIKE ? OR description LIKE ? OR category LIKE ?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {
            String wildcard = "%" + query + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ps.setString(3, wildcard);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setCategory(rs.getString("category"));
                c.setImg(rs.getBytes("image"));
              list.add(c);
            }
        }
      return list;
    }

    // === EVENTS ===
    public static List<Event> searchEvents(String query) throws SQLException {
        List<Event> list = new ArrayList<>();
        
        // Check if query is null or empty
        if (query == null || query.trim().isEmpty()) {
            return list; // Return empty list
        }
        
        String sql = "SELECT * FROM events WHERE title LIKE ? OR description LIKE ? OR category LIKE ?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {
            String wildcard = "%" + query + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ps.setString(3, wildcard);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setDate(rs.getDate("date"));
                e.setPrice(rs.getDouble("price"));
                e.setCategory(rs.getString("category"));
                e.setImage(rs.getBytes("image"));

                list.add(e);
            }
        }
        return list;
    }

    // === STUDENTS ===
    public static List<Student> searchStudents(String query) throws SQLException {
        List<Student> list = new ArrayList<>();
        
        // Check if query is null or empty
        if (query == null || query.trim().isEmpty()) {
            return list; // Return empty list
        }
        
        String sql = "SELECT * FROM students WHERE first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR course LIKE ? OR status LIKE ?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {
            String wildcard = "%" + query + "%";
            for (int i = 1; i <= 5; i++) {
                ps.setString(i, wildcard);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setFirstName(rs.getString("first_name"));
                s.setLastName(rs.getString("last_name"));
                s.setEmail(rs.getString("email"));
                s.setCourse(rs.getString("course"));
                s.setStatus(rs.getString("status"));
                s.setPhoto(rs.getBytes("photo"));
                list.add(s);
            }
        }
        return list;
    }

    // === ADMINS ===
    public static List<Admin> searchAdmins(String query) throws SQLException {
        List<Admin> list = new ArrayList<>();
        
        // Check if query is null or empty
        if (query == null || query.trim().isEmpty()) {
            return list; // Return empty list
        }
        
        String sql = "SELECT * FROM admin WHERE admin_name LIKE ? OR admin_username LIKE ?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {
            String wildcard = "%" + query + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Admin a = new Admin();
                a.setAdminId(rs.getInt("admin_id"));
                a.setAdminName(rs.getString("admin_name"));
                a.setAdminUsername(rs.getString("admin_username"));
                a.setAdminPhoto(rs.getBytes("admin_photo"));                
             list.add(a);
            }
        }
      return list;
    }

    // === For View Pages ===
//    public static Student getStudentById(int id) throws SQLException {
//        Student s = null;
//        String sql = "SELECT * FROM students WHERE id=?";
//        try (Connection con = getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                s = new Student();
//                s.setId(rs.getInt("id"));
//                s.setFirstName(rs.getString("first_name"));
//                s.setLastName(rs.getString("last_name"));
//                s.setEmail(rs.getString("email"));
//                s.setCourse(rs.getString("course"));
//                s.setStatus(rs.getString("status"));
//            }
//        }
//        return s;
//    }

    public Admin getAdminById(int id) throws SQLException {
        String sql = "SELECT * FROM admin WHERE admin_id = ?"; // Fixed space before =?
        try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setAdminName(rs.getString("admin_name"));
                admin.setAdminUsername(rs.getString("admin_username"));
                admin.setAdminPassword(rs.getString("admin_password"));
                admin.setAdminPhoto(rs.getBytes("admin_photo"));
                return admin;
            }
        }
        return null;
    }
    
    
    //Collation.reverse(list); // Reverse the List 
            // 1. Get Last Two Students
    public List<Student> getLastTwoStudents() throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC LIMIT 2";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setEmail(rs.getString("email"));
                student.setMobile(rs.getLong("mobile"));
                student.setGender(rs.getString("gender"));
                student.setDob(rs.getDate("dob"));
                student.setCourse(rs.getString("course"));
                student.setQualification(rs.getString("qualification"));
                student.setLastYearPercentage(rs.getDouble("last_year_percentage"));
                student.setAddressLine1(rs.getString("address_line1"));
                student.setAddressLine2(rs.getString("address_line2"));
                student.setLandmark(rs.getString("landmark"));
                student.setPincode(rs.getString("pincode"));
                student.setState(rs.getString("state"));
                student.setCity(rs.getString("city"));
                student.setRememberMe(rs.getBoolean("remember_me"));
                student.setRegistrationDate(rs.getTimestamp("registration_date"));
                student.setStatus(rs.getString("status"));
                student.setProcessedDate(rs.getTimestamp("processed_date"));
                student.setPhoto(rs.getBytes("photo"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // 2. Get Last Two Events
    public List<Event> getLastTwoEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY id DESC LIMIT 2";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Event event = new Event();
                event.setId(rs.getInt("id"));
                event.setTitle(rs.getString("title"));
                event.setImage(rs.getBytes("image"));
                event.setDescription(rs.getString("description"));
                event.setDate(rs.getDate("date"));
                event.setPrice(rs.getDouble("price"));
                event.setCategory(rs.getString("category"));
                events.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return events;
    }

    // 3. Get Last Two Teachers
    public List<Teacher> getLastTwoTeachers() throws SQLException {
        List<Teacher> teachers = new ArrayList<>();
        String sql = "SELECT * FROM teachers ORDER BY TeacherID DESC LIMIT 2";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setId(rs.getInt("TeacherID"));
                teacher.setFullName(rs.getString("TeacherFullName"));
                teacher.setEmail(rs.getString("TeacherEmail"));
                teacher.setPhone(rs.getInt("TeacherPhone"));
                teacher.setSubject(rs.getString("TeacherSubject"));
                teacher.setQualification(rs.getString("TeacherQualification"));
                teacher.setGender(rs.getString("TeacherGender"));
                teacher.setPassword(rs.getString("TeacherPassword"));
                teacher.setProfileImage(rs.getBytes("TeacherProfileImage"));
                teacher.setStatus(rs.getString("TeacherStatus"));
                teachers.add(teacher);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return teachers;
    }

    // 4. Get Last Two Courses
    public List<Course> getLastTwoCourses() throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM courses ORDER BY id DESC LIMIT 2";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setName(rs.getString("name"));
                course.setImg(rs.getBytes("image"));
                course.setFees(rs.getDouble("fees"));
                course.setStar(rs.getDouble("star"));
                course.setDescription(rs.getString("description"));
                course.setMaxStudents(rs.getInt("max_students"));
                course.setDurationMonths(rs.getInt("duration_months"));
                course.setCategory(rs.getString("category"));
                courses.add(course);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courses;
    }
    
                    ///   \\\\\/TOTAL /\\\\\/////
    // 1. Total Students
    public int getTotalStudents() {
        String sql = "SELECT COUNT(*) FROM students";
          try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
             if (rs.next()) {
                 return rs.getInt(1);
               }
          } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // 2. Total Approved Students
   public int getTotalStudentsApproved() {
       String sql = "SELECT COUNT(*) FROM students WHERE status = ?";
       try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(sql)) {

           stmt.setString(1, "APPROVED"); 

           try (ResultSet rs = stmt.executeQuery()) {
               if (rs.next()) {
                   return rs.getInt(1);
               }
           }

       } catch (SQLException e) {
           e.printStackTrace();
       }
       return 0;
   }
  
      
   
        // 3. Total Courses
    public int getTotalCourses() {
        String sql = "SELECT COUNT(*) FROM courses";
          try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
             if (rs.next()) {
              return rs.getInt(1); 
             }
         } catch (SQLException e) {
            e.printStackTrace();
         }
        return 0;
    }   
        //4. Total Teachers
    public int getTotalTeachers() {
      String sql = "SELECT COUNT(*) FROM teachers";
         try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
              if (rs.next()) { 
               return rs.getInt(1);
             }
         } catch (SQLException e) {
           e.printStackTrace();
         }
        
        return 0;
    }
    
      // Method to get fees by course name
    public Double getFeesByCourse(String courseName) {
        String query = "SELECT fees FROM courses WHERE name = ?";
        Double fees = null;

        try (
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(query)
        ) {
            stmt.setString(1, courseName);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    fees = rs.getDouble("fees");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fees;
    }

    
        
}
