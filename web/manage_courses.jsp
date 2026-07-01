<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.*" %>
<%@ page import="mypackage.DAO" %>
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
            List<Course> courses = courseDAO.getAllCourses();
            List<String> ccategories = courseDAO.getAllCategoriesOfCourses(true);
            request.setAttribute("ccategories", ccategories);
            request.setAttribute("courses", courses);
            request.setAttribute("courseList", courses); // For dropdown in edit form
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
    }
%>

<!-- Set variables for base.jsp -->
<c:set var="pageTitle" value="Manage Courses - Campora Admin Panel" scope="request" />

<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mdi/font@6.5.95/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #121212;
            color: #e0e0e0;
        }
    
        .wrapper {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 15px;
        }

        .course-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }
    
        .course-card {
            flex: 1 1 calc(25% - 20px);
            min-width: 280px;
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
        }
    
        .course-card h3 {
            color: #81d4fa;
            margin-bottom: 15px;
            font-weight: bold;
            font-size: 1.1rem;
        }
    
        .course-card:hover {
            transform: scale(1.02);
            box-shadow: 0 0 10px rgba(129, 212, 250, 0.3);
            border-color: #81d4fa;
            color: #ffffff;
        }

        .course-card .course-img {
            position: absolute;
            right: 15px;
            top: 80px;
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #81d4fa;
            transition: transform 0.3s ease;
        }

        .course-card .course-img:hover {
            transform: scale(1.1);
        }

        .course-info {
            flex-grow: 1;
            margin-right: 90px;
        }

        .course-info p {
            margin: 8px 0;
            font-size: 0.9rem;
            color: #b8b8b8;
        }

        .course-description {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
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
            cursor: pointer;
            transition: 0.3s ease;
            border: 1px solid;
        }

        .btn-edit {
            background-color: rgba(255, 193, 7, 0.1);
            color: #ffc107;
            border-color: #ffc107;
        }

        .btn-edit:hover {
            background-color: #ffc107;
            color: #121212;
        }

        .btn-delete {
            background-color: rgba(244, 67, 54, 0.1);
            color: #f44336;
            border-color: #f44336;
        }

        .btn-delete:hover {
            background-color: #f44336;
            color: white;
        }

        .no-courses-card {
            background: #191c24;
            border: 2px dashed #81d4fa;
            border-radius: 12px;
            padding: 60px 40px;
            text-align: center;
            margin: 40px auto;
            max-width: 400px;
        }

        /* Search highlighting */
        .highlight {
            background-color: #FFEB3B;
            color: #000;
            padding: 0 2px;
            border-radius: 3px;
            font-weight: bold;
        }

        /* Highlight animation for new/updated courses */
        @keyframes highlight-pulse {
            0%, 100% { 
                box-shadow: 0 0 0 0 rgba(129, 212, 250, 0.7);
                border-color: #2c2c2c;
            }
            50% { 
                box-shadow: 0 0 0 10px rgba(129, 212, 250, 0);
                border-color: #81d4fa;
            }
        }
        
        /* Modal Styles */
        .course-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        
        .course-modal.active {
            opacity: 1;
            visibility: visible;
        }
        
        .modal-content {
            background: #191c24;
            border: 1px solid #2c2c2c;
            border-radius: 10px;
            width: 85%;
            max-width: 600px;
            max-height: 85vh;
            overflow-y: auto;
            padding: 25px;
            position: relative;
            box-shadow: 0 0 25px rgba(129, 212, 250, 0.2);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #2c2c2c;
            padding-bottom: 15px;
        }
        
        .modal-title {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: nowrap;
        }

        .modal-title h2 {
            margin: 0;
            font-size: 24px;
            color: #81d4fa;
            flex-shrink: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .modal-badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            background-color: #4caf50;
            color: white;
        }
        
        .modal-content .close {
            color: #81d4fa;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 28px;
            line-height: 1;
            font-weight: bold;
        }
        
        .modal-content .close:hover {
            color: #ffffff;
            transform: scale(1.1);
        }
        
        .modal-img {
            display: block;
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
            border: 3px solid #81d4fa;
            margin: 0 auto 20px;
            box-shadow: 0 4px 15px rgba(129, 212, 250, 0.3);
        }

        .modal-details {
            display: grid;
            grid-template-columns: 1fr;
            gap: 12px;
            margin-top: 20px;
        }

        .modal-details p {
            margin: 8px 0;
            padding-bottom: 8px;
            border-bottom: 1px solid #2c2c2c;
            font-size: 15px;
        }

        .modal-details strong {
            color: #81d4fa;
        }

        .modal-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #2c2c2c;
        }

        .action-buttons {
            display: none;
            gap: 10px;
        }

        .btn-manage {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: #81d4fa;
            color: #121212;
            border: 1px solid #81d4fa;
            font-weight: bold;
        }

        .btn-manage:hover {
            background-color: #4fc3f7;
        }

        .btn-edit-modal {
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: #ffc107;
            color: #121212;
            border: 1px solid #ffc107;
        }

        .btn-edit-modal:hover {
            background-color: #ffab00;
        }

        .btn-delete-modal {
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: #f44336;
            color: white;
            border: 1px solid #f44336;
        }

        .btn-delete-modal:hover {
            background-color: #e53935;
        }

        /* Edit form styles */
        .edit-form {
            margin-top: 20px;
            padding: 20px;
            background: rgba(45, 45, 45, 0.3);
            border-radius: 8px;
            border: 1px solid #2c2c2c;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #81d4fa;
            font-weight: bold;
        }

        .edit-form .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #444;
            border-radius: 4px;
            background-color: #2a2a2a;
            color: #e0e0e0;
            box-sizing: border-box;
        }

        .edit-form .form-control:focus {
            outline: none;
            border-color: #81d4fa;
            box-shadow: 0 0 5px rgba(129, 212, 250, 0.3);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #2c2c2c;
        }

        .btn-save {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: #4CAF50;
            color: white;
            border: 1px solid #4CAF50;
            font-weight: bold;
        }

        .btn-save:hover {
            background-color: #45a049;
        }

        .btn-cancel {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: #f44336;
            color: white;
            border: 1px solid #f44336;
        }

        .btn-cancel:hover {
            background-color: #e53935;
        }

        /* Filter styles */
        #courseSearch,
        #categoryFilter,
        #durationFilter,
        #pageFilter {
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #courseSearch:focus,
        #categoryFilter:focus,
        #durationFilter:focus,
        #pageFilter:focus {
            outline: none;
            box-shadow: 0 0 0 2px #a5b4fc;
            border-color: #81d4fa;
        }

        /* Alert styles */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }

        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }

        /* Responsive design */
        @media (max-width: 992px) {
            .course-card {
                flex: 1 1 calc(50% - 20px);
            }
        }

        @media (max-width: 768px) {
            .course-card {
                flex: 1 1 100%;
            }
            
            .modal-content {
                width: 95%;
                padding: 20px;
                max-height: 90vh;
            }
            
            .modal-img {
                width: 120px;
                height: 120px;
            }

            .course-info {
                margin-right: 0;
                margin-bottom: 90px;
            }

            .course-card .course-img {
                position: static;
                width: 100%;
                height: 160px;
                margin-bottom: 15px;
            }
        }
    </style>
</c:set>

<c:set var="pageContent" scope="request">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <h3 class="page-title mb-0">Manage Courses</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}Admin_penal.jsp">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Manage Courses</li>
            </ol>
        </nav>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.success}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.error}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

    <!-- Filters Card Section -->
    <div class="card mb-3 border-0" style="background-color: transparent;">
        <div class="card-body py-2 px-3">
            <div class="row align-items-end g-3">
                <div class="col-md-3">
                    <label class="form-label mb-1 small" for="courseSearch">Search</label>
                    <input type="text" class="form-control form-control-sm" placeholder="Search courses" id="courseSearch">
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="categoryFilter">Category</label>
                    <select class="form-control form-control-sm" id="categoryFilter">
                        <option value="">All Categories</option>
                        <c:forEach var="ccategories" items="${ccategories}">
                        <option value="${ccategories}">${ccategories}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="durationFilter">Duration</label>
                    <select class="form-control form-control-sm" id="durationFilter">
                        <option value="">All Durations</option>
                        <option value="1-3">1-3 Months</option>
                        <option value="4-6">4-6 Months</option>
                        <option value="7-12">7-12 Months</option>
                        <option value="12+">12+ Months</option>
                    </select>
                </div>

                <div class="col-md-2"></div>

                <div class="col-md-3 d-flex justify-content-end align-items-end">
                    <div style="width: 65%;">
                        <label class="form-label mb-1 small text-white d-block text-center">Add</label>
                        <a href="${pageContext.request.contextPath}/add_courses.jsp">
                            <button class="btn btn-sm d-flex align-items-center justify-content-center w-100"
                                style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                                <i class="mdi mdi-plus-circle-outline me-1" style="font-size: 14px;"></i> Add Course
                            </button>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Course Cards Container -->
    <div class="wrapper">
        <div class="course-container">
            <c:choose>
                <c:when test="${empty courses}">
                    <div class="col-12 text-center">
                        <div class="no-courses-card">
                            <i class="mdi mdi-book-outline" style="font-size: 48px; color: #81d4fa;"></i>
                            <h4 style="color: #ffffff; margin: 20px 0;">No courses available</h4>
                            <p style="color: #b8b8b8;">Start by adding your first course to the system.</p>
                            <a href="${pageContext.request.contextPath}add_courses.jsp" class="btn" style="background-color: #4f46e5; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">
                                <i class="mdi mdi-plus"></i> Add Course
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="course" items="${courses}">
                        <div class="course-card" 
                             data-id="${course.id}" 
                             data-name="${fn:toLowerCase(course.name)}"
                             data-category="${course.category}"
                             data-duration="${course.durationMonths}"
                             data-description="${fn:toLowerCase(course.description)}"
                             <c:if test="${param.highlightId eq course.id}">style="animation: highlight-pulse 2s ease-in-out;"</c:if>>
                            
                            <!-- Course Image -->
                            <c:choose>
                                <c:when test="${not empty course.img}">
                                    <img class="course-img" src="data:image/jpeg;base64,${course.imageBase64}" alt="${course.name}" />
                                </c:when>
                                <c:otherwise>
                                    <img class="course-img" src="${pageContext.request.contextPath}/assets/images/no-image.png" alt="No image available" />
                                </c:otherwise>
                            </c:choose>
                            
                            <h3 class="course-name highlight-target">${course.name}</h3>
                            <div class="course-info">
                                <p><strong>Category:</strong> <span class="highlight-target">${course.category}</span></p>
                                <p><strong>Duration:</strong> ${course.durationMonths} months</p>
                                <p><strong>Fees:</strong> ₹${course.fees}</p>
                                <p><strong>Rating:</strong> ${course.star}/5 ⭐</p>
                                <p><strong>Max Students:</strong> ${course.maxStudents}</p>
                                <p><strong>Description:</strong> <span class="highlight-target course-description">${course.description}</span></p>
                            </div>
                            
                            <div class="card-buttons">
                                <button class="btn-edit" data-course-id="${course.id}">Edit</button>
                               
                                <form action="${pageContext.request.contextPath}/DeleteCourseServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                    <button type="submit" class="btn-delete" data-course-id="${course.id}" onclick="return confirm('Are you sure?')">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Course Details Modal -->
    <div class="course-modal" id="courseModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <h2 id="modalCourseName">Course Name</h2>
                    <span class="modal-badge badge-active" id="modalCourseStatus">Active</span>
                </div>
                <span class="close">&times;</span>
            </div>
            
            <img id="modalCourseImg" class="modal-img" alt="Course Image">
            
            <div class="modal-details" id="courseDetails">
                <!-- Course details will be populated here -->
            </div>

            <div style="display: none;">
                <form method="get" action="${pageContext.request.contextPath}/EditCourseServlet">
                    <label for="courseId">Select Course to Edit:</label>
                    <select name="id" id="courseId" onchange="this.form.submit()">
                        <option value="">-- Select Course --</option>
                        <c:forEach var="c" items="${courseList}">
                            <option value="${c.id}" ${course.id == c.id ? 'selected' : ''}>${c.name}</option>
                        </c:forEach>
                    </select> 
                </form>
            </div>

            <!-- Edit Form (Initially Hidden) -->
            <div class="edit-form" id="editForm" style="display: none;">
                <form id="courseEditForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="editCourseId" name="courseId" value="">
                    
                    <div class="form-group">
                        <label for="editCourseName">Course Name:</label>
                        <input type="text" id="editCourseName" name="courseName" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editCourseImg">Update Image (optional):</label>
                        <input type="file" id="editCourseImg" name="courseImg" class="form-control" accept="image/*">
                    </div>
                    
                    <div class="form-group">
                        <label for="editCourseFees">Fees:</label>
                        <input type="number" id="editCourseFees" name="courseFees" class="form-control" step="0.01" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editCourseStar">Rating (1-5):</label>
                        <input type="number" id="editCourseStar" name="courseStar" class="form-control" min="1" max="5" step="0.1" required>
                    </div>

                    <div class="form-group">
                        <label for="editDurationMonths">Duration (Months):</label>
                        <input type="number" id="editDurationMonths" name="durationMonths" class="form-control" min="1" required>
                    </div>

                    <div class="form-group">
                        <label for="editCourseCategory">Category:</label>
                        <select id="editCourseCategory" name="courseCategory" class="form-control" required>
                            <option value="">-- Select Category --</option>
                            <option value="Business">Business</option>
                            <option value="Technology">Technology</option>
                            <option value="Sports">Sports</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="editMaxStudents">Max Students:</label>
                        <input type="number" id="editMaxStudents" name="maxStudents" class="form-control" min="1" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editCourseDescription">Description:</label>
                        <textarea id="editCourseDescription" name="courseDescription" class="form-control" rows="5" required></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel">Cancel</button>
                        <button type="submit" class="btn-save">Save Changes</button>
                    </div>
                </form>
            </div>
            
            <div class="modal-actions">
                <button class="btn-manage">Manage</button>
                <div class="action-buttons" style="display: none;">
                    <button class="btn-edit-modal">Edit</button>
                    <form action="${pageContext.request.contextPath}/DeleteCourseServlet" method="post" style="display:inline;">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <button type="submit" class="btn-delete-modal" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>            
                </div>
            </div>
        </div>
    </div>
</c:set>

<c:set var="additionalScripts" scope="request">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // DOM Elements
            const courses = document.querySelectorAll('.course-card');
            const courseSearch = document.getElementById('courseSearch');
            const globalSearch = document.getElementById('searchid');
            const categoryFilter = document.getElementById('categoryFilter');
            const durationFilter = document.getElementById('durationFilter');
            const courseModal = document.getElementById('courseModal');
            const editForm = document.getElementById('editForm');
            const courseDetails = document.getElementById('courseDetails');
            const courseEditForm = document.getElementById('courseEditForm');

            // Initialize search and filters
            performSearch();

            // Search functionality
            function performSearch() {
                const searchTerm = (courseSearch.value || (globalSearch ? globalSearch.value : '')).toLowerCase().trim();
                const selectedCategory = categoryFilter.value;
                const selectedDuration = durationFilter.value;

                courses.forEach(course => {
                    const courseName = (course.getAttribute('data-name') || '').toLowerCase();
                    const courseCategory = (course.getAttribute('data-category') || '').toLowerCase();
                    const courseDescription = (course.getAttribute('data-description') || '').toLowerCase();
                    const courseDuration = parseInt(course.getAttribute('data-duration'));
                    
                    const matchesSearch = !searchTerm || 
                        courseName.includes(searchTerm) || 
                        courseDescription.includes(searchTerm);

                    const matchesCategory = !selectedCategory || courseCategory === selectedCategory.toLowerCase();

                    let matchesDuration = true;
                    if (selectedDuration) {
                        switch (selectedDuration) {
                            case '1-3':
                                matchesDuration = courseDuration >= 1 && courseDuration <= 3;
                                break;
                            case '4-6':
                                matchesDuration = courseDuration >= 4 && courseDuration <= 6;
                                break;
                            case '7-12':
                                matchesDuration = courseDuration >= 7 && courseDuration <= 12;
                                break;
                            case '12+':
                                matchesDuration = courseDuration > 12;
                                break;
                        }
                    }

                    const shouldShow = matchesSearch && matchesCategory && matchesDuration;
                    
                    if (shouldShow) {
                        course.style.display = 'flex';
                        
                        if (searchTerm) {
                            highlightSearchTerm(course, searchTerm);
                        } else {
                            removeHighlights(course);
                        }
                    } else {
                        course.style.display = 'none';
                    }
                });
            }

            function escapeHtml(str) {
                return String(str)
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#039;');
            }

            function highlightSearchTerm(card, term) {
                if (!term) return;
                const search = term.trim().toLowerCase();
                if (!search) return;
                const targets = card.querySelectorAll('.highlight-target');
                targets.forEach(target => {
                    if (!target.dataset.originalHtml) {
                        target.dataset.originalHtml = target.innerHTML;
                    }
                    const text = target.textContent || '';
                    const lowerText = text.toLowerCase();

                    let startIndex = 0;
                    let result = '';
                    let idx;
                    while ((idx = lowerText.indexOf(search, startIndex)) !== -1) {
                        result += escapeHtml(text.slice(startIndex, idx));
                        result += '<span class="highlight">' + escapeHtml(text.slice(idx, idx + search.length)) + '</span>';
                        startIndex = idx + search.length;
                    }
                    result += escapeHtml(text.slice(startIndex));

                    target.innerHTML = result;
                });
            }

            function removeHighlights(card) {
                const targets = card.querySelectorAll('.highlight-target');
                targets.forEach(target => {
                    if (target.dataset.originalHtml !== undefined) {
                        target.innerHTML = target.dataset.originalHtml;
                        delete target.dataset.originalHtml;
                    } else {
                        const spans = target.querySelectorAll('span.highlight');
                        spans.forEach(span => span.replaceWith(document.createTextNode(span.textContent)));
                    }
                });
            }

            // Event listeners for search and filters
            courseSearch.addEventListener('input', performSearch);
            if (globalSearch) globalSearch.addEventListener('input', performSearch);
            categoryFilter.addEventListener('change', performSearch);
            durationFilter.addEventListener('change', performSearch);

            // Course modal functionality
            courses.forEach(course => {
                course.addEventListener('click', function(e) {
                    if (e.target.classList.contains('btn-edit') || e.target.classList.contains('btn-delete')) {
                        return;
                    }
                    showCourseModal(this);
                });
            });

            function showCourseModal(courseCard) {
                const courseId = courseCard.getAttribute('data-id');
                const courseName = courseCard.querySelector('.course-name').textContent;
                const courseImg = courseCard.querySelector('.course-img');
                const courseInfo = courseCard.querySelector('.course-info');
                
                document.getElementById('modalCourseName').textContent = courseName;
                document.getElementById('modalCourseImg').src = courseImg.src;
                document.getElementById('modalCourseImg').alt = courseImg.alt;
                
                const infoPs = courseInfo.querySelectorAll('p');
                let detailsHTML = '';
                infoPs.forEach(p => {
                    detailsHTML += '<p>' + p.innerHTML + '</p>';
                });
                
                detailsHTML += '<p><strong>Course ID:</strong> ' + courseId + '</p>';
                detailsHTML += '<p><strong>Status:</strong> Active</p>';
                detailsHTML += '<p><strong>Created:</strong> ' + new Date().toLocaleDateString() + '</p>';

                courseDetails.innerHTML = detailsHTML;
                
                courseModal.classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            function closeModal() {
                courseModal.classList.remove('active');
                editForm.style.display = 'none';
                courseDetails.style.display = 'block';
                document.querySelector('.action-buttons').style.display = 'none';
                document.body.style.overflow = '';
            }

            // Modal event listeners
            courseModal.querySelector('.close').addEventListener('click', closeModal);
            courseModal.addEventListener('click', function(e) {
                if (e.target === courseModal) {
                    closeModal();
                }
            });

            // Manage buttons functionality
            document.querySelector('.btn-manage').addEventListener('click', function() {
                const actionButtons = document.querySelector('.action-buttons');
                actionButtons.style.display = actionButtons.style.display === 'none' ? 'flex' : 'none';
            });

            // Edit modal functionality
            document.querySelector('.btn-edit-modal').addEventListener('click', function() {
                if (editForm.style.display === 'none' || !editForm.style.display) {
                    editForm.style.display = 'block';
                    courseDetails.style.display = 'none';
                    populateEditForm();
                }
            });

            document.querySelector('.btn-cancel').addEventListener('click', function() {
                editForm.style.display = 'none';
                courseDetails.style.display = 'block';
            });

            // Populate edit form with course data
            function populateEditForm() {
                const courseDetails = document.getElementById('courseDetails');
                const details = courseDetails.querySelectorAll('p');

                let category = '', duration = '', fees = '', rating = '', 
                    maxStudents = '', description = '', courseId = '';
                
                details.forEach(p => {
                    const text = p.textContent;
                    if (text.includes('Category:')) category = text.split('Category:')[1].trim();
                    if (text.includes('Duration:')) duration = text.split('Duration:')[1].replace(' months', '').trim();
                    if (text.includes('Fees:')) fees = text.split('₹')[1].trim();
                    if (text.includes('Rating:')) rating = text.split('Rating:')[1].replace('/5 ⭐', '').trim();
                    if (text.includes('Max Students:')) maxStudents = text.split('Max Students:')[1].trim();
                    if (text.includes('Description:')) description = text.split('Description:')[1].trim();
                    if (text.includes('Course ID:')) courseId = text.split('Course ID:')[1].trim();
                });

                document.getElementById('editCourseId').value = courseId;
                document.getElementById('editCourseName').value = document.getElementById('modalCourseName').textContent;
                document.getElementById('editCourseFees').value = fees;
                document.getElementById('editCourseStar').value = rating;
                document.getElementById('editDurationMonths').value = duration;
                document.getElementById('editCourseCategory').value = category;
                document.getElementById('editMaxStudents').value = maxStudents;
                document.getElementById('editCourseDescription').value = description;
            }

            // Edit form submission
            courseEditForm.addEventListener('submit', function(e) {
                e.preventDefault();
                
                const formData = new FormData(this);
                const courseId = formData.get('courseId');
                
                fetch('${pageContext.request.contextPath}/EditCourseServlet', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        if (response.redirected) {
                            return "success";
                        }
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.text();
                })
                .then(data => {
                    alert('Course updated successfully!');
                    window.location.href = "${pageContext.request.contextPath}/manage_courses.jsp?highlightId=" + courseId;
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating course. Please try again.');
                });
            });
            
            // Check if we have a course ID to edit from session/URL
            const editCourseIdFromSession = '<%= session.getAttribute("editCourseId") %>';
            const urlParams = new URLSearchParams(window.location.search);
            const highlightId = urlParams.get('highlightId');
            const editCourseId = highlightId || (editCourseIdFromSession !== 'null' ? editCourseIdFromSession : null);

            if (editCourseId) {
                const courseCard = document.querySelector(`.course-card[data-id="${editCourseId}"]`);
                
                if (courseCard) {
                    courseCard.scrollIntoView({behavior: 'smooth', block: 'center'});
                    courseCard.style.animation = 'highlight-pulse 2s ease-in-out';
                    
                    if (editCourseIdFromSession && editCourseIdFromSession !== 'null') {
                        const editButton = courseCard.querySelector('.btn-edit');
                        if (editButton) {
                            fetch('${pageContext.request.contextPath}/ClearEditCourseIdServlet')
                                .then(() => {
                                    setTimeout(() => {
                                        editButton.click();
                                    }, 300);
                                });
                        }
                    }
                }
            }

            // Delete functionality
            document.querySelector('.btn-delete-modal').addEventListener('click', function() {
                const courseId = document.getElementById('editCourseId').value || 
                               document.getElementById('modalCourseName').textContent;
                
                if (confirm('Are you sure you want to delete this course?')) {
                    // Delete logic here
                }
            });

            document.querySelectorAll('.btn-delete').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.stopPropagation();
                    e.preventDefault();
                    const form = this.closest('form');
                    const courseId = form.querySelector('input[name="courseId"]').value;
                    
                    if (confirm('Are you sure you want to delete this course?')) {
                        form.submit();
                    }
                });
            });

            // Edit buttons on cards
            document.querySelectorAll('.btn-edit').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const courseId = this.getAttribute('data-course-id');
                    const courseCard = this.closest('.course-card');
                    showCourseModal(courseCard);
                    
                    setTimeout(() => {
                        document.querySelector('.btn-manage').click();
                        document.querySelector('.btn-edit-modal').click();
                    }, 100);
                });
            });

            // Handle URL parameters for search
            const searchQuery = urlParams.get('searchQuery');
            if (searchQuery) {
                courseSearch.value = searchQuery;
                performSearch();
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