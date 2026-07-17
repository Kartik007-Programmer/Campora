<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.Teacher" %>
<%@ page import="mypackage.*" %>
<%@ page import="java.sql.SQLException" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    boolean isUserLoggedIn = true;
    String AdminUsername = (String) session.getAttribute("admin");

    if (AdminUsername == null) {
        isUserLoggedIn = false;
        RequestDispatcher rd = request.getRequestDispatcher("LoginForm.jsp");
        rd.forward(request, response);
        return;
    }
%>

<%
    if (request.getAttribute("teachers") == null) {
        try {
            DAO teacherDAO = new DAO();
            List<Teacher> teachers = teacherDAO.getAllTeachers();
            request.setAttribute("teachers", teachers);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
    }

    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
    <script>alert('<%= error %>');</script>
<%
    }
%>

<%
    try {
        DAO courseDAO = new DAO();
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }
%>

<c:set var="pageTitle" value="Add Tracher - Campora" scope="request" />

<c:set var="additionalCSS" scope="request">
    <style>
        body {
  background-color: #121212;
  color: #e0e0e0;
}

.form-control {
  background-color: #1e1e1e;
  color: #f5f5f5;
  border: 1px solid #333;
  border-radius: 6px;
  padding: 10px 12px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.form-control:focus {
  background-color: #252525;
  color: #fff;
  border-color: #3f51b5;
  box-shadow: 0 0 0 3px rgba(63, 81, 181, 0.4);
  outline: none;
}

.form-control::placeholder {
  color: #aaaaaa;
  opacity: 1;
}



label {
  color: #d1d1d1;
  font-weight: 500;
}

.btn {
  border-radius: 6px;
  padding: 10px 16px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.btn-primary {
  background-color: #3f51b5;
  border: none;
  color: #fff;
}

.btn-primary:hover {
  background-color: #5c6bc0;
}

.btn-secondary {
  background-color: #444;
  border: none;
  color: #f5f5f5;
}

.btn-secondary:hover {
  background-color: #555;
}
      .teacher-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
      }
      
      .teacher-card {
        flex: 1 1 calc(25% - 20px);
        min-width: 250px;
        background: #191c24;
        border: 1px solid #2c2c2c;
        border-radius: 8px;
        padding: 16px;
        box-sizing: border-box;
        transition: all 0.3s ease;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        justify-content: center;
      }
      
      .teacher-card h3 {
        color: #81d4fa;
        margin-bottom: 18px;
        font-weight: bold;
      }
      
      .teacher-card:hover {
        transform: scale(1.02);
        box-shadow: 0 0 10px rgba(129, 212, 250, 0.3);
        border-color: #81d4fa;
        color: #ffffff;
      }
      
      .password {
        cursor: pointer;
        color: #81d4fa;
      }
      
      .password:hover {
        text-decoration: underline;
      }
      
      .teacher-card.expanded {
        transform: scale(1.04);
        box-shadow: 0 0 15px rgba(129, 212, 250, 0.5);
        color: #f5f5f5;
        border-color: #81d4fa;
        background: #20232a;
        z-index: 10;
      }

      .teacher-card .teacher-img {
        display: block;
        position: absolute;
        right: 25px;
        top: 50%;
        transform: translateY(-60%);
        width: 150px;
        height: 150px;
        border-radius: 50%;
        object-fit: cover;
        border: 1.5px solid #ffffff;
        box-shadow: 0 4px 12px rgba(129, 212, 250, 0.3);
      }

      .card-buttons {
        display: flex;
        justify-content: space-between;
        margin-top: 15px;
        gap: 10px;
      }

      .card-buttons .btn-edit,
      .card-buttons .btn-delete {
        flex: 1;
        padding: 8px;
        font-size: 14px;
        border: none;
        border-radius: 5px;
        text-align: center;
        text-decoration: none;
        cursor: pointer;
        transition: 0.1s ease;
      }

      .card-buttons .btn-edit {
        border: solid 1px #81d4fa;
        color: #e0e0e0;
        background-color: rgba(129, 212, 250, 0.068);
      }

      .card-buttons .btn-delete {
        color: #e0e0e0;
        background-color: rgba(129, 212, 250, 0.068);
        border: solid 1px #81d4fa;
      }

      .card-buttons .btn-edit:hover {
        background-color: #81d4fa;
        color: #121212;
        opacity:0.85;
      }

      .card-buttons .btn-delete:hover {
        background-color: #81d4fa;
        color: #121212;
        opacity:0.85;
      }

      .big-teacher-card {
        flex: 1 1 100%;
        margin-top: 30px;
        padding: 32px 24px;
        border: 2px solid #81d4fa;
        background: #1c1f29;
      }

      .big-teacher-card .teacher-img {
        position: static;
        width: 160px;
        height: 160px;
        margin: 0 auto 24px auto;
        border: 3px solid #ffffff;
        box-shadow: 0 6px 16px rgba(129, 212, 250, 0.35);
      }
      
      @media screen and (max-width: 992px) {
        .teacher-card {
          flex: 1 1 calc(50% - 20px);
        }
      }
      
      @media screen and (max-width: 600px) {
        .teacher-card {
          flex: 1 1 100%;
        }
      }
    </style>
 </c:set>
  
  
<c:set var="pageContent" scope="request">
        
     
            <div class="page-header">
              <h3 class="page-title"> Add a Teacher </h3>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="../Dashboard/Admin_panel.jsp">Dashboard</a></li>
                  <li class="breadcrumb-item active" aria-current="page">Add Teacher</li>
                </ol>
              </nav>
            </div>
            <div class="row">
              <div class="col-md-6 grid-margin stretch-card">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Admission Form</h4>
                    <p class="card-description"> Apply for CAMPORA Teacher 2025 </p>
                    <form class="forms-sample" action="<%= request.getContextPath() %>/AddTeacherViewTeachers" method="post" enctype="multipart/form-data">
                      <div class="form-group">
                        <label>Teacher photo</label>
                        <!-- Hidden file input -->
                        <input type="file" name="TeacherProfile_image" class="file-upload-default" accept=".jpg,.png,.svg" multiple style="display:none" id="fileInput">
                        <div class="input-group col-xs-12">
                          <!-- Display the selected file names here -->
                          <input type="text" class="form-control file-upload-info" disabled placeholder="Upload image size 4MB, Format JPG, PNG, SVG">
                          <span class="input-group-append">
                            <!-- Button triggers the file input -->
                            <button class="file-upload-browse btn btn-primary" type="button" id="browseButton">Upload</button>
                          </span>
                        </div>
                      </div>
                      <div class="form-group">
                        <label for="TeacherFullname">Full Name</label>
                        <input type="text" class="form-control" id="TeacherFullname" name="TeacherFullname" placeholder="Your Fullname" required>
                      </div>
                      <div class="form-group">
                        <label for="TeacherPhone">Mobile Number</label>
                        <input type="tel" class="form-control" id="TeacherPhone" name="TeacherPhone" placeholder="Your Number" required>
                      </div>
                      <div class="form-group">
                        <label for="TeacherEmail">Email address</label>
                        <input type="email" class="form-control" id="TeacherEmail" name="TeacherEmail" placeholder="Your Email address" required>
                      </div>
                      <div class="form-group">
                        <label for="TeacherPassword">Password</label>
                        <input type="password" class="form-control" id="TeacherPassword" name="TeacherPassword" placeholder="Your Password" required>
                      </div>
                      <div class="form-group">
                        <label for="TeacherConfirmPassword">Confirm Password</label>
                        <input type="password" class="form-control" id="TeacherConfirmPassword" name="TeacherConfirmPassword" placeholder="Confirm Password" required>
                      </div>
                      <div class="form-group">  
                        <label for="TeacherGender">Gender</label>
                        <select class="form-control" id="TeacherGender" name="TeacherGender" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                          <option value="">Select Gender</option>
                          <option value="male">Male</option>
                          <option value="female">Female</option>
                          <option value="other">Others</option>
                        </select>
                      </div>
                      <div class="form-group">
                        <label for="TeacherDOB">Date Of Birth</label>
                        <input type="date" class="form-control" id="TeacherDOB" name="TeacherDOB" placeholder="Your Birth Date" style="color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                      </div>
                      <div class="form-group">  
                        <label for="TeacherQualification">Qualification</label>
                        <select class="form-control" id="TeacherQualification" name="TeacherQualification" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                          <option value="">Select Highest Qualification</option>
                          <option value="10th Pass">10th Pass</option>
                          <option value="12th Pass">12th Pass</option>
                          <option value="Diploma/Polytechnic">Diploma/Polytechnic</option>
                          <option value="Graduate">Graduate</option>
                          <option value="Post Graduate">Post Graduate</option>
                          <option value="Others">Others</option>
                        </select>
                      </div>
                      <div class="form-group">
                        <label for="TeacherSubject">Course</label>
                        <select class="form-control" id="TeacherSubject" name="TeacherSubject" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                          <option value="">Select Course</option>
                          <c:forEach var="course" items="${courses}"> 
                            <option value="${course.name}">${course.name}</option>
                          </c:forEach>
                        </select>
                      </div>
                      
                      <div class="d-flex justify-content-end gap-2 mt-3">
                        <button type="button" class="btn btn-outline-secondary btn-sm px-4 py-2 font-weight-bold rounded-2 shadow-sm" style="margin-right: 10px;">
                          Cancel
                        </button>
                        <button type="submit" class="btn btn-sm text-white px-4 py-2 font-weight-bold rounded-2 shadow-sm" style="background-color: #007bff;">
                          Submit
                        </button>
                      </div>
                    </form>
                    
                    <script>
                      // Trigger file input click when the "Upload" button is clicked
                      document.getElementById('browseButton').addEventListener('click', function() {
                        document.getElementById('fileInput').click();
                      });
                      
                      // Handle file selection and validation
                      document.getElementById('fileInput').addEventListener('change', function() {
                        const files = this.files;
                        const fileInfoInput = document.querySelector('.file-upload-info');
                        
                        // Check for file sizes and formats
                        let isValid = true;
                        let fileNames = [];
                        Array.from(files).forEach(file => {
                          if (file.size > 4 * 1024 * 1024) { // 4MB size limit
                            alert("File size exceeds 4MB. Please upload a smaller file.");
                            isValid = false;
                          }
                          
                          const validFormats = ['image/jpeg', 'image/png', 'image/svg+xml'];
                          if (!validFormats.includes(file.type)) {
                            alert("Invalid file format. Only JPG, PNG, SVG are allowed.");
                            isValid = false;
                          }
                          
                          // Collect the file names
                          fileNames.push(file.name);
                        });
                        
                        // If all files are valid, display their names
                        if (isValid) {
                          fileInfoInput.value = fileNames.join(', ') + " selected";
                        }
                      });
                      
                      // Password confirmation validation
                      document.querySelector('form').addEventListener('submit', function(e) {
                        const password = document.getElementById('TeacherPassword').value;
                        const confirmPassword = document.getElementById('TeacherConfirmPassword').value;
                        
                        if (password !== confirmPassword) {
                          alert("Passwords do not match!");
                          e.preventDefault();
                        }
                      });
                    </script>
                  </div>
                </div>
              </div>
              
              <!-- Right Side: Teacher Profiles Cards -->
              <div class="col-md-6 grid-margin stretch-card">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Teacher Profiles</h4>
                    <p class="card-description">Interactive layout with Edit/Delete options</p>
                    <div class="teacher-container limited" id="teacherContainer">
                      <c:forEach var="teacher" items="${teachers}">
                        <div class="teacher-card">
                          <c:if test="${not empty teacher.profileImage}">
                            <img class="teacher-img" src="data:image/jpeg;base64,${teacher.imageBase64}" alt="${teacher.fullName}" />
                          </c:if>
                          <h3>${teacher.fullName}</h3>
                          <p><strong>Gender:</strong> ${teacher.gender}</p>
                          <p><strong>Email:</strong> ${teacher.email}</p>
                          <p><strong>Phone:</strong> ${teacher.phone}</p>
                          <p><strong>Password:</strong> <span class="password" data-password="${teacher.password}">••••••••</span></p>
                          <p><strong>Course:</strong> ${teacher.subject}</p>
                          <p><strong>Qualifications:</strong> ${teacher.qualification}</p>
                          <div class="card-buttons">
                            <a href="<%= request.getContextPath() %>/EditTeacherServlet?id=${teacher.id}" class="btn-edit">Edit</a>
                            <form action="DeleteTeacherServlet" method="post" style="display:inline;">
                              <input type="hidden" name="id" value="${teacher.id}" />
                              <button type="submit" class="btn-delete" onclick="return confirm('Are you sure you want to delete this teacher?')">Delete</button>
                            </form>
                          </div>
                        </div>
                      </c:forEach>
                    </div>
                    
                    <div class="d-flex justify-content-center mt-4">
                      <a href="displayTeachers.jsp" class="btn btn-outline-secondary btn-sm px-4 py-2 rounded-2 shadow-sm d-flex align-items-center gap-2">
                        <span style="font-weight: bold;">View All Teachers</span>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
       
    
    </c:set>
    
    <!-- Include base scripts -->
<c:set var="additionalScripts" scope="request"> 
    
    <!-- Custom scripts for this page -->
    <script>
      // Toggle password visibility
      document.querySelectorAll('.password').forEach(el => {
        el.addEventListener('click', function() {
          if (this.classList.contains('visible')) {
            this.textContent = '••••••••';
            this.classList.remove('visible');
          } else {
            this.textContent = this.dataset.password;
            this.classList.add('visible');
          }
        });
      });
      
      // Highlight functionality for search results
      document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const searchQuery = urlParams.get('searchQuery');
        const highlightId = urlParams.get('highlightId');
        
        if (highlightId) {
          const row = document.querySelector(`tr[data-id="${highlightId}"]`);
          if (row) {
            row.classList.add('highlight-row');
            row.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            setTimeout(() => row.classList.remove('highlight-row'), 3000);
          }
        }
        
        if (searchQuery) {
          const regex = new RegExp(`(${searchQuery})`, 'gi');
          document.querySelectorAll('.highlight-target').forEach(el => {
            el.innerHTML = el.textContent.replace(regex, '<span class="highlight">$1</span>');
          });
        }
      });
    </script>
    <script>
        window.onload = function() {
            const navEntries = performance.getEntriesByType("navigation");
            if (navEntries.length > 0 && navEntries[0].type === "reload") {
                const isLoggedIn = <%= isUserLoggedIn %>;
                if (isLoggedIn) {
                    window.location.replace("LoginForm.jsp");
                }
            }
        };
    </script>
</c:set>

<!-- Include the base template -->
<jsp:include page="Base.jsp" />