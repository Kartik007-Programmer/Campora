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
    if (request.getAttribute("teachers") == null) {
        try {
            DAO teacherDAO = new DAO();
            List<Course> courses = teacherDAO.getAllCourses();
            request.setAttribute("courses", courses);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        request.getRequestDispatcher("/AllSearchandPagination?type=teachers-mg").forward(request, response);
        return;
    }
%>

<!-- Set template variables -->
<c:set var="pageTitle" value="Manage Teachers - Campora Admin Panel" scope="request" />

<c:set var="pageContent" scope="request">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <h3 class="page-title mb-0">Manage Teachers</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/Admin_penal.jsp">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Manage Teachers</li>
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

    <!-- Filters Card Section -->
    <div class="card mb-3 border-0" style="background-color: transparent;">
        <div class="card-body py-2 px-3">
            <form method="get" action="${pageContext.request.contextPath}/AllSearchandPagination" id="filterForm">
                <input type="hidden" name="type" value="teachers-mg">                
                <div class="row align-items-end g-3">
                    <div class="col-md-3">
                        <label class="form-label mb-1 small" for="teacherSearch">Search</label>
                        <div class="input-group">
                            <input type="text" name="search" class="form-control form-control-sm" 
                                   placeholder="Search teachers" id="teacherSearch" value="${param.search}">
                            <c:if test="${not empty param.search or not empty param.genderFilter or not empty param.statusFilter or not empty param.subjectFilter}">
                                <button class="btn btn-sm btn-outline-secondary" type="button" 
                                        onclick="clearAllFilters()" 
                                        title="Clear all filters">
                                    <i class="mdi mdi-close"></i>
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label mb-1 small" for="subjectFilter">Subject</label>
                        <select name="subjectFilter" class="form-control form-control-sm" id="subjectFilter">
                            <option value="">All Subjects</option>
                            <c:forEach var="course" items="${courses}"> 
                                <option value="${course.name}" ${param.subjectFilter == course.name ? 'selected' : ''}>${course.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label mb-1 small" for="genderFilter">Gender</label>
                        <select name="genderFilter" class="form-control form-control-sm" id="genderFilter">
                            <option value="">All Genders</option>
                            <option value="Male" ${param.genderFilter == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${param.genderFilter == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${param.genderFilter == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label mb-1 small" for="statusFilter">Status</label>
                        <select name="statusFilter" class="form-control form-control-sm" id="statusFilter">
                            <option value="">All Status</option>
                            <option value="Active" ${param.statusFilter == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="On Leave" ${param.statusFilter == 'On Leave' ? 'selected' : ''}>On Leave</option>
                        </select>
                    </div>

                    <div class="col-md-3 d-flex justify-content-end align-items-end">
                        <div style="width: 65%;">
                            <label class="form-label mb-1 small text-white d-block text-center">Add</label>
                            <a href="${pageContext.request.contextPath}/add_teacher.jsp">
                                <button type="button" class="btn btn-sm d-flex align-items-center justify-content-center w-100"
                                    style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                                    <i class="mdi mdi-plus-circle-outline me-1" style="font-size: 14px;"></i> Add Teacher
                                </button>
                            </a>
                        </div>
                    </div>
                </div>
            </form>                
        </div>
    </div>

    <!-- Teacher Cards Container -->
    <div class="wrapper">
        <div class="teacher-container">
            <c:choose>
                <c:when test="${empty teachers}">
                    <div class="col-12 text-center">
                        <div class="no-teachers-card">
                            <i class="mdi mdi-account-multiple-outline" style="font-size: 48px; color: #81d4fa;"></i>
                            <h4 style="color: #ffffff; margin: 20px 0;">No teachers available</h4>
                            <p style="color: #b8b8b8;">Start by adding your first teacher to the system.</p>
                            <a href="${pageContext.request.contextPath}/add_teacher.jsp" class="btn" style="background-color: #4f46e5; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">
                                <i class="mdi mdi-plus"></i> Add Teacher
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="teacher" items="${teachers}">
                        <div class="teacher-card" 
                             data-id="${teacher.id}" 
                             data-name="${fn:toLowerCase(teacher.fullName)}"
                             data-subject="${teacher.subject}"
                             data-status="${teacher.status}"
                             data-email="${teacher.email}"
                             data-phone="${teacher.phone}"
                             data-qualification="${teacher.qualification}"
                             data-gender="${teacher.gender}"
                             <c:if test="${param.highlightId eq teacher.id}">style="animation: highlight-pulse 2s ease-in-out;"</c:if>>
                            
                            <!-- Teacher Image -->
                            <c:choose>
                                <c:when test="${not empty teacher.profileImage}">
                                    <img class="teacher-img" src="data:image/jpeg;base64,${teacher.imageBase64}" alt="${teacher.fullName}" />
                                </c:when>
                                <c:otherwise>
                                    <img class="teacher-img" src="${pageContext.request.contextPath}/images/no-image.png" alt="No image available" />
                                </c:otherwise>
                            </c:choose>
                            
                            <h3 class="teacher-name highlight-target">${teacher.fullName}</h3>
                            <div class="teacher-info">
                                <p><strong>Subject:</strong> <span class="highlight-target">${teacher.subject}</span></p>
                                <p><strong>Email:</strong> ${teacher.email}</p>
                                <p><strong>Phone:</strong> ${teacher.phone}</p>
                                <p><strong>Qualification:</strong> ${teacher.qualification}</p>
                                <p><strong>Gender:</strong> ${teacher.gender}</p>
                                <p><strong>Status:</strong> <span class="teacher-status-text">${teacher.status}</span></p>
                            </div>
                            
                            <div class="card-buttons">
                                <button class="btn-edit" data-teacher-id="${teacher.id}">Edit</button>
                                <form action="${pageContext.request.contextPath}/DeleteTeacherServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this teacher?');">
                                    <input type="hidden" name="teacherId" value="${teacher.id}">
                                    <button type="submit" class="btn-delete">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Teacher Details Modal -->
    <div class="teacher-modal" id="teacherModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <h2 id="modalTeacherName">Teacher Name</h2>
                    <span class="modal-badge" id="modalTeacherStatus">Status</span>
                </div>
                <span class="close">&times;</span>
            </div>
            
            <img id="modalTeacherImg" class="modal-img" alt="Teacher Image">

            <div class="modal-details" id="teacherDetails"></div>

            <div class="edit-form" id="editForm" style="display: none;">
                <form id="teacherEditForm" action="${pageContext.request.contextPath}/EditTeacherServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="editTeacherId" name="teacherId" value="">
                    
                    <div class="form-group">
                        <label for="editTeacherFullName">Full Name:</label>
                        <input type="text" id="editTeacherFullName" name="teacherFullName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editTeacherEmail">Email:</label>
                        <input type="email" id="editTeacherEmail" name="teacherEmail" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editTeacherPhone">Phone:</label>
                        <input type="tel" id="editTeacherPhone" name="teacherPhone" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editTeacherSubject">Subject:</label>
                        <input type="text" id="editTeacherSubject" name="teacherSubject" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editTeacherQualification">Qualification:</label>
                        <input type="text" id="editTeacherQualification" name="teacherQualification" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editTeacherGender">Gender:</label>
                        <select id="editTeacherGender" name="teacherGender" class="form-control" required>
                            <option value="">-- Select --</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editTeacherStatus">Status:</label>
                        <select id="editTeacherStatus" name="teacherStatus" class="form-control" required>
                            <option value="">-- Select --</option>
                            <option value="Active">Active</option>
                            <option value="On Leave">On Leave</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editTeacherPassword">New Password (optional):</label>
                        <input type="password" id="editTeacherPassword" name="teacherPassword" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="editTeacherProfileImage">Update Profile Image (optional):</label>
                        <input type="file" id="editTeacherProfileImage" name="teacherProfileImage" class="form-control" accept="image/*">
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
                    <form action="${pageContext.request.contextPath}/DeleteTeacherServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this teacher?');">
                        <input type="hidden" name="teacherId" id="deleteTeacherId" value="">
                        <button type="submit" class="btn-delete-modal">Delete</button>
                    </form>            
                </div>
            </div>
        </div>
    </div>
</c:set>

<!-- Set additional CSS for this page -->
<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mdi/font@6.5.95/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body.modal-open { overflow: hidden; }
        .wrapper { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
        .teacher-container { display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px; }
        .teacher-card { 
            flex: 1 1 calc(25% - 20px); 
            min-width: 280px; 
            background: #191c24; 
            border: 1px solid #2c2c2c; 
            border-radius: 8px; 
            padding: 16px; 
            transition: all 0.3s ease; 
            cursor: pointer; 
            position: relative; 
            display: flex; 
            flex-direction: column; 
        }
        .teacher-card:hover {
            transform: scale(1.02);
            box-shadow: 0 0 10px rgba(129, 212, 250, .3);
            border-color: #81d4fa;
            color: #fff;
        }
        .teacher-card h3 { color: #81d4fa; margin-bottom: 15px; font-size: 1.1rem; }
        .teacher-img { 
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
        .teacher-img:hover { transform: scale(1.1); }
        .teacher-info { flex-grow: 1; margin-right: 90px; }
        .teacher-info p { margin: 8px 0; font-size: 0.9rem; color: #b8b8b8; }
        .card-buttons { display: flex; justify-content: space-between; margin-top: 15px; gap: 10px; }
        .card-buttons button { flex: 1; padding: 8px; font-size: 14px; border: 1px solid; border-radius: 5px; cursor: pointer; transition: 0.3s ease; }
        .btn-edit { background-color: rgba(255, 193, 7, 0.1); color: #ffc107; border-color: #ffc107; }
        .btn-edit:hover { background-color: #ffc107; color: #121212; }
        .btn-delete { background-color: rgba(244, 67, 54, 0.1); color: #f44336; border-color: #f44336; }
        .btn-delete:hover { background-color: #f44336; color: white; }
        .no-teachers-card { background: #191c24; border: 2px dashed #81d4fa; border-radius: 12px; padding: 60px 40px; text-align: center; margin: 40px auto; max-width: 400px; }
        
        /* Search highlighting */
        .highlight { background-color: #FFEB3B; color: #000; padding: 0 2px; border-radius: 3px; font-weight: bold; }
        .highlighted-row { background-color: rgba(255, 235, 59, 0.1) !important; border-left: 3px solid #ffeb3b !important; }
        
        @keyframes highlight-pulse { 
            0%, 100% { box-shadow: 0 0 0 0 rgba(129, 212, 250, 0.7); border-color: #2c2c2c; } 
            50% { box-shadow: 0 0 0 10px rgba(129, 212, 250, 0); border-color: #81d4fa; } 
        }
        
        /* Modal Styles */
        .teacher-modal { 
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
        .teacher-modal.active { opacity: 1; visibility: visible; }
        .modal-content { 
            background: #191c24; 
            border: 1px solid #2c2c2c; 
            border-radius: 10px; 
            width: 90%; 
            max-width: 600px; 
            max-height: 90vh; 
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
        .modal-title { display: flex; align-items: center; gap: 15px; flex-wrap: nowrap; }
        .modal-title h2 { margin: 0; font-size: 24px; color: #81d4fa; flex-shrink: 1; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .modal-badge { 
            padding: 6px 12px; 
            border-radius: 12px; 
            font-size: 12px; 
            font-weight: bold; 
            color: white; 
        }
        .badge-active { background-color: #4caf50; }
        .badge-inactive { background-color: #f44336; }
        .modal-content .close { 
            color: #81d4fa; 
            cursor: pointer; 
            transition: all 0.2s ease;
            font-size: 28px; 
            font-weight: bold; 
        }
        .modal-content .close:hover { color: #ffffff; transform: scale(1.1); }
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
        .modal-details p { margin: 8px 0; padding-bottom: 8px; border-bottom: 1px solid #2c2c2c; font-size: 15px; }
        .modal-details strong { color: #81d4fa; }
        .modal-actions { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-top: 25px; 
            padding-top: 20px; 
            border-top: 1px solid #2c2c2c; 
        }
        .action-buttons { display: none; gap: 10px; }
        .btn-manage, .btn-edit-modal, .btn-delete-modal, .btn-save, .btn-cancel { 
            padding: 10px 20px; 
            border-radius: 5px; 
            font-size: 14px; 
            cursor: pointer; 
            transition: all 0.2s ease; 
            border: 1px solid; 
            font-weight: bold; 
        }
        .btn-manage { background-color: #81d4fa; color: #121212; border-color: #81d4fa; }
        .btn-manage:hover { background-color: #4fc3f7; }
        .btn-edit-modal { background-color: #ffc107; color: #121212; border-color: #ffc107; }
        .btn-edit-modal:hover { background-color: #ffab00; }
        .btn-delete-modal { background-color: #f44336; color: white; border-color: #f44336; }
        .btn-delete-modal:hover { background-color: #e53935; }
        .btn-save { background-color: #4CAF50; color: white; border-color: #4CAF50; }
        .btn-save:hover { background-color: #45a049; }
        .btn-cancel { background-color: #757575; color: white; border-color: #757575; }
        .btn-cancel:hover { background-color: #616161; }
        
        /* Edit form styles */
        .edit-form { 
            margin-top: 20px; 
            padding: 20px; 
            background: rgba(45, 45, 45, 0.3); 
            border-radius: 8px; 
            border: 1px solid #2c2c2c; 
        }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; color: #81d4fa; font-weight: bold; }
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
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; padding-top: 15px; border-top: 1px solid #2c2c2c; }

        /* Filter styles */
        #teacherSearch,
        #subjectFilter,
        #genderFilter,
        #statusFilter { 
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #teacherSearch:focus,
        #subjectFilter:focus,
        #genderFilter:focus,
        #statusFilter:focus {
            outline: none;
            box-shadow: 0 0 0 2px #a5b4fc;
            border-color: #81d4fa;
        }

        /* Alert styles */
        .alert { padding: 15px; margin-bottom: 20px; border: 1px solid transparent; border-radius: 4px; }
        .alert-success { background-color: #d4edda; border-color: #c3e6cb; color: #155724; }
        .alert-danger { background-color: #f8d7da; border-color: #f5c6cb; color: #721c24; }

        @media (max-width: 992px) {
            .teacher-card { flex: 1 1 calc(50% - 20px); }
        }

        @media (max-width: 768px) {
            .teacher-card { flex: 1 1 100%; }
            .teacher-info { margin-right: 0; margin-bottom: 90px; }
            .teacher-card .teacher-img { 
                position: static; 
                width: 100%; 
                height: 180px; 
                margin-bottom: 15px; 
            }
        }
    </style>
</c:set>

<!-- Set additional JavaScript for this page -->
<c:set var="additionalScripts" scope="request">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const teacherCards = document.querySelectorAll('.teacher-card');
            const teacherSearch = document.getElementById('teacherSearch');
            const globalSearch = document.getElementById('searchid');
            const subjectFilter = document.getElementById('subjectFilter');
            const genderFilter = document.getElementById('genderFilter');
            const statusFilter = document.getElementById('statusFilter');
            const teacherModal = document.getElementById('teacherModal');
            const editForm = document.getElementById('editForm');
            const teacherDetails = document.getElementById('teacherDetails');
            let currentCard = null;

            // ===== SEARCH HIGHLIGHT FUNCTIONS =====
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
                const cards = document.querySelectorAll('.teacher-card');
                
                // Remove all existing highlights first
                cards.forEach(card => {
                    removeHighlights(card);
                });
                
                if (!searchTerm || searchTerm.trim() === '') return;
                
                const term = searchTerm.trim().toLowerCase();
                
                cards.forEach(card => {
                    const targets = card.querySelectorAll('.highlight-target');
                    let hasMatch = false;
                    
                    targets.forEach(target => {
                        const text = target.textContent || '';
                        if (text.toLowerCase().includes(term)) {
                            hasMatch = true;
                        }
                    });
                    
                    if (hasMatch) {
                        highlightSearchTerm(card, term);
                    }
                });
            }

            // ===== SEARCH AND FILTER FUNCTIONS =====
            let searchTimer = null;
            let isSubmitting = false;

            function performSearchAndFilter() {
                if (isSubmitting) return;
                isSubmitting = true;
                
                const url = new URL(window.location.href);
                url.searchParams.delete('page');
                
                // Get current form values
                const searchVal = teacherSearch.value.trim();
                const subjectVal = subjectFilter.value;
                const genderVal = genderFilter.value;
                const statusVal = statusFilter.value;
                
                // Set parameters
                if (searchVal) {
                    url.searchParams.set('search', searchVal);
                } else {
                    url.searchParams.delete('search');
                }
                
                if (subjectVal) {
                    url.searchParams.set('subjectFilter', subjectVal);
                } else {
                    url.searchParams.delete('subjectFilter');
                }
                
                if (genderVal) {
                    url.searchParams.set('genderFilter', genderVal);
                } else {
                    url.searchParams.delete('genderFilter');
                }
                
                if (statusVal) {
                    url.searchParams.set('statusFilter', statusVal);
                } else {
                    url.searchParams.delete('statusFilter');
                }
                
                // Preserve type
                url.searchParams.set('type', 'teachers-mg');
                
                window.location.href = url.toString();
            }

            // ===== EVENT LISTENERS =====
            // Search input - live highlighting + debounced search
            teacherSearch.addEventListener('input', function() {
                const searchTerm = this.value.trim();
                
                // Apply highlights immediately while typing
                applySearchHighlights(searchTerm);
                
                // Clear previous timer
                if (searchTimer) {
                    clearTimeout(searchTimer);
                }
                
                // If search is empty, submit immediately to show all results
                if (searchTerm === '') {
                    searchTimer = setTimeout(function() {
                        performSearchAndFilter();
                    }, 300);
                    return;
                }
                
                // Only submit after 500ms of no typing, and only if at least 2 characters
                if (searchTerm.length >= 2) {
                    searchTimer = setTimeout(function() {
                        performSearchAndFilter();
                    }, 500);
                }
            });

            // Search - Enter key submits immediately
            teacherSearch.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (searchTimer) {
                        clearTimeout(searchTimer);
                    }
                    performSearchAndFilter();
                }
            });

            // Subject filter - submit on change
            subjectFilter.addEventListener('change', function() {
                performSearchAndFilter();
            });

            // Gender filter - submit on change
            genderFilter.addEventListener('change', function() {
                performSearchAndFilter();
            });

            // Status filter - submit on change
            statusFilter.addEventListener('change', function() {
                performSearchAndFilter();
            });

            // ===== MODAL FUNCTIONALITY =====
            const resetModal = () => {
                editForm.style.display = 'none';
                teacherDetails.style.display = 'block';
                teacherModal.querySelector('.action-buttons').style.display = 'none';
                teacherModal.querySelector('.btn-manage').style.display = 'block';
                currentCard = null;
            };

            const closeModal = () => {
                teacherModal.classList.remove('active');
                document.body.classList.remove('modal-open');
                resetModal();
            };

            const showTeacherModal = (card) => {
                resetModal();
                currentCard = card;
                document.getElementById('modalTeacherName').textContent = card.dataset.name;
                document.getElementById('modalTeacherImg').src = card.querySelector('.teacher-img').src;
                teacherDetails.innerHTML = card.querySelector('.teacher-info').innerHTML;
                const status = card.dataset.status;
                const statusBadge = document.getElementById('modalTeacherStatus');
                statusBadge.textContent = status;
                statusBadge.className = 'modal-badge ' + (status.toLowerCase() === 'active' ? 'badge-active' : 'badge-inactive');
                document.getElementById('editTeacherId').value = card.dataset.id;
                document.getElementById('deleteTeacherId').value = card.dataset.id;
                teacherModal.classList.add('active');
                document.body.classList.add('modal-open');
            };
            
            const populateAndShowEditForm = (card) => {
                document.getElementById('editTeacherId').value = card.dataset.id;
                document.getElementById('editTeacherFullName').value = card.dataset.name;
                document.getElementById('editTeacherEmail').value = card.dataset.email;
                document.getElementById('editTeacherPhone').value = card.dataset.phone;
                document.getElementById('editTeacherSubject').value = card.dataset.subject;
                document.getElementById('editTeacherQualification').value = card.dataset.qualification;
                document.getElementById('editTeacherGender').value = card.dataset.gender;
                document.getElementById('editTeacherStatus').value = card.dataset.status;
                
                teacherDetails.style.display = 'none';
                editForm.style.display = 'block';
                teacherModal.querySelector('.action-buttons').style.display = 'none';
                teacherModal.querySelector('.btn-manage').style.display = 'none';
            };
            
            teacherCards.forEach(card => {
                card.addEventListener('click', e => {
                    if (!e.target.closest('button, form')) showTeacherModal(card);
                });
                card.querySelector('.btn-edit').addEventListener('click', e => {
                    e.stopPropagation();
                    showTeacherModal(card);
                    setTimeout(() => populateAndShowEditForm(card), 50);
                });
            });

            teacherModal.querySelector('.close').addEventListener('click', closeModal);
            
            teacherModal.addEventListener('click', e => { 
                if (e.target === teacherModal) closeModal();
            });
            
            teacherModal.querySelector('.btn-manage').addEventListener('click', function() {
                const actionButtons = teacherModal.querySelector('.action-buttons');
                actionButtons.style.display = actionButtons.style.display === 'none' ? 'flex' : 'none';
            });
            
            teacherModal.querySelector('.btn-edit-modal').addEventListener('click', function() {
                if (currentCard) {
                    populateAndShowEditForm(currentCard);
                }
            });
            
            teacherModal.querySelector('.btn-cancel').addEventListener('click', resetModal);

            // ===== HANDLE URL PARAMETERS =====
            const urlParams = new URLSearchParams(window.location.search);
            
            // Handle search parameter
            const searchQuery = urlParams.get('search');
            if (searchQuery) {
                teacherSearch.value = searchQuery;
                setTimeout(function() {
                    applySearchHighlights(searchQuery);
                }, 200);
            }
            
            // Handle highlight ID
            const highlightId = urlParams.get('highlightId');
            if (highlightId) {
                const card = document.querySelector(`.teacher-card[data-id="${highlightId}"]`);
                if (card) {
                    card.scrollIntoView({behavior: 'smooth', block: 'center'});
                    card.style.animation = 'highlight-pulse 2s ease-in-out';
                }
            }

            // Auto-edit teacher if session has editTeacherId
            const editTeacherId = '<%= session.getAttribute("editTeacherId") %>';
            if (editTeacherId && editTeacherId !== 'null' && editTeacherId !== '') {
                setTimeout(() => {
                    const teacherCard = document.querySelector(`.teacher-card[data-id="${editTeacherId}"]`);
                    if (teacherCard) {
                        teacherCard.scrollIntoView({behavior: 'smooth', block: 'center'});
                        teacherCard.style.animation = 'highlight-pulse 2s ease-in-out';

                        // Open edit modal after a delay
                        setTimeout(() => {
                            const editButton = teacherCard.querySelector('.btn-edit');
                            if (editButton) {
                                editButton.click();
                            }
                        }, 500);
                    }
                    // Clear the session attribute via AJAX
                    fetch('${pageContext.request.contextPath}/ClearEditTeacherIdServlet')
                        .catch(err => console.log('Error clearing session:', err));
                }, 500);
            }
        });
        
        function clearAllFilters() {
            window.location.href = '${pageContext.request.contextPath}/AllSearchandPagination?type=teachers-mg';
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
<%@ include file="Base.jsp" %>