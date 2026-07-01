<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.Student" %>
<%@ page import="mypackage.*" %>
<%@ page import="java.sql.SQLException" %>
<%   
    DAO dao = new DAO();
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
    Admin admin = dao.getAdminByUsername(AdminUsername);
    request.setAttribute("admin", admin);
%>

<%
if (request.getAttribute("students") == null) {
    try {
        DAO studentDAO = new DAO();
        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.setAttribute("studentList", students);          // for dropdown in edit form
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }
}
%>

<%-- Separate block for pending students --%>
<% 
if (request.getAttribute("pendingStudents") == null) {
    try {
        List<Course> courses = dao.getAllCourses();
        request.setAttribute("courses", courses);
        List<Student> pendingStudents = dao.getPendingStudents();
        request.setAttribute("pendingStudents", pendingStudents);
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }
}
%>

<%-- Set template variables for base.jsp --%>
<c:set var="pageTitle" value="Manage Students - Campora Admin Panel" scope="request" />

<c:set var="pageContent" scope="request">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <h3 class="page-title mb-0">Manage Students</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/Dashboard/Admin_penal.jsp">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Manage Students</li>
            </ol>
        </nav>
    </div>

    <!-- ALERTS -->
    <%
        String success = (String) request.getAttribute("success");
        if (success != null) {
    %>
        <script>alert('<%= success %>');</script>
    <%
        }
    %>
    
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

    <!-- FILTERS -->
    <div class="card mb-3 border-0" style="background-color: transparent;">
        <div class="card-body py-2 px-3">
            <div class="row align-items-end g-3">
                <div class="col-md-3">
                    <label class="form-label mb-1 small" for="studentSearch">Search</label>
                    <input type="text" class="form-control form-control-sm" placeholder="Search students" id="studentSearch">
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="courseFilter">Course</label>
                    <select class="form-control form-control-sm" id="courseFilter">
                        <option value="">All Courses</option>
                        <c:forEach var="course" items="${courses}"> 
                            <option value="${course.name}">${course.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="genderFilter">Gender</label>
                    <select class="form-control form-control-sm" id="genderFilter">
                        <option value="">All Genders</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <!-- Empty column for spacing -->
                </div>

                <div class="col-md-3 d-flex justify-content-end align-items-end">
                    <div style="width: 65%;">
                        <label class="form-label mb-1 small text-white d-block text-center">Add</label>
                        <a href="${pageContext.request.contextPath}/add_students.jsp">
                            <button class="btn btn-sm d-flex align-items-center justify-content-center w-100"
                                style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                                <i class="mdi mdi-plus-circle-outline me-1" style="font-size: 14px;"></i> Add Student
                            </button>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Pending Students Table -->
    <div class="row mt-5">
        <div class="col-lg-12 grid-margin stretch-card">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="card-title mb-0">Students Pending Approval</h4>
                        <div class="d-flex">
                            <button id="editModeBtn" class="btn btn-primary btn-sm mr-2">
                                <i class="mdi mdi-pencil"></i> Edit
                            </button>
                            <button id="deleteSelectedBtn" class="btn btn-danger btn-sm d-none">
                                <i class="mdi mdi-delete"></i> Delete Selected
                            </button>
                        </div>
                    </div>

                    <div class="table-responsive">
                     <c:choose>
                      <c:when test="${empty pendingStudents}"> 
                        <div class="alert alert-info bg-dark border-info" role="alert">
                            <div class="d-flex align-items-center">
                                <i class="mdi mdi-information-outline mr-3" style="font-size: 24px;"></i>
                                <div>
                                    <h6 class="alert-heading mb-1 text-white">No Pending Applications</h6>
                                    <p class="mb-0 text-light">There are currently no students waiting for approval.</p>
                                </div>
                            </div>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <table class="table table-hover" id="pendingStudentTable">
                            <thead class="thead-light">
                                <tr>
                                    <th class="checkbox-col d-none" style="width: 40px;">
                                        <div class="form-check form-check-muted m-0">
                                            <label class="form-check-label">
                                                <input type="checkbox" class="form-check-input" id="selectAllCheckbox">
                                            </label>
                                        </div>
                                    </th>
                                    <th>Student Name</th>
                                    <th>ID</th>
                                    <th>Course</th>
                                    <th>Phone</th>
                                    <th>Admission Date</th>
                                    <th>Status</th>
                                    <th style="width: 120px;">Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="student" items="${pendingStudents}">
                                <tr>
                                    <td class="checkbox-col d-none">
                                        <div class="form-check form-check-muted m-0">
                                            <label class="form-check-label">
                                                <input type="checkbox" class="form-check-input row-checkbox" data-id="${student.id}">
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty student.photo}">
                                                    <img src="data:image/jpeg;base64,${student.imageBase64}" class="rounded-circle" alt="image" width="40" height="40">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/assets/images/faces/face1.jpg" class="rounded-circle" alt="image" width="40" height="40">
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="ml-3">
                                                <span class="d-block font-weight-bold">${student.firstName} ${student.lastName}</span>
                                                <small class="text-muted">${student.email}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${student.id}</td>
                                    <td>${student.course}</td>
                                    <td>${student.mobile}</td>
                                    <td><fmt:formatDate value="${student.registrationDate}" pattern="dd MMM yyyy"/></td>
                                    <td><span class="badge badge-warning">${student.status}</span></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="studentId" value="${student.id}">
                                            
                                                <button type="submit" name="status" value="APPROVED" 
                                                        class="btn btn-sm btn-outline-success approve-btn" title="Approve">
                                                    <i class="mdi mdi-check"></i>
                                                </button>
                                                <button type="submit" name="status" value="REJECTED" 
                                                        class="btn btn-sm btn-outline-danger reject-btn" title="Reject">
                                                    <i class="mdi mdi-close"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                      </c:otherwise>   
                     </c:choose>     
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- STUDENT CARDS -->
    <div class="wrapper">
        <div class="teacher-container">
            <c:choose>
                <c:when test="${empty students}">
                    <div class="col-12 text-center">
                        <div class="no-teachers-card">
                            <i class="mdi mdi-account" style="font-size: 48px; color: #81d4fa;"></i>
                            <h4 style="color: #ffffff; margin: 20px 0;">No students available</h4>
                            <p style="color: #b8b8b8;">Start by adding your first student to the system.</p>
                            <a href="${pageContext.request.contextPath}/add_students.jsp" class="btn" style="background-color: #4f46e5; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">
                                <i class="mdi mdi-plus"></i> Add Student
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="student" items="${students}">
                        <div class="teacher-card"
                             data-id="${student.id}"
                             data-name="${fn:toLowerCase(student.firstName)} ${fn:toLowerCase(student.lastName)}"
                             data-course="${student.course}"
                             data-gender="${student.gender}"
                             data-email="${fn:toLowerCase(student.email)}"
                             data-lyp="${student.lastYearPercentage}"
                             data-registrationDate="${student.registrationDate}"
                             data-processedDate="${student.processedDate}"
                             data-status="${fn:toLowerCase(student.status)}"
                             data-qualification="${fn:toLowerCase(student.qualification)}"
                             data-addressLine1="${fn:toLowerCase(student.addressLine1)}"
                             data-addressLine2="${fn:toLowerCase(student.addressLine2)}"
                             data-landmark="${fn:toLowerCase(student.landmark)}"
                             data-pincode="${student.pincode}"
                             data-state="${fn:toLowerCase(student.state)}"
                             data-city="${fn:toLowerCase(student.city)}"
                             <c:if test="${param.highlightId eq student.id}">style="animation: highlight-pulse 2s ease-in-out;"</c:if>>
                            
                            <!-- Student Image -->
                            <c:choose>
                                <c:when test="${not empty student.photo}">
                                    <img class="teacher-img" src="data:image/jpeg;base64,${student.imageBase64}" alt="${student.firstName} ${student.lastName}" />
                                </c:when>
                                <c:otherwise>
                                    <img class="teacher-img" src="${pageContext.request.contextPath}/assets/images/no-image.png" alt="No image available" />
                                </c:otherwise>
                            </c:choose>

                            <h3 class="teacher-name highlight-target">${student.firstName} ${student.lastName}</h3>
                            <div class="teacher-info">
                                <p><strong>Course:</strong> <span class="highlight-target">${student.course}</span></p>
                                <p><strong>Email:</strong> ${student.email}</p>
                                <p><strong>Mobile:</strong> ${student.mobile}</p>
                                <p><strong>Gender:</strong> ${student.gender}</p>
                                <p><strong>DOB:</strong> ${student.dob}</p>
                                <p><strong>Last Year Percentage(LYP):</strong> ${student.lastYearPercentage} %</p>
                            </div>

                            <div class="card-buttons">
                                <form action="${pageContext.request.contextPath}/edit-student" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="${student.id}" />
                                    <button type="submit" class="btn-edit">Edit</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/DeleteStudentServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="studentId" value="${student.id}">
                                    <button type="submit" class="btn-delete" onclick="return confirm('Are you sure?')">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- ========== STUDENT MODAL ========== -->
    <div class="teacher-modal" id="studentModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <h2 id="modalStudentName">Student Name</h2>
                    <span class="modal-badge badge-active">Active</span>
                </div>
                <span class="close">&times;</span>
            </div>

            <img id="modalStudentImg" class="modal-img" alt="Student Image">

            <div class="modal-details" id="studentDetails">
                <!-- Details will be populated by JavaScript -->
            </div>

            <!-- The inline edit form is removed -->

            <div class="modal-actions">
                <button class="btn-manage">Manage</button>
                <div class="action-buttons" style="display:none;">
                    <button class="btn-edit-modal">Edit</button>
                    <form action="${pageContext.request.contextPath}/DeleteStudentServlet" method="post" style="display:inline;">
                        <input type="hidden" id="hiddenDeleteId" name="studentId">
                        <button type="submit" class="btn-delete-modal" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</c:set>

<c:set var="additionalCSS" scope="request">
    
    <style>
        /* Student card styles */
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
        .teacher-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }
        .teacher-card {
            flex: 1 1 calc(25% - 20px);
            min-width: 280px;
            background: #191c24;
            border: 1px solid #2c2c2c;
            border-radius: 8px;
            padding: 16px;
            box-sizing: border-box;
            transition: all .3s;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .teacher-card h3 {
            color: #81d4fa;
            margin-bottom: 15px;
            font-weight: bold;
            font-size: 1.1rem;
        }
        .teacher-card:hover {
            transform: scale(1.02);
            box-shadow: 0 0 10px rgba(129, 212, 250, .3);
            border-color: #81d4fa;
            color: #fff;
        }
        .teacher-card .teacher-img {
            position: absolute;
            right: 15px;
            top: 15px;
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #81d4fa;
            transition: transform .3s;
        }
        .teacher-card .teacher-img:hover {
            transform: scale(1.1);
        }
        .teacher-info {
            flex-grow: 1;
            margin-right: 90px;
        }
        .teacher-info p {
            margin: 8px 0;
            font-size: .9rem;
            color: #b8b8b8;
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
            transition: .3s;
            border: 1px solid;
        }
        .btn-edit {
            background-color: rgba(255, 193, 7, .1);
            color: #ffc107;
            border-color: #ffc107;
        }
        .btn-edit:hover {
            background-color: #ffc107;
            color: #121212;
        }
        .btn-delete {
            background-color: rgba(244, 67, 54, .1);
            color: #f44336;
            border-color: #f44336;
        }
        .btn-delete:hover {
            background-color: #f44336;
            color: white;
        }
        .no-teachers-card {
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
        
        @keyframes highlight-pulse {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(129, 212, 250, .7);
                border-color: #2c2c2c;
            }
            50% {
                box-shadow: 0 0 0 10px rgba(129, 212, 250, 0);
                border-color: #81d4fa;
            }
        }
        /* modal styles */
        .teacher-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, .8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000;
            opacity: 0;
            visibility: hidden;
            transition: all .3s;
        }
        .teacher-modal.active {
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
            padding: 25px;
            position: relative;
            overflow-y: auto;
            box-shadow: 0 0 25px rgba(129, 212, 250, .2);
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
        }
        .modal-title h2 {
            margin: 0;
            font-size: 24px;
            color: #81d4fa;
        }
        .modal-badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            background: #4caf50;
            color: white;
        }
        .modal-content .close {
            color: #81d4fa;
            cursor: pointer;
            font-size: 28px;
            line-height: 1;
        }
        .modal-content .close:hover {
            color: #fff;
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
            box-shadow: 0 4px 15px rgba(129, 212, 250, .3);
        }
        .modal-details {
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
            background: #81d4fa;
            color: #121212;
            border: 1px solid #81d4fa;
            font-weight: bold;
        }
        .btn-manage:hover {
            background: #4fc3f7;
        }
        .btn-edit-modal {
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            background: #ffc107;
            color: #121212;
            border: 1px solid #ffc107;
        }
        .btn-edit-modal:hover {
            background: #ffab00;
        }
        .btn-delete-modal {
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            background: #f44336;
            color: white;
            border: 1px solid #f44336;
        }
        .btn-delete-modal:hover {
            background: #e53935;
        }
        .edit-form {
            margin-top: 20px;
            padding: 20px;
            background: rgba(45, 45, 45, .3);
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
            background: #2a2a2a;
            color: #e0e0e0;
        }
        .edit-form .form-control:focus {
            outline: none;
            border-color: #81d4fa;
            box-shadow: 0 0 5px rgba(129, 212, 250, .3);
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
            background: #4caf50;
            color: white;
            border: 1px solid #4caf50;
            font-weight: bold;
        }
        .btn-save:hover {
            background: #45a049;
        }
        .btn-cancel {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            background: #f44336;
            color: white;
            border: 1px solid #f44336;
        }
        .btn-cancel:hover {
            background: #e53935;
        }
        
                /* Filter styles */
        #studentSearch,
        #genderFilter,
        #courseFilter {
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #studentSearch:focus,
        #courseFilter:focus,
        #genderFilter:focus{
            outline: none;
            box-shadow: 0 0 0 2px #a5b4fc;
            border-color: #81d4fa;
        }
        
        @media (max-width: 992px) {
            .teacher-card {
                flex: 1 1 calc(50% - 20px);
            }
        }
        @media (max-width: 768px) {
            .teacher-card {
                flex: 1 1 100%;
            }
        }
    </style>
</c:set>

<c:set var="additionalScripts" scope="request">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // DOM Elements
            const students = document.querySelectorAll('.teacher-card');
            const studentSearch = document.getElementById('studentSearch');
            const globalSearch = document.querySelector('#globalSearch');
            const courseFilter = document.getElementById('courseFilter');
            const genderFilter = document.getElementById('genderFilter');
            const pageFilter = document.getElementById('pageFilter');
            const modal = document.getElementById('studentModal');
            const studentDetailsContainer = document.getElementById('studentDetails');

            /* SEARCH & FILTER FUNCTIONALITY */
            function performSearch() {
                const term = (studentSearch.value || globalSearch?.value || '').toLowerCase();
                const course = courseFilter.value;
                const gender = genderFilter.value;
                const perPage = pageFilter?.value || 'all';
                let visibleCount = 0;
                const maxVisible = perPage === 'all' ? Infinity : parseInt(perPage);

                students.forEach(card => {
                    const name = card.getAttribute('data-name');
                    const crs = card.getAttribute('data-course');
                    const gen = card.getAttribute('data-gender');
                    const email = card.getAttribute('data-email');

                    const matchesSearch = !term || name.includes(term) || email.includes(term);
                    const matchesCourse = !course || crs === course;
                    const matchesGender = !gender || gen === gender;
                    const shouldShow = matchesSearch && matchesCourse && matchesGender && visibleCount < maxVisible;

                    card.style.display = shouldShow ? 'flex' : 'none';
                    
                    // Apply or remove highlights
                    if (shouldShow && term) {
                        highlightSearchTerm(card, term);
                    } else {
                        removeHighlights(card);
                    }
                    
                    if (shouldShow) visibleCount++;
                });
            }

            // Highlight functionality
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

            // Event listeners for search/filter
            if (studentSearch) studentSearch.addEventListener('input', performSearch);
            if (globalSearch) globalSearch.addEventListener('input', performSearch);
            if (courseFilter) courseFilter.addEventListener('change', performSearch);
            if (genderFilter) genderFilter.addEventListener('change', performSearch);
            if (pageFilter) pageFilter.addEventListener('change', performSearch);

            /* MODAL FUNCTIONALITY */
            function openModal(card) {
                // Get basic info from the card
                const id = card.dataset.id;
                const name = card.querySelector('.teacher-name').textContent;
                const imgSrc = card.querySelector('.teacher-img').src;
                
                // Get detailed info from the paragraphs inside the card
                const infoParagraphs = card.querySelectorAll('.teacher-info p');
                let detailsHtml = '';
                detailsHtml += `<p><strong>Student ID:</strong> ${id}</p>`;
                
                infoParagraphs.forEach(p => {
                    detailsHtml += `<p>${p.innerHTML}</p>`;
                });
          
                detailsHtml += `<p><strong>Qualification:</strong> ${card.getAttribute('data-qualification')}</p>`;
                detailsHtml += `<p><strong>Status:</strong> ${card.getAttribute('data-status')}</p>`;
                detailsHtml += `<p><strong>Address Line 1:</strong> ${card.getAttribute('data-addressLine1')}</p>`;
                detailsHtml += `<p><strong>Address Line 2:</strong> ${card.getAttribute('data-addressLine2')}</p>`;
                detailsHtml += `<p><strong>Landmark:</strong> ${card.getAttribute('data-landmark')}</p>`;
                detailsHtml += `<p><strong>Pincode:</strong> ${card.getAttribute('data-pincode')}</p>`;
                detailsHtml += `<p><strong>State:</strong> ${card.getAttribute('data-state')}</p>`;
                detailsHtml += `<p><strong>City:</strong> ${card.getAttribute('data-city')}</p>`;
                detailsHtml += `<p><strong>Registration Date:</strong> ${card.getAttribute('data-registrationDate')}</p>`;
                    
          
                // Populate the modal elements
                document.getElementById('modalStudentName').textContent = name;
                document.getElementById('modalStudentImg').src = imgSrc;
                document.getElementById('hiddenDeleteId').value = id;
                studentDetailsContainer.innerHTML = detailsHtml;
                
                // Show the modal
                modal.classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            function closeModal() {
                modal.classList.remove('active');
                document.body.style.overflow = '';
            }

            // Modal event listeners
            modal.querySelector('.close').addEventListener('click', closeModal);
            modal.addEventListener('click', e => {
                if (e.target === modal) closeModal();
            });

            // Manage button to show action buttons
            document.querySelector('.btn-manage').addEventListener('click', () => {
                const actionButtons = document.querySelector('.action-buttons');
                actionButtons.style.display = actionButtons.style.display === 'none' ? 'flex' : 'none';
            });

            // Edit button in modal (now directs user to the card button)
            document.querySelector('.btn-edit-modal').addEventListener('click', () => {
                alert("Please use the 'Edit' button on the main student card to modify details.");
                closeModal();
            });

            /* CARD CLICK HANDLING */
            students.forEach(card => {
                card.addEventListener('click', e => {
                    // Do not open modal if the user is clicking on a button inside the card
                    if (e.target.closest('button')) {
                        return;
                    }
                    openModal(card);
                });
            });
            
            /* PENDING STUDENTS TABLE FUNCTIONALITY */
            const editModeBtn = document.getElementById('editModeBtn');
            const deleteSelectedBtn = document.getElementById('deleteSelectedBtn');
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            const rowCheckboxes = document.querySelectorAll('.row-checkbox');
            
            if (editModeBtn) {
                editModeBtn.addEventListener('click', function() {
                    const isEditMode = !this.classList.contains('active');
                    
                    // Toggle edit mode
                    if (isEditMode) {
                        this.classList.add('active');
                        this.innerHTML = '<i class="mdi mdi-check"></i> Done';
                        document.querySelectorAll('.checkbox-col').forEach(col => col.classList.remove('d-none'));
                        deleteSelectedBtn.classList.remove('d-none');
                    } else {
                        this.classList.remove('active');
                        this.innerHTML = '<i class="mdi mdi-pencil"></i> Edit';
                        document.querySelectorAll('.checkbox-col').forEach(col => col.classList.add('d-none'));
                        deleteSelectedBtn.classList.add('d-none');
                        selectAllCheckbox.checked = false;
                        rowCheckboxes.forEach(cb => cb.checked = false);
                    }
                });
            }
            
            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function() {
                    rowCheckboxes.forEach(cb => {
                        cb.checked = this.checked;
                    });
                });
            }
            
            if (deleteSelectedBtn) {
                deleteSelectedBtn.addEventListener('click', function() {
                    const selectedIds = [];
                    document.querySelectorAll('.row-checkbox:checked').forEach(cb => {
                        selectedIds.push(cb.getAttribute('data-id'));
                    });
                    
                    if (selectedIds.length === 0) {
                        alert('Please select at least one student to delete.');
                        return;
                    }
                    
                    if (confirm(`Are you sure you want to delete ${selectedIds.length} selected student(s)?`)) {
                        // Submit deletion request
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '${pageContext.request.contextPath}/DeleteStudentServlet';
                        
                        selectedIds.forEach(id => {
                            const input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'studentIds';
                            input.value = id;
                            form.appendChild(input);
                        });
                        
                        document.body.appendChild(form);
                        form.submit();
                    }
                });
            }
            
            /* INITIAL SEARCH/FILTER */
            performSearch(); // Apply filters on initial load
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

<%-- Include the base template --%>
<jsp:include page="Base.jsp" />