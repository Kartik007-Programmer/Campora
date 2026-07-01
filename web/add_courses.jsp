<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.Course" %>
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

    
    if (request.getAttribute("courses") == null) {
        try {
            DAO courseDAO = new DAO();
            List<Course> courses = courseDAO.getLastTwoCourses();
            List<String> ccategories = courseDAO.getAllCategoriesOfCourses(true);
            request.setAttribute("ccategories", ccategories);
            request.setAttribute("courses", courses);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
    }
%>

<!-- Set variables for base.jsp -->
<c:set var="pageTitle" value="Add Courses - Campora Admin" scope="request" />

<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mdi/font@6.5.95/css/materialdesignicons.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #121212;
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
        .wrapper {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 15px;
        }
    
        h2 {
            margin-bottom: 20px;
            color: #ffffff;
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
            right: 30px;
            top: 50%;
            transform: translateY(-60%);
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 2px;
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
            opacity: 0.85;
        }

        .card-buttons button:nth-child(2):hover {
            background-color: #81d4fa;
            color: #121212;
            opacity: 0.85;
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
        
        .highlight-row {
            background-color: #fff3cd !important;
            transition: background-color 0.3s ease;
        }
    </style>
</c:set>

<c:set var="pageContent" scope="request">
    <div class="page-header">
        <h3 class="page-title">Add a Course</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Forms</a></li>
                <li class="breadcrumb-item active" aria-current="page">Form elements</li>
            </ol>
        </nav>
    </div>
    
    <div class="row">
        <div class="col-md-6 grid-margin stretch-card">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title">Courses Form</h4>
                    <p class="card-description">Course for CAMPORA 2026</p>
                   
                    <form action="<%= request.getContextPath() %>/AddCourseViewCourses" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label>Course photo</label>
                            <!-- Hidden file input -->
                            <input type="file" name="courseImg" class="file-upload-default" accept=".jpg,.png,.svg" style="display:none" required id="fileInput">
                            <div class="input-group col-xs-12">
                                <input type="text" class="form-control file-upload-info" disabled placeholder="Upload image (max 4MB, JPG/PNG/SVG)">
                                <span class="input-group-append">
                                    <button class="file-upload-browse btn btn-primary" type="button" id="browseButton">Upload</button>
                                </span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="courseName">Course Title</label>
                            <input type="text" name="courseName" class="form-control" id="courseName" placeholder="Enter Course Name" required>
                        </div>

                        <div class="form-group">
                            <label for="courseFees">Course Price</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">₹</span>
                                </div>
                                <input type="number" name="courseFees" class="form-control" id="courseFees" placeholder="Enter Course Price" step="0.01" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="courseStar">Course Rating</label>
                            <div class="d-flex align-items-center">
                                <input type="number" name="courseStar" step="0.1" max="5" min="0" class="form-control" id="courseStar" placeholder="Enter Rating" style="width: 130px; margin-right: 10px;" required>
                                <div id="starIcons" style="cursor: pointer;">
                                    <span class="mdi mdi-star-outline text-warning" data-value="1" style="font-size: 22px;"></span>
                                    <span class="mdi mdi-star-outline text-warning" data-value="2" style="font-size: 22px;"></span>
                                    <span class="mdi mdi-star-outline text-warning" data-value="3" style="font-size: 22px;"></span>
                                    <span class="mdi mdi-star-outline text-warning" data-value="4" style="font-size: 22px;"></span>
                                    <span class="mdi mdi-star-outline text-warning" data-value="5" style="font-size: 22px;"></span>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="durationMonths">Course Duration (in months)</label>
                            <div class="input-group">
                                <input type="number" name="durationMonths" class="form-control" id="durationMonths" placeholder="Enter Duration in Months" min="1" required>
                                <div class="input-group-append">
                                    <span class="input-group-text">Months</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="courseCategory">Course Category</label>
                            <select class="form-control" name="courseCategory" id="courseCategory" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                                <option value="">Select Course Category</option>
                                <c:forEach var="ccategories" items="${ccategories}">
                                <option value="${ccategories}">${ccategories}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="maxStudents">Total Students</label>
                            <input type="number" name="maxStudents" class="form-control" id="maxStudents" placeholder="Enter number of enrolled students" min="1" value="20" required>
                        </div>

                        <div class="form-group">
                            <label for="courseDescription">Course Description</label>
                            <textarea rows="4" cols="50" name="courseDescription" class="form-control" id="courseDescription" placeholder="Enter Description.." required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary mr-2">Submit</button>
                        <button type="button" class="btn btn-dark">Cancel</button>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Right Side: Course Profiles Cards -->
        <div class="col-md-6 grid-margin stretch-card">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title">Course Profiles</h4>
                    <p class="card-description">Interactive layout with Edit/Delete options</p>
                    
                    <div class="teacher-container limited" id="teacherContainer">
                        <c:forEach var="course" items="${courses}">
                            <div class="teacher-card">
                                <c:choose>
                                    <c:when test="${not empty course.img}">
                                        <img src="data:image/jpeg;base64,${course.imageBase64}" class="teacher-img" alt="${course.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/no-image.png" class="teacher-img" alt="No image available">
                                    </c:otherwise>
                                </c:choose>             
                                <h3>${course.name}</h3>
                                <p><strong>Fees:</strong> ₹${course.fees}</p>
                                <p><strong>Rating:</strong> ${course.star}/5</p>
                                <p><strong>Duration:</strong> ${course.durationMonths} Months</p>
                                <p><strong>Category:</strong> ${course.category}</p>
                                <p><strong>Seats:</strong> ${course.maxStudents}</p>
                                <p><strong>Description:</strong> ${course.description}</p>
                            
                                <div class="card-buttons">  
                                    <button onclick="location.href='<%= request.getContextPath() %>/EditCourseServlet?id=${course.id}'">Edit</button>
                                    <form action="DeleteCourseServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="courseId" value="${course.id}">
                                        <button type="submit" onclick="return confirm('Are you sure?')">Delete</button>
                                    </form>
                                </div> 
                            </div>
                        </c:forEach>
                    </div>

                    <div class="d-flex justify-content-center mt-4">
                        <button  class="btn btn-outline-secondary btn-sm px-4 py-2 rounded-2 shadow-sm d-flex align-items-center gap-2">
                            <a href="${pageContext.request.contextPath}/view_courses.jsp">
                                <span style="font-weight: bold;">View All Courses</span>
                            </a>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:set>

<c:set var="additionalScripts" scope="request">
    <script>
        // Handle "Upload" button click
        document.getElementById('browseButton').addEventListener('click', function () {
            document.getElementById('fileInput').click();
        });

        // Handle file selection and validation
        document.getElementById('fileInput').addEventListener('change', function () {
            const files = this.files;
            const fileInfoInput = document.querySelector('.file-upload-info');
            let isValid = true;
            let fileNames = [];

            Array.from(files).forEach(file => {
                if (file.size > 4 * 1024 * 1024) {
                    alert("File size exceeds 4MB. Please upload a smaller file.");
                    isValid = false;
                }
                const validFormats = ['image/jpeg', 'image/png', 'image/svg+xml'];
                if (!validFormats.includes(file.type)) {
                    alert("Invalid file format. Only JPG, PNG, SVG are allowed.");
                    isValid = false;
                }
                fileNames.push(file.name);
            });

            if (isValid) {
                fileInfoInput.value = fileNames.join(', ') + " selected";
            } else {
                this.value = ""; // Clear invalid selection
                fileInfoInput.value = "";
            }
        });

        // Star rating logic
        const starInput = document.getElementById('courseStar');
        const starIcons = document.querySelectorAll('#starIcons span');

        function updateStars(value) {
            const fullStars = Math.floor(value);
            const halfStar = value - fullStars >= 0.5;
            starIcons.forEach((star, index) => {
                if (index < fullStars) {
                    star.className = "mdi mdi-star text-warning";
                } else if (index === fullStars && halfStar) {
                    star.className = "mdi mdi-star-half-full text-warning";
                } else {
                    star.className = "mdi mdi-star-outline text-warning";
                }
            });
        }

        // Sync input with stars
        starInput.addEventListener('input', function () {
            const val = parseFloat(this.value);
            if (val >= 0 && val <= 5) updateStars(val);
        });

        // Sync stars with input
        starIcons.forEach(star => {
            star.addEventListener('click', () => {
                const rating = parseInt(star.getAttribute('data-value'));
                starInput.value = rating;
                updateStars(rating);
            });
        });

        // Initialize stars
        updateStars(parseFloat(starInput.value) || 0);

        // Search and filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const searchQuery = urlParams.get('searchQuery');
            const highlightId = urlParams.get('highlightId');
            
            if (searchQuery) {
                document.getElementById('courseSearch').value = searchQuery;
                
                const searchTerm = searchQuery.toLowerCase();
                const rows = document.querySelectorAll('#coursesTable tbody tr');
                
                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    row.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            }
            
            if (highlightId) {
                const row = document.querySelector(`tr[data-id="${highlightId}"]`);
                if (row) {
                    row.classList.add('highlight-row');
                    row.scrollIntoView({behavior: 'smooth', block: 'center'});
                    
                    setTimeout(() => {
                        row.classList.remove('highlight-row');
                    }, 3000);
                }
            }

            // Make table rows clickable to show detail cards
            document.querySelectorAll('.clickable-row').forEach(row => {
                row.addEventListener('click', () => {
                    const targetId = row.getAttribute('data-target');
                    document.getElementById(targetId).checked = true;
                });
            });

            // Search functionality
            document.getElementById('courseSearch').addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                const rows = document.querySelectorAll('#coursesTable tbody tr');
                
                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    row.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            });

            // Filter functionality
            document.getElementById('categoryFilter').addEventListener('change', function() {
                const filterValue = this.value.toLowerCase();
                const rows = document.querySelectorAll('#coursesTable tbody tr');
                
                rows.forEach(row => {
                    if (!filterValue) {
                        row.style.display = '';
                        return;
                    }
                    
                    const category = row.cells[6].textContent.toLowerCase();
                    row.style.display = category.includes(filterValue) ? '' : 'none';
                });
            });

            // Rating filter
            document.getElementById('ratingFilter').addEventListener('change', function() {
                const filterValue = parseInt(this.value) || 0;
                const rows = document.querySelectorAll('#coursesTable tbody tr');
                
                rows.forEach(row => {
                    if (filterValue === 0) {
                        row.style.display = '';
                        return;
                    }
                    
                    const rating = parseInt(row.cells[4].textContent);
                    row.style.display = rating >= filterValue ? '' : 'none';
                });
            });
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