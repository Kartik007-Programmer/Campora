<%@page import="mypackage.Student"%>
<%@page import="mypackage.DAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        RequestDispatcher rd = request.getRequestDispatcher("../../regiseterlogin_page/LoginForm.jsp");
        rd.forward(request, response);
        return;
    }
%>

<% 
    Admin admin = dao.getAdminByUsername(AdminUsername);
    request.setAttribute("admin", admin);
    
    if (request.getAttribute("paginatedStudents") == null) {
        request.getRequestDispatcher("/AllSearchandPagination?type=students").forward(request, response);
        return;
    }
%>



<%-- Set template variables for base.jsp --%>
<c:set var="pageTitle" value="View Students - Campora Admin Panel" scope="request" />

<c:set var="pageContent" scope="request">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <h3 class="page-title mb-0">View Students</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb"><a href="${pageContext.request.contextPath}/Dashboard/Admin_penal.jsp">Dashboard</a></li>
                <li class="breadcrumb active" aria-current="page">View Students</li>
            </ol>
        </nav>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success">${sessionScope.success}</div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Filters Card Section -->
    <form method="get" action="${pageContext.request.contextPath}/AllSearchandPagination" id="filterForm">
    <input type="hidden" name="type" value="students">
        <div class="card mb-3 border-0" style="background-color: transparent;">
        <div class="card-body py-2 px-3">
            <div class="row align-items-end g-3">
                <div class="col-md-3">
                    <label class="form-label mb-1 small" for="studentSearch">Search</label>
                    <div class="input-group">
                        <input type="text" class="form-control form-control-sm" 
                               placeholder="Search students" 
                               id="studentSearch"
                               name="search"
                               value="${not empty param.searchQuery ? param.searchQuery : param.search}">
                        <c:if test="${not empty activeSearchParam or not empty param.genderFilter or not empty param.statusFilter or not empty param.pageSizeFilter}">
                            <button class="btn btn-sm btn-outline-secondary" type="button" 
                                    onclick="clearAllFilters()" 
                                    title="Clear all filters">
                                <i class="mdi mdi-close"></i>
                            </button>
                        </c:if>
                    </div>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="genderFilter">Gender</label>
                    <select class="form-control form-control-sm" id="genderFilter" name="genderFilter">
                        <option value="">All</option>
                        <option value="Male" ${param.genderFilter == 'Male' ? 'selected' : ''}>Male</option>
                        <option value="Female" ${param.genderFilter == 'Female' ? 'selected' : ''}>Female</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="statusFilter">Status</label>
                    <select class="form-control form-control-sm" id="statusFilter" name="statusFilter">
                        <option value="">All</option>
                        <option value="APPROVED" ${param.statusFilter == 'APPROVED' ? 'selected' : ''}>Approved</option>
                        <option value="PENDING" ${param.statusFilter == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="REJECTED" ${param.statusFilter == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <!-- Page size filter commented out as per original code -->
                </div>

                <div class="col-md-3 d-flex justify-content-end align-items-end" style="gap: 10px;">
                    <div>
                        <label class="form-label mb-1 small text-white d-block">Add</label>
                        <a href="${pageContext.request.contextPath}/add_students.jsp">
                            <button type="button" class="btn btn-sm d-flex align-items-center justify-content-center" id="addBtn"
                                style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                                <i class="mdi mdi-plus-circle-outline me-1" style="font-size: 14px;"></i> Add
                            </button>
                        </a>
                    </div>
                    <div>
                        <label class="form-label mb-1 small text-white d-block">Manage</label>
                        <a href="${pageContext.request.contextPath}/manage_students.jsp">
                            <button type="button" class="btn btn-sm d-flex align-items-center justify-content-center" id="exportBtn"
                                style="background-color: #dfb016; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                                <i class="mdi mdi-cog me-1" style="font-size: 14px;"></i> Manage
                            </button>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>

    <!-- Hidden radio buttons to control view -->
    <input type="radio" id="back" name="student-toggle" hidden checked>
    <c:forEach var="student" items="${paginatedStudents}" varStatus="loop">
        <input type="radio" id="view${loop.index + 1}" name="student-toggle" hidden>
    </c:forEach>

    <!-- Students Table with Expandable Profiles -->
    <div class="table-responsive draggable-table-container table-view">
        <table class="table table-striped mb-0" id="studentsTable">
            <thead class="thead-dark">
                <tr>
                    <th>#</th>
                    <th>Photo</th>
                    <th class="sortable">Full Name</th>
                    <th class="sortable">Gender</th>
                    <th class="sortable">Birth Date</th>
                    <th>Mobile</th>
                    <th>Email</th>
                    <th>Course</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty paginatedStudents}">
                        <tr>
                            <td colspan="10" style="text-align:center; color: #f44336; font-weight: bold;">
                                <c:choose>
                                    <c:when test="${not empty activeSearchParam or not empty param.genderFilter or not empty param.statusFilter}">
                                        No students found matching your filters
                                    </c:when>
                                    <c:otherwise>
                                        No students available
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="student" items="${paginatedStudents}" varStatus="loop">
                            <tr class="clickable-row" data-target="view${loop.index + 1}" data-id="${student.id}">
                                <td class="highlight-target">${(currentPage - 1) * pageSize + loop.index + 1}</td>
                                <td class="py-1">
                                    <c:choose>
                                        <c:when test="${not empty student.photo}">
                                            <img src="data:image/jpeg;base64,${student.imageBase64}" alt="Student Photo" class="rounded-circle student-img" style="width: 60px; height: 60px; object-fit: cover;"/>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded-circle student-img" style="width: 60px; height: 60px; background-color: #2a2d3a; display: flex; align-items: center; justify-content: center;">
                                                <i class="mdi mdi-account" style="font-size: 24px; color: #81d4fa;"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="highlight-target">${student.firstName} ${student.lastName}</td>
                                <td class="highlight-target">${student.gender}</td>
                                <td class="highlight-target"><fmt:formatDate value="${student.dob}" pattern="dd MMM yyyy" /></td>
                                <td class="highlight-target">${student.mobile}</td>
                                <td class="highlight-target">${student.email}</td>
                                <td class="highlight-target">${student.course}</td>
                                <td class="highlight-target">
                                    <c:choose>
                                        <c:when test="${student.status == 'APPROVED'}">
                                            <span class="badge badge-success">Approved</span>
                                        </c:when>
                                        <c:when test="${student.status == 'PENDING'}">
                                            <span class="badge badge-warning">Pending</span>
                                        </c:when>
                                        <c:when test="${student.status == 'REJECTED'}">
                                            <span class="badge badge-danger">Rejected</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="studentId" value="${student.id}">
                                        <button type="submit" name="status" value="APPROVED" 
                                                class="action-btn approve-btn"
                                                <c:if test="${student.status == 'APPROVED'}">disabled</c:if>>
                                            Approve
                                        </button>
                                        <button type="submit" name="status" value="REJECTED" 
                                                class="action-btn reject-btn"
                                                <c:if test="${student.status == 'REJECTED'}">disabled</c:if>>
                                            Reject
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Student Profile Cards -->
    <c:forEach var="student" items="${paginatedStudents}" varStatus="loop">
        <div class="card-detail card${loop.index + 1} position-relative p-3">
            <!-- Manage Button (Top Right) -->
            <a href="${pageContext.request.contextPath}/manage_students.jsp">
                <button class="btn btn-info position-absolute" style="top: 22px; right: 42px; z-index: 1;">
                    ⚙ Manage
                </button>
            </a>

            <div class="card-content text-start">
                <c:choose>
                    <c:when test="${not empty student.photo}">
                        <img src="data:image/jpeg;base64,${student.imageBase64}" alt="Student Image" class="student-img mb-3" />
                    </c:when>
                    <c:otherwise>
                        <div class="student-img mb-3" style="width: 180px; height: 180px; background-color: #2a2d3a; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
                            <i class="mdi mdi-account" style="font-size: 48px; color: #81d4fa;"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <h4>${student.firstName} ${student.lastName}</h4>
                <c:choose>
                    <c:when test="${student.status == 'APPROVED'}">
                        <span class="status-badge">Approved</span>
                    </c:when>
                    <c:when test="${student.status == 'PENDING'}">
                        <span class="status-badge-leave">Pending</span>
                    </c:when>
                    <c:when test="${student.status == 'REJECTED'}">
                        <span class="status-badge" style="background-color: #f44336; border-color: #f44336;">Rejected</span>
                    </c:when>
                </c:choose>
                <ul class="mt-2">
                    <li><strong>Gender:</strong> ${student.gender}</li>
                    <li><strong>Birth Date:</strong> <fmt:formatDate value="${student.dob}" pattern="dd MMMM yyyy" /></li>
                    <li><strong>Mobile:</strong> ${student.mobile}</li>
                    <li><strong>Email:</strong> ${student.email}</li>
                    <li><strong>Course:</strong> ${student.course}</li>
                    <li><strong>Last Year Percentage:</strong> ${student.lastYearPercentage}%</li>
                    <li><strong>Registered On:</strong> <fmt:formatDate value="${student.registrationDate}" pattern="dd MMMM yyyy HH:mm" /></li>
                    <c:if test="${not empty student.processedDate}">
                        <li><strong>Processed On:</strong> <fmt:formatDate value="${student.processedDate}" pattern="dd MMMM yyyy HH:mm" /></li>
                    </c:if>
                </ul>
                <label for="back" class="btn btn-outline-info mt-4" style="display: flex; justify-self: center; justify-content: center; width: 400px; text-align: center;">← Back to List</label>
            </div>
        </div>
    </c:forEach>

    <!-- Table Footer Row with Entry Info & Pagination -->
    <c:if test="${not empty paginatedStudents and totalPages > 0}">
        <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
            <!-- Entry Count Info (Left) -->
            <div class="table-info text-muted small">
                Showing <strong>${startItem}</strong> to <strong>${endItem}</strong> of <strong>${totalItems}</strong> entries
                <c:if test="${not empty activeSearchParam or not empty param.genderFilter or not empty param.statusFilter}">
                    (Filtered Results)
                </c:if>
            </div>

            <!-- Pagination (Right) -->
            <nav>
                <ul class="pagination mb-0">
                    <!-- Previous Button -->
                    <c:choose>
                        <c:when test="${currentPage == 1}">
                            <li class="page-item disabled"><span class="page-link">Previous</span></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?page=${currentPage - 1}<c:if test="${not empty activeSearchParam}">&search=${activeSearchParam}</c:if><c:if test="${not empty param.genderFilter}">&genderFilter=${param.genderFilter}</c:if><c:if test="${not empty param.statusFilter}">&statusFilter=${param.statusFilter}</c:if><c:if test="${not empty param.pageSizeFilter}">&pageSizeFilter=${param.pageSizeFilter}</c:if>">Previous</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Page Numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <c:choose>
                            <c:when test="${pageNum == currentPage}">
                                <li class="page-item active"><span class="page-link">${pageNum}</span></li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?page=${pageNum}<c:if test="${not empty activeSearchParam}">&search=${activeSearchParam}</c:if><c:if test="${not empty param.genderFilter}">&genderFilter=${param.genderFilter}</c:if><c:if test="${not empty param.statusFilter}">&statusFilter=${param.statusFilter}</c:if><c:if test="${not empty param.pageSizeFilter}">&pageSizeFilter=${param.pageSizeFilter}</c:if>">${pageNum}</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <!-- Next Button -->
                    <c:choose>
                        <c:when test="${currentPage == totalPages}">
                            <li class="page-item disabled"><span class="page-link">Next</span></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?page=${currentPage + 1}<c:if test="${not empty activeSearchParam}">&search=${activeSearchParam}</c:if><c:if test="${not empty param.genderFilter}">&genderFilter=${param.genderFilter}</c:if><c:if test="${not empty param.statusFilter}">&statusFilter=${param.statusFilter}</c:if><c:if test="${not empty param.pageSizeFilter}">&pageSizeFilter=${param.pageSizeFilter}</c:if>">Next</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </nav>
        </div>
    </c:if>
</c:set>

<c:set var="additionalCSS" scope="request">
    <style>
        /* Card detail styles */
        .card-detail {
            display: none;
            background-color: #191c24;
            color: #d6d6d6;
            padding: 40px 30px;
            margin-top: 20px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.05);
            position: relative;
            animation: fadeIn 0.3s ease-in-out;
        }

        .student-img {
            transition: transform 0.2s ease, box-shadow 0.3s ease;
        }

        .student-img:hover {
            transform: scale(1.30);
        }

        .card-detail h4 {
            text-align: center;
            color: #81d4fa;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 40px;
        }

        .card-detail ul {
            margin-left: 20px;
            padding: 0;
            list-style: none;
            line-height: 2;
            font-size: 1.00rem;
        }

        .card-detail .student-img {
            position: absolute;
            top: 50%;
            right: 50px;
            transform: translateY(-55%);
            width: 180px;
            height: 180px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #81d4fa;
            box-shadow: 0 0 15px rgba(129, 212, 250, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card-detail .student-img:hover {
            transform: translateY(-55%) scale(1.2);
        }

        .btn-outline-info {
            color: #81d4fa;
            border-color: #81d4fa;
        }

        .btn-outline-info:hover {
            background-color: #81d4fa;
            color: #191c24;
            border-color: #81d4fa;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Hide table when detail view is shown */
        <c:forEach var="student" items="${paginatedStudents}" varStatus="loop">
            #view${loop.index + 1}:checked ~ .table-view {
                display: none;
            }
            #view${loop.index + 1}:checked ~ .card${loop.index + 1} {
                display: block;
            }
        </c:forEach>
        #back:checked ~ .table-view {
            display: block;
        }
        #back:checked ~ .card-detail {
            display: none;
        }

        .status-badge {
            display: inline-block;
            margin: 8px auto 20px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 20px;
            background-color: #e6f4ea;
            margin-left: 20px;
            color: #1a6e2e;
            text-align: center;
            border: 1px solid #28a745;
            box-shadow: 0 0 8px rgba(40, 167, 69, 0.2);
        }

        .status-badge-leave {
            display: inline-block;
            margin: 8px auto 20px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 20px;
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
            margin-left: 20px;
            text-align: center;
        }

        #studentsTable tbody tr {
             background-color: transparent;
            color: #b8b8b8;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        #studentsTable tbody tr:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.05) !important;
        }

        #studentsTable .badge-success {
            background-color: #2e7d32;
            color: #e3fbe5;
        }

        #studentsTable .badge-warning {
            background-color: #b58900;
            color: #fff9e6;
        }

        #studentsTable .badge-danger {
            background-color: #b22222;
            color: #fceaea;
        }

        .student-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
        }

        tr {
            color:aliceblue;
        }

        #studentsTable {
            margin-bottom: 0;
        }
        
        .sortable {
            cursor: pointer;
            position: relative;
        }
        
        .sortable i {
            margin-left: 5px;
            opacity: 0.5;
            transition: opacity 0.3s;
        }

        /* Action Buttons */
        .action-btn {
            padding: 6px 9px;
            font-size: 0.8rem;
            border-radius: 6px;
            margin-left: 4px;
            transition: background 0.2s ease;
        }

        .approve-btn {
            background-color: #4CAF50;
            color: white;
            border: 1px solid #2a3b4d;
        }
        .approve-btn:hover {
            background-color: #3e8e41;
        }

        .reject-btn {
            background-color: #f44336;
            color: white;
            border: 1px solid #4e4a25;
        }
        .reject-btn:hover {
            background-color: #d32f2f;
        }

        /* Pagination Styling */
        .pagination .page-link {
            background-color: #1e1e1e;
            color: #81d4fa;
            border: 1px solid #2f2f2f;
            font-size: 0.85rem;
            padding: 6px 12px;
            margin-left: 4px;
            border-radius: 4px;
        }

        .pagination .page-item.active .page-link {
            background-color: #81d4fa;
            color: #121212;
            font-weight: bold;
        }

        .pagination .page-link:hover {
            background-color: #39414b;
            color: #ffffff;
        }

        .table-info {
            color: #b0b0b0;
            font-size: 0.90rem;
            padding-left: 4px;
            background-color: transparent !important;
        }

        .table-info strong {
            color: #b1b1b1;
        }
        
        .draggable-table-container {
            overflow-x: auto;
            overflow-y: hidden;
            position: relative;
            cursor: grab;
            user-select: none;
            scroll-behavior: smooth;
            -webkit-overflow-scrolling: touch;
            padding-bottom: 10px;
        }

        .draggable-table-container.dragging {
            cursor: grabbing;
        }

        .draggable-table-container::-webkit-scrollbar {
            height: 3px;
        }

        .draggable-table-container::-webkit-scrollbar-thumb {
            background-color: #81d4fa;
            border-radius: 4px;
        }

        .draggable-table-container td,
        .draggable-table-container th {
            white-space: nowrap;
            user-select: none;
        }

        #studentsTable th,
        #studentsTable td {
            
            vertical-align: middle;
        }

        #studentsTable thead th {
            background-color: #33393f;
            color: #ffffff;
        }

        /* Responsive badges */
        .badge {
            font-size: 0.75rem;
            padding: 0.25em 0.6em;
            border-radius: 0.25rem;
        }

        /* Responsive button size */
        .action-btn {
            padding: 4px 6px;
            font-size: 0.75rem;
        }

        /* Search highlight styling */
        .highlight {
            background-color: #ffeb3b;
            color: #000;
            padding: 2px 4px;
            border-radius: 3px;
            font-weight: bold;
            box-shadow: 0 0 3px rgba(255, 235, 59, 0.5);
            animation: pulse 1.5s infinite;
        }

        .highlighted-row {
            background-color: rgba(255, 235, 59, 0.1) !important;
            border-left: 3px solid #ffeb3b !important;
            transition: all 0.3s ease;
        }

        .highlighted-card {
            border: 2px solid #ffeb3b !important;
            box-shadow: 0 0 15px rgba(255, 235, 59, 0.5) !important;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 3px rgba(255, 235, 59, 0.5); }
            50% { box-shadow: 0 0 8px rgba(255, 235, 59, 0.8); }
            100% { box-shadow: 0 0 3px rgba(255, 235, 59, 0.5); }
        }

        /* Filter styles */
        #studentSearch,
        #genderFilter,
        #statusFilter,
        #pageSizeFilter {
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #studentSearch:focus,
        #genderFilter:focus,
        #statusFilter:focus,
        #pageSizeFilter:focus {
            outline: none;
            box-shadow: 0 0 0 2px #a5b4fc;
            border-color: #81d4fa;
        }

        @media screen and (max-width: 768px) {
            .table th, .table td {
                font-size: 12px;
                padding: 8px;
            }

            .action-btn {
                padding: 2px 4px;
                font-size: 0.7rem;
            }

            .draggable-table-container {
                margin: 0 -10px;
                padding-left: 10px;
                padding-right: 10px;
            }
        }
    </style>
</c:set>

<c:set var="additionalScripts" scope="request">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Universal Search integration
            const urlParams = new URLSearchParams(window.location.search);
            const searchQuery = urlParams.get('searchQuery'); // From universal search
            const searchParam = urlParams.get('search'); // From local search
            const highlightId = urlParams.get('highlightId');
            
            // Priority: searchQuery (universal) > search (local)
            let activeSearchTerm = searchQuery || searchParam;
            
            if (activeSearchTerm) {
                // Apply highlights after DOM is fully loaded
                setTimeout(() => {
                    applySearchHighlights(activeSearchTerm);
                }, 200);
            }
            
            if (highlightId) {
                setTimeout(() => {
                    // Find and highlight the specific student row
                    const rows = document.querySelectorAll('#studentsTable tbody tr');
                    rows.forEach(row => {
                        const studentId = row.getAttribute('data-id');
                        if (studentId === highlightId) {
                            row.classList.add('highlighted-row');
                            row.scrollIntoView({behavior: 'smooth', block: 'center'});
                            
                            // Keep highlight for longer for universal search
                            setTimeout(() => {
                                row.classList.remove('highlighted-row');
                            }, 5000);
                            
                            // Also highlight the corresponding card
                            const cardIndex = Array.from(rows).indexOf(row);
                            const card = document.querySelector(`.card${cardIndex + 1}`);
                            if (card) {
                                card.classList.add('highlighted-card');
                                setTimeout(() => {
                                    card.classList.remove('highlighted-card');
                                }, 5000);
                            }
                        }
                    });
                }, 300);
            }
            
            // Make table rows clickable to show detail cards
            document.querySelectorAll('.clickable-row').forEach(row => {
                row.addEventListener('click', () => {
                    const targetId = row.getAttribute('data-target');
                    document.getElementById(targetId).checked = true;
                });
            });

            // Search functionality - Auto-submit on Enter key
            document.getElementById('studentSearch').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    // Remove page parameter when searching (go to page 1)
                    const url = new URL(window.location.href);
                    url.searchParams.delete('page');
                    url.searchParams.delete('searchQuery'); // Clear universal search param
                    document.getElementById('filterForm').action = url.toString();
                    document.getElementById('filterForm').submit();
                }
            });

            // Add debouncing for search input
            document.getElementById('studentSearch').addEventListener('input', function() {
                const searchTerm = this.value.trim();
                
                // Client-side highlighting while typing
                applySearchHighlights(searchTerm);
                
                clearTimeout(this.searchTimer);
                this.searchTimer = setTimeout(() => {
                    if (searchTerm.length >= 3 || searchTerm.length === 0) {
                        // Remove page parameter when searching (go to page 1)
                        const url = new URL(window.location.href);
                        url.searchParams.delete('page');
                        url.searchParams.delete('searchQuery'); // Clear universal search param
                        document.getElementById('filterForm').action = url.toString();
                        document.getElementById('filterForm').submit();
                    }
                }, 800);
            });

            // Filter functionality - Auto-submit on change
            document.getElementById('genderFilter').addEventListener('change', function() {
                // Remove page parameter when filtering (go to page 1)
                const url = new URL(window.location.href);
                url.searchParams.delete('page');
                document.getElementById('filterForm').action = url.toString();
                document.getElementById('filterForm').submit();
            });

            // Status filter - Auto-submit on change
            document.getElementById('statusFilter').addEventListener('change', function() {
                // Remove page parameter when filtering (go to page 1)
                const url = new URL(window.location.href);
                url.searchParams.delete('page');
                document.getElementById('filterForm').action = url.toString();
                document.getElementById('filterForm').submit();
            });

            // Page size filter - Auto-submit on change
            if (document.getElementById('pageSizeFilter')) {
                document.getElementById('pageSizeFilter').addEventListener('change', function() {
                    // Remove page parameter when filtering (go to page 1)
                    const url = new URL(window.location.href);
                    url.searchParams.delete('page');
                    document.getElementById('filterForm').action = url.toString();
                    document.getElementById('filterForm').submit();
                });
            }
        });
        
        // Utility functions for highlighting
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

        function applySearchHighlights(searchTerm) {
            const tableBody = document.querySelector('#studentsTable tbody');
            if (!tableBody) return;
            
            const rows = tableBody.querySelectorAll('tr');
            
            // First remove all highlights
            rows.forEach(row => {
                removeHighlights(row);
                row.classList.remove('highlighted-row');
            });
            
            // Remove card highlights
            document.querySelectorAll('.card-detail').forEach(card => {
                card.classList.remove('highlighted-card');
            });
            
            if (!searchTerm || searchTerm.trim() === '') return;
            
            const term = searchTerm.trim().toLowerCase();
            
            rows.forEach(row => {
                const targets = row.querySelectorAll('.highlight-target');
                let rowHasMatch = false;
                
                targets.forEach(target => {
                    const text = target.textContent || '';
                    if (text.toLowerCase().includes(term)) {
                        rowHasMatch = true;
                    }
                });
                
                if (rowHasMatch) {
                    highlightSearchTerm(row, term);
                    row.classList.add('highlighted-row');
                }
            });
        }

        function clearAllHighlights() {
            const tableBody = document.querySelector('#studentsTable tbody');
            if (!tableBody) return;
            
            const rows = tableBody.querySelectorAll('tr');
            
            rows.forEach(row => {
                removeHighlights(row);
                row.classList.remove('highlighted-row');
            });
            
            // Remove card highlights
            document.querySelectorAll('.card-detail').forEach(card => {
                card.classList.remove('highlighted-card');
            });
        }
        
        function clearAllFilters() {
            window.location.href = '${pageContext.request.contextPath}/AllSearchandPagination?type=students';
        }
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