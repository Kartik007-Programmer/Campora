<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
    
    if (request.getAttribute("paginatedCourses") == null) {
        request.getRequestDispatcher("/AllSearchandPagination?type=courses").forward(request, response);
        return;
    }
%>



<!-- Set variables for base.jsp -->
<c:set var="pageTitle" value="View Courses - Campora Admin" scope="request" />

<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mdi/font@6.5.95/css/materialdesignicons.min.css">
    <style>
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

        .course-img {
            transition: transform 0.2s ease, box-shadow 0.3s ease;
        }

        .course-img:hover {
            transform: scale(1.5);
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

        .card-detail .course-img {
            position: absolute;
            top: 50%;
            right: 50px;
            transform: translateY(-55%);
            width: 250px;
            height: 250px;
            object-fit: cover;
            border: 2px solid #81d4fa;
            box-shadow: 0 0 15px rgba(129, 212, 250, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card-detail .course-img:hover {
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

        #coursesTable tbody tr {
            background-color: transparent;
            color: #b8b8b8;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
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
            background-color: #e6f4ea;
            color: #aca100;
            border: 1px solid #ffe600;
            margin-left: 20px;
            text-align: center;
        }

        #coursesTable tbody tr:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.05) !important;
        }

        #coursesTable .badge-success {
            background-color: #2e7d32;
            color: #e3fbe5;
        }

        #coursesTable .badge-warning {
            background-color: #b58900;
            color: #fff9e6;
        }

        #coursesTable .badge-danger {
            background-color: #b22222;
            color: #fceaea;
        }

        .course-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
        }

        tr {
            color:aliceblue;
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

        #coursesTable th,
        #coursesTable td {
            vertical-align: middle;
        }

        /* Table body styling - transparent and no borders */
        #coursesTable tbody tr {
            background-color: transparent !important;
        }
        
        #coursesTable tbody td {
            border: none !important;
            background-color: transparent !important;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
        }

        /* View toggle styles */
        #view1:checked ~ .table-view, 
        #view2:checked ~ .table-view, 
        #view3:checked ~ .table-view, 
        #view4:checked ~ .table-view, 
        #view5:checked ~ .table-view {
            display: none;
        }
        #view1:checked ~ .card1,
        #view2:checked ~ .card2,
        #view3:checked ~ .card3,
        #view4:checked ~ .card4,
        #view5:checked ~ .card5 {
            display: block;
        }
        #back:checked ~ .table-view {
            display: block;
        }
        #back:checked ~ .card-detail {
            display: none;
        }

        .course-img {
            max-width: 100px;
            max-height: 100px;
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
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #444;
            border-radius: 4px;
            background-color: #2a2a2a;
            color: #e0e0e0;
            box-sizing: border-box;
        }

        .form-control:focus {
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

        @keyframes pulse {
            0% { box-shadow: 0 0 3px rgba(255, 235, 59, 0.5); }
            50% { box-shadow: 0 0 8px rgba(255, 235, 59, 0.8); }
            100% { box-shadow: 0 0 3px rgba(255, 235, 59, 0.5); }
        }
        
        /* Filter styles */
        #courseSearch,
        #categoryFilter,
        #durationFilter,
        #ratingFilter {
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #courseSearch:focus,
        #categoryFilter:focus,
        #durationFilter:focus,
        #ratingFilter:focus {
            outline: none;
            box-shadow: 0 0 0 2px #a5b4fc;
            border-color: #81d4fa;
        }

    </style>
</c:set>

<c:set var="pageContent" scope="request">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <h3 class="page-title mb-0">View Courses</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb"><a href="#"></a></li>
                <li class="breadcrumb" aria-current="page"></li>
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
    <input type="hidden" name="type" value="courses">
      <div class="card mb-3 border-0" style="background-color: transparent;">
        <div class="card-body py-2 px-3">
            <div class="row align-items-end g-3">
                <div class="col-md-3">
                    <label class="form-label mb-1 small" for="courseSearch">Search</label>
                    <div class="input-group">
                        <input type="text" class="form-control form-control-sm" 
                               placeholder="Search all courses" 
                               id="courseSearch"
                               name="search"
                               value="${param.search}">
                        <c:if test="${not empty param.search or not empty param.categoryFilter or not empty param.ratingFilter or not empty param.durationFilter}">
                            <button class="btn btn-sm btn-outline-secondary" type="button" 
                                    onclick="clearAllFilters()" 
                                    title="Clear all filters">
                                <i class="mdi mdi-close"></i>
                            </button>
                        </c:if>
                    </div>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="categoryFilter">Category</label>
                    <select class="form-control form-control-sm" id="categoryFilter" name="categoryFilter">
                        <option value="">All</option>
                        <c:forEach var="ccategories" items="${ccategories}">
                        <option value="${ccategories}" ${param.categoryFilter == ccategories ? 'selected' : ''}>${ccategories}</option>
                        </c:forEach>    
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="ratingFilter">Rating</label>
                    <select class="form-control form-control-sm" id="ratingFilter" name="ratingFilter">
                        <option value="">All</option>
                        <option value="5" ${param.ratingFilter == '5' ? 'selected' : ''}>5 Stars</option>
                        <option value="4" ${param.ratingFilter == '4' ? 'selected' : ''}>4+ Stars</option>
                        <option value="3" ${param.ratingFilter == '3' ? 'selected' : ''}>3+ Stars</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="durationFilter">Duration</label>
                    <select class="form-control form-control-sm" id="durationFilter" name="durationFilter">
                        <option value="">All Durations</option>
                        <option value="1-3" ${param.durationFilter == '1-3' ? 'selected' : ''}>1-3 Months</option>
                        <option value="4-6" ${param.durationFilter == '4-6' ? 'selected' : ''}>4-6 Months</option>
                        <option value="7-12" ${param.durationFilter == '7-12' ? 'selected' : ''}>7-12 Months</option>
                        <option value="12+" ${param.durationFilter == '12+' ? 'selected' : ''}>12+ Months</option>
                    </select>
                </div>

                <div class="col-md-3 d-flex justify-content-end align-items-end" style="gap: 10px;">
                    <div>
                        <label class="form-label mb-1 small text-white d-block">Add</label>
                        <a href="${pageContext.request.contextPath}/add_courses.jsp">
                            <button type="button" class="btn btn-sm d-flex align-items-center justify-content-center" id="addBtn"
                                style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                                <i class="mdi mdi-plus-circle-outline me-1" style="font-size: 14px;"></i> Add
                            </button>
                        </a>
                    </div>
                    <div>
                        <label class="form-label mb-1 small text-white d-block">Manage</label>
                        <a href="${pageContext.request.contextPath}/manage_courses.jsp">
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
    <input type="radio" id="back" name="course-toggle" hidden checked>
    <c:forEach var="course" items="${paginatedCourses}" varStatus="loop">
        <input type="radio" id="view${loop.index + 1}" name="course-toggle" hidden>
    </c:forEach>

    <!-- Courses Table with Expandable Details -->
    <div class="table-responsive draggable-table-container table-view">
        <table class="table table-striped mb-0" id="coursesTable">
            <thead class="thead-dark">
                <tr>
                    <th>#</th>
                    <th>Image</th>
                    <th class="sortable">Name</th>
                    <th class="sortable">Fees</th>
                    <th class="sortable">Rating</th>
                    <th>Duration</th>
                    <th>Category</th>
                    <th>Max Students</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty paginatedCourses}">
                        <tr>
                            <td colspan="9" style="text-align:center; color: #f44336; font-weight: bold;">
                                <c:choose>
                                    <c:when test="${not empty param.search or not empty param.categoryFilter or not empty param.ratingFilter or not empty param.durationFilter}">
                                        No courses found matching your filters
                                    </c:when>
                                    <c:otherwise>
                                        No courses available
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="course" items="${paginatedCourses}" varStatus="loop">
                            <tr class="clickable-row" data-target="view${loop.index + 1}">
                                <td>${(currentPage - 1) * 5 + loop.index + 1}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty course.img}">
                                            <img src="data:image/jpeg;base64,${course.imageBase64}" class="course-img" alt="${course.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/no-image.png" class="course-img" alt="No image available">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="highlight-target">${course.name}</td>
                                <td class="highlight-target">&#8377;${course.fees}</td>
                                <td class="highlight-target">${course.star}/5</td>
                                <td class="highlight-target">${course.durationMonths} months</td>
                                <td class="highlight-target">${course.category}</td>
                                <td class="highlight-target">${course.maxStudents}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/EditCourseServlet?id=${course.id}" class="btn btn-sm btn-icon btn-edit">
                                        <i class="mdi mdi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/DeleteCourseServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="courseId" value="${course.id}">
                                        <button type="submit" class="btn btn-sm btn-icon btn-delete" onclick="return confirm('Are you sure?')">
                                            <i class="mdi mdi-delete"></i>
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

    <!-- Course Detail Cards -->
    <c:forEach var="course" items="${paginatedCourses}" varStatus="loop">
        <div class="card-detail card${loop.index + 1} position-relative p-3">
            <!-- Manage Button (Top Right) -->
            <a href="${pageContext.request.contextPath}/manage_courses.jsp">
                <button class="btn btn-info position-absolute" style="top: 22px; right: 42px; z-index: 1;">
                    ⚙  Manage
                </button>
            </a>

            <div class="card-content text-start">
                <c:choose>
                    <c:when test="${not empty course.img}">
                        <img src="data:image/jpeg;base64,${course.imageBase64}" alt="${course.name}" class="course-img mb-3" />
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/images/no-image.png" alt="No image available" class="course-img mb-3" />
                    </c:otherwise>
                </c:choose>
                <h4>${course.name}</h4>
                <span class="status-badge">Active</span>
                <ul class="mt-2">
                    <li><strong>Fees:</strong> $${course.fees}</li>
                    <li><strong>Rating:</strong> ${course.star}/5</li>
                    <li><strong>Duration:</strong> ${course.durationMonths} months</li>
                    <li><strong>Category:</strong> ${course.category}</li>
                    <li><strong>Max Students:</strong> ${course.maxStudents}</li>
                    <li><strong>Description:</strong> ${course.description != null ? course.description : 'No description available'}</li>
                </ul>
                <label for="back" class="btn btn-outline-info mt-4" style="display: flex; justify-self: center; justify-content: center; width: 400px; text-align: center;">← Back to List</label>
            </div>
        </div>
    </c:forEach>

    <!-- Table Footer Row with Entry Info & Pagination -->
    <c:if test="${not empty paginatedCourses and totalPages > 0}">
        <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
            <!-- Entry Count Info (Left) -->
            <div class="table-info text-muted small">
                Showing <strong>${startItem}</strong> to <strong>${endItem}</strong> of <strong>${totalItems}</strong> entries
                <c:if test="${not empty param.search or not empty param.categoryFilter or not empty param.ratingFilter or not empty param.durationFilter}">
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
                                <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?type=courses&page=${currentPage - 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.categoryFilter}">&categoryFilter=${param.categoryFilter}</c:if><c:if test="${not empty param.ratingFilter}">&ratingFilter=${param.ratingFilter}</c:if><c:if test="${not empty param.durationFilter}">&durationFilter=${param.durationFilter}</c:if>">Previous</a>
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
                                    <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?type=courses&page=${pageNum}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.categoryFilter}">&categoryFilter=${param.categoryFilter}</c:if><c:if test="${not empty param.ratingFilter}">&ratingFilter=${param.ratingFilter}</c:if><c:if test="${not empty param.durationFilter}">&durationFilter=${param.durationFilter}</c:if>">${pageNum}</a>
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
                                <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?type=courses&page=${currentPage + 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.categoryFilter}">&categoryFilter=${param.categoryFilter}</c:if><c:if test="${not empty param.ratingFilter}">&ratingFilter=${param.ratingFilter}</c:if><c:if test="${not empty param.durationFilter}">&durationFilter=${param.durationFilter}</c:if>">Next</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </nav>
        </div>
    </c:if>
</c:set>

<c:set var="additionalScripts" scope="request">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Apply search highlights on page load
            const urlParams = new URLSearchParams(window.location.search);
            const searchParam = urlParams.get('search');
            
            if (searchParam) {
                // Apply highlights after a short delay to ensure DOM is ready
                setTimeout(() => {
                    applySearchHighlights(searchParam);
                }, 100);
            }
            
            // Make table rows clickable to show detail cards
            document.querySelectorAll('.clickable-row').forEach(row => {
                row.addEventListener('click', () => {
                    const targetId = row.getAttribute('data-target');
                    document.getElementById(targetId).checked = true;
                });
            });

            // Search functionality - Auto-submit on Enter key
            document.getElementById('courseSearch').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    // Remove page parameter when searching (go to page 1)
                    const url = new URL(window.location.href);
                    url.searchParams.delete('page');
                    document.getElementById('filterForm').action = url.toString();
                    document.getElementById('filterForm').submit();
                }
            });

            // Add debouncing for search input
            document.getElementById('courseSearch').addEventListener('input', function() {
                const searchTerm = this.value.trim();
                
                // Client-side highlighting while typing
                applySearchHighlights(searchTerm);
                
                clearTimeout(this.searchTimer);
                this.searchTimer = setTimeout(() => {
                    if (searchTerm.length >= 3 || searchTerm.length === 0) {
                        // Remove page parameter when searching (go to page 1)
                        const url = new URL(window.location.href);
                        url.searchParams.delete('page');
                        document.getElementById('filterForm').action = url.toString();
                        document.getElementById('filterForm').submit();
                    }
                }, 800);
            });

            // Filter functionality - Auto-submit on change
            document.getElementById('categoryFilter').addEventListener('change', function() {
                // Remove page parameter when filtering (go to page 1)
                const url = new URL(window.location.href);
                url.searchParams.delete('page');
                document.getElementById('filterForm').action = url.toString();
                document.getElementById('filterForm').submit();
            });

            // Rating filter - Auto-submit on change
            document.getElementById('ratingFilter').addEventListener('change', function() {
                // Remove page parameter when filtering (go to page 1)
                const url = new URL(window.location.href);
                url.searchParams.delete('page');
                document.getElementById('filterForm').action = url.toString();
                document.getElementById('filterForm').submit();
            });

            // Duration filter - Auto-submit on change
            document.getElementById('durationFilter').addEventListener('change', function() {
                // Remove page parameter when filtering (go to page 1)
                const url = new URL(window.location.href);
                url.searchParams.delete('page');
                document.getElementById('filterForm').action = url.toString();
                document.getElementById('filterForm').submit();
            });
        
            // This is for Universal Search
            const urlParams2 = new URLSearchParams(window.location.search);
            const searchQuery = urlParams2.get('searchQuery');
            const highlightId = urlParams2.get('highlightId');
            const OneCourseId = urlParams2.get('courseid');
            
            if (searchQuery) {
                document.getElementById('courseSearch').value = searchQuery;
                applySearchHighlights(searchQuery);
            }
            
            if (highlightId) {
                const row = document.querySelector(`tr[data-id="${highlightId}"]`);
                if (row) {
                    row.classList.add('highlighted-row');
                    row.scrollIntoView({behavior: 'smooth', block: 'center'});
                    
                    setTimeout(() => {
                        row.classList.remove('highlighted-row');
                    }, 3000);
                }
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
            const tableBody = document.querySelector('#coursesTable tbody');
            const rows = tableBody.querySelectorAll('tr');
            
            // First remove all highlights
            rows.forEach(row => {
                removeHighlights(row);
                row.classList.remove('highlighted-row');
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
            const tableBody = document.querySelector('#coursesTable tbody');
            const rows = tableBody.querySelectorAll('tr');
            
            rows.forEach(row => {
                removeHighlights(row);
                row.classList.remove('highlighted-row');
            });
        }
        
        function clearAllFilters() {
            window.location.href = '${pageContext.request.contextPath}/AllSearchandPagination?type=courses';
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

<!-- Include the base template -->
<jsp:include page="Base.jsp" />