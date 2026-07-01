
<%@ page import="mypackage.DAO" %>
<%@ page import="mypackage.*" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ page import="java.sql.SQLException" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
    // Page-specific data fetching only
    // Use unique variable name to avoid conflict with Base.jsp
    DAO studentDAO = new DAO();
    try {
        List<Course> courses = studentDAO.getAllCourses();
        request.setAttribute("courses", courses);
        List<Student> LTstudents = studentDAO.getLastTwoStudents();
        request.setAttribute("LTstudents", LTstudents);
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }
%>

<c:set var="pageTitle" value="Add Students - Campora Admin" scope="request" />

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
        
        .card-buttons button {
            flex: 1;
            padding: 8px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            background-color: #2a2d3a;
            color: #81d4fa;
            cursor: pointer;
            transition: 0.1s ease;
            border: #ffffff 0.1px solid;
        }
        
        .card-buttons button:nth-child(1) {
            border: solid 1px #81d4fa;
            color: #e0e0e0;
            background-color: rgba(129, 212, 250, 0.068);
        }
        
        .card-buttons button:nth-child(2) {
            color: #e0e0e0;
            background-color: rgba(129, 212, 250, 0.068);
            border: solid 1px #81d4fa;
        }
        
        .card-buttons button:nth-child(1):hover {
            background-color: #81d4fa;
            color: #121212;
            opacity:0.85;
        }
        
        .card-buttons button:nth-child(2):hover {
            background-color: #81d4fa;
            color: #121212;
            opacity:0.85;
        }
        
        .status-pending {
            color: #ff9800;
            font-weight: bold;
        }
        
        .status-active {
            color: #4caf50;
            font-weight: bold;
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
        
        /* Error message styling */
        .error-message {
            color: #f44336;
            background-color: #f8d7da;
            border-color: #f5c6cb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
        
        .file-upload-info {
            background-color: #2a2d3a;
            border: 1px solid #3e3e3e;
            color: #e0e0e0;
        }
        
      
        
    </style>
</c:set>

<c:set var="pageContent" scope="request">
    <div class="page-header">
        <h3 class="page-title">Add a Student</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/Dashboard/Admin_penal.jsp">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Add Students</li>
            </ol>
        </nav>
    </div>
    
    <!-- Error Message Display -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>
    
    <div class="row">
        <div class="col-md-6 grid-margin stretch-card">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title">Student Registration Form</h4>
                    <p class="card-description">Register student for 2025</p>
                    <form class="forms-sample" method="post" action="${pageContext.request.contextPath}/StudentServlet" enctype="multipart/form-data">
                        <div class="form-group">
                            <label>Student photo</label>
                            <input type="file" name="StudentPhoto" class="file-upload-default" accept=".jpg,.png,.jpeg" style="display:none" id="fileInput">
                            <div class="input-group col-xs-12">
                                <input type="text" class="form-control file-upload-info" disabled placeholder="Upload image (max 4MB, JPG/PNG)">
                                <span class="input-group-append">
                                    <button class="file-upload-browse btn btn-primary" type="button" id="browseButton">Upload</button>
                                </span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" class="form-control" id="firstName" name="StudentFirstName" placeholder="First Name" required>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="StudentLastName" placeholder="Last Name" required>
                        </div>
                        <div class="form-group">
                            <label for="mobile">Mobile Number</label>
                            <input type="tel" class="form-control" id="mobile" name="StudentMobile" placeholder="Mobile Number" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email address</label>
                            <input type="email" class="form-control" id="email" name="StudentEmail" placeholder="Email" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="StudentPassword" placeholder="Password" required>
                        </div>
                        <div class="form-group">
                            <label for="dob">Date Of Birth</label>
                            <input type="date" class="form-control" id="dob" name="StudentDOB"style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                        </div>
                        <div class="form-group">  
                            <label for="gender">Gender</label>
                            <select class="form-control" id="gender" name="StudentGender" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                                <option value="">-- Select Gender --</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">  
                            <label for="qualification">Qualification</label>
                            <input type="text" class="form-control" id="qualification" name="StudentQualification" placeholder="Highest Qualification" required>
                        </div>
                        <div class="form-group">
                            <label for="course">Course</label>
                            <select class="form-control" id="course" name="StudentCourse" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                                <option value="">-- Select Course --</option>
                                <c:forEach var="course" items="${courses}"> 
                                    <option value="${course.name}">${course.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="percentage">Last Year Percentage</label>
                            <input type="number" step="0.01" class="form-control" id="percentage" name="StudentLYP" placeholder="Percentage" required>
                        </div>
                        <div class="form-group">
                            <label for="address1">Address Line 1</label>
                            <input type="text" class="form-control" id="address1" name="StudentAddressLine1" placeholder="Address Line 1" required>
                        </div>
                        <div class="form-group">
                            <label for="address2">Address Line 2</label>
                            <input type="text" class="form-control" id="address2" name="StudentAddressLine2" placeholder="Address Line 2">
                        </div>
                        <div class="form-group">
                            <label for="landmark">Landmark</label>
                            <input type="text" class="form-control" id="landmark" name="StudentLandmark" placeholder="Landmark">
                        </div>
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" class="form-control" id="city" name="StudentCity" placeholder="City" required>
                        </div>
                        <div class="form-group">
                            <label for="state">State</label>
                            <input type="text" class="form-control" id="state" name="StudentState" placeholder="State" required>
                        </div>
                        <div class="form-group">
                            <label for="pincode">Pincode</label>
                            <input type="text" class="form-control" id="pincode" name="StudentPincode" placeholder="Pincode" required>
                        </div>
                        <button type="submit" class="btn btn-primary mr-2">Submit</button>
                        <button type="reset" class="btn btn-dark">Reset</button>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 grid-margin stretch-card">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title">Recent Student Profiles</h4>
                    <p class="card-description">Interactive layout with Edit/Delete options</p>
                    <div class="teacher-container" id="teacherContainer">
                        <c:forEach var="student" items="${LTstudents}">
                            <div class="teacher-card">
                                <c:if test="${not empty student.photo}">
                                    <img src="data:image/jpeg;base64,${student.imageBase64}" 
                                        alt="Student Photo" 
                                        class="teacher-img">
                                </c:if>
                                <h3>${student.firstName} ${student.lastName}</h3>
                                <p><strong>Gender:</strong> ${student.gender}</p>
                                <p><strong>Email:</strong> ${student.email}</p>
                                <p><strong>DOB:</strong> 
                                    <c:if test="${not empty student.dob}">
                                        <fmt:formatDate value="${student.dob}" pattern="dd-MMM-yyyy" />
                                    </c:if>
                                    <c:if test="${empty student.dob}">
                                        N/A
                                    </c:if>
                                </p>
                                <p><strong>Phone:</strong> ${student.mobile}</p>
                                <p><strong>Course:</strong> ${student.course}</p>
                                <p><strong>Status:</strong> 
                                    <c:choose>
                                        <c:when test="${student.status eq 'active' or student.status eq 'Active'}">
                                            <span class="status-active">${student.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pending">${student.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="card-buttons">
                                    <form action="${pageContext.request.contextPath}/edit-student" method="get" style="display:inline;">
                                        <input type="hidden" name="id" value="${student.id}" />
                                        <button type="submit" class="btn-edit">Edit</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/delete-student" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this student?');">
                                        <input type="hidden" name="id" value="${student.id}">
                                        <button type="submit">Delete</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="d-flex justify-content-center mt-4">
                        <a href="manage_students.jsp" class="btn btn-outline-secondary btn-sm px-4 py-2 rounded-2 shadow-sm d-flex align-items-center gap-2">
                            <span style="font-weight: bold;">View All Students</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:set>

<c:set var="additionalScripts" scope="request">
    <script src="${pageContext.request.contextPath}/assets/vendors/select2/select2.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/typeahead.js/typeahead.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/file-upload.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/typeahead.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/select2.js"></script>
    
    <script>
        // File upload handling
        document.addEventListener('DOMContentLoaded', function() {
            const browseButton = document.getElementById('browseButton');
            const fileInput = document.getElementById('fileInput');
            
            if (browseButton && fileInput) {
                browseButton.addEventListener('click', function() {
                    fileInput.click();
                });
            }
            
            if (fileInput) {
                fileInput.addEventListener('change', function() {
                    const file = this.files[0];
                    const fileInfoInput = document.querySelector('.file-upload-info');
                    
                    if (file) {
                        // Check file size (max 4MB)
                        if (file.size > 4 * 1024 * 1024) {
                            showError("File size exceeds 4MB. Please upload a smaller file.");
                            this.value = ''; // Clear the file input
                            fileInfoInput.value = '';
                            return;
                        }
                        
                        // Check file type
                        const validTypes = ['image/jpeg', 'image/png'];
                        if (!validTypes.includes(file.type)) {
                            showError("Invalid file format. Only JPG and PNG are allowed.");
                            this.value = ''; // Clear the file input
                            fileInfoInput.value = '';
                            return;
                        }
                        
                        fileInfoInput.value = file.name;
                    }
                });
            }
            
            // Initialize select2 if needed
            
        });
        
        function showError(message) {
            // Create error alert dynamically
            const errorAlert = document.createElement('div');
            errorAlert.className = 'alert alert-danger alert-dismissible fade show';
            errorAlert.role = 'alert';
            errorAlert.innerHTML = `
                ${message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            `;
            
            // Insert after page header
            const pageHeader = document.querySelector('.page-header');
            if (pageHeader) {
                pageHeader.parentNode.insertBefore(errorAlert, pageHeader.nextSibling);
            }
            
            // Remove after 5 seconds
            setTimeout(() => {
                if (errorAlert.parentNode) {
                    errorAlert.remove();
                }
            }, 5000);
        }
        
        // Form validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('.forms-sample');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const email = document.getElementById('email');
                    const mobile = document.getElementById('mobile');
                    const password = document.getElementById('password');
                    
                    // Basic email validation
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (email && !emailRegex.test(email.value)) {
                        showError("Please enter a valid email address.");
                        e.preventDefault();
                        return;
                    }
                    
                    // Mobile number validation (10 digits)
                    if (mobile && !/^\d{10}$/.test(mobile.value)) {
                        showError("Please enter a valid 10-digit mobile number.");
                        e.preventDefault();
                        return;
                    }
                    
                    // Password strength (minimum 8 characters)
                    if (password && password.value.length < 8) {
                        showError("Password must be at least 8 characters long.");
                        e.preventDefault();
                        return;
                    }
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

<%@ include file="Base.jsp" %>