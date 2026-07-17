<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.*" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
    if (request.getAttribute("events") == null) {
        try {
            DAO eventDAO = new DAO();
            List<Event> events = eventDAO.getAllEvents();
            List<String> category = eventDAO.getAllCategoriesOfEvents(true);
            request.setAttribute("category", category);
            request.setAttribute("eventList", events);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        request.getRequestDispatcher("/AllSearchandPagination?type=events-mg").forward(request, response);
        return;
    }
%>

<!-- Set variables for base.jsp -->
<c:set var="pageTitle" value="Manage Events - Campora Admin Panel" scope="request" />

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

        .event-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }
    
        .event-card {
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
    
        .event-card h3 {
            color: #81d4fa;
            margin-bottom: 15px;
            font-weight: bold;
            font-size: 1.1rem;
        }
    
        .event-card:hover {
            transform: scale(1.02);
            box-shadow: 0 0 10px rgba(129, 212, 250, 0.3);
            border-color: #81d4fa;
            color: #ffffff;
        }

        .event-card .event-img {
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

        .event-card .event-img:hover {
            transform: scale(1.1);
        }

        .event-info {
            flex-grow: 1;
            margin-right: 90px;
        }

        .event-info p {
            margin: 8px 0;
            font-size: 0.9rem;
            color: #b8b8b8;
        }

        .event-description {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .event-status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }

        .status-upcoming {
            background-color: #4caf50;
            color: white;
        }

        .status-past {
            background-color: #f44336;
            color: white;
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

        .no-events-card {
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

        /* Highlight animation for new/updated events */
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
        .event-modal {
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
        
        .event-modal.active {
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

        .modal-badge-past {
            background-color: #f44336;
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
        #eventSearch,
        #categoryFilter,
        #statusFilter,
        #pageFilter {
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #eventSearch:focus,
        #categoryFilter:focus,
        #statusFilter:focus,
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

        /* Pagination styles */
        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding: 15px 0;
            border-top: 1px solid #2c2c2c;
        }

        .pagination {
            display: flex;
            gap: 5px;
            margin: 0;
        }

        .pagination .page-item {
            list-style: none;
        }

        .pagination .page-link {
            padding: 8px 14px;
            border: 1px solid #444;
            border-radius: 4px;
            background-color: #191c24;
            color: #e0e0e0;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .pagination .page-link:hover {
            background-color: #2c2c2c;
            border-color: #81d4fa;
        }

        .pagination .page-item.active .page-link {
            background-color: #81d4fa;
            color: #121212;
            border-color: #81d4fa;
        }

        .pagination .page-item.disabled .page-link {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .pagination-info {
            color: #b8b8b8;
            font-size: 14px;
        }

        /* Responsive design */
        @media (max-width: 992px) {
            .event-card {
                flex: 1 1 calc(50% - 20px);
            }
        }

        @media (max-width: 768px) {
            .event-card {
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

            .event-info {
                margin-right: 0;
                margin-bottom: 90px;
            }

            .event-card .event-img {
                position: static;
                width: 100%;
                height: 160px;
                margin-bottom: 15px;
            }

            .pagination-container {
                flex-direction: column;
                gap: 15px;
                align-items: center;
            }
        }
    </style>
</c:set>

<c:set var="pageContent" scope="request">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <h3 class="page-title mb-0">Manage Events</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/Admin_penal.jsp">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Manage Events</li>
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
            <form method="get" action="${pageContext.request.contextPath}/AllSearchandPagination" id="filterForm">
                <input type="hidden" name="type" value="events-mg">                
                <div class="row align-items-end g-3">
                    <div class="col-md-3">
                        <label class="form-label mb-1 small" for="eventSearch">Search</label>
                        <div class="input-group">
                            <input type="text" name="search" class="form-control form-control-sm" 
                                   placeholder="Search events" id="eventSearch" value="${param.search}">
                            <c:if test="${not empty param.search or not empty param.categoryFilter or not empty param.statusFilter}">
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
                        <select name="categoryFilter" class="form-control form-control-sm" id="categoryFilter">
                            <option value="">All Categories</option>
                            <c:forEach var="ccategories" items="${category}">
                                <option value="${ccategories}" ${param.categoryFilter == ccategories ? 'selected' : ''}>${ccategories}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label mb-1 small" for="statusFilter">Status</label>
                        <select name="statusFilter" class="form-control form-control-sm" id="statusFilter">
                            <option value="">All Status</option>
                            <option value="Upcoming" ${param.statusFilter == 'Upcoming' ? 'selected' : ''}>Upcoming</option>
                            <option value="Past" ${param.statusFilter == 'Past' ? 'selected' : ''}>Past</option>
                        </select>
                    </div>

                    <div class="col-md-2"></div>

                    <div class="col-md-3 d-flex justify-content-end align-items-end">
                        <div style="width: 65%;">
                            <label class="form-label mb-1 small text-white d-block text-center">Add</label>
                            <a href="${pageContext.request.contextPath}/add_events.jsp">
                                <button type="button" class="btn btn-sm d-flex align-items-center justify-content-center w-100"
                                    style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                                    <i class="mdi mdi-plus-circle-outline me-1" style="font-size: 14px;"></i> Add Event
                                </button>
                            </a>
                        </div>
                    </div>
                </div>
            </form>                
        </div>
    </div>

    <!-- Event Cards Container -->
    <div class="wrapper">
        <div class="event-container">
            <c:choose>
                <c:when test="${empty events}">
                    <div class="col-12 text-center">
                        <div class="no-events-card">
                            <i class="mdi mdi-calendar" style="font-size: 48px; color: #81d4fa;"></i>
                            <h4 style="color: #ffffff; margin: 20px 0;">No events available</h4>
                            <p style="color: #b8b8b8;">Start by adding your first event to the system.</p>
                            <a href="${pageContext.request.contextPath}/add_events.jsp" class="btn" style="background-color: #4f46e5; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">
                                <i class="mdi mdi-plus"></i> Add Event
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="event" items="${events}">
                        <c:set var="isUpcoming" value="${event.date.time >= today.time}" />
                        <div class="event-card" 
                             data-id="${event.id}" 
                             data-title="${fn:toLowerCase(event.title)}"
                             data-category="${event.category}"
                             data-description="${fn:toLowerCase(event.description)}"
                             data-status="${isUpcoming ? 'Upcoming' : 'Past'}"
                             <c:if test="${param.highlightId eq event.id}">style="animation: highlight-pulse 2s ease-in-out;"</c:if>>
                            
                            <!-- Event Image -->
                            <c:choose>
                                <c:when test="${not empty event.image}">
                                    <img class="event-img" src="data:image/jpeg;base64,${event.imageBase64}" alt="${event.title}" />
                                </c:when>
                                <c:otherwise>
                                    <img class="event-img" src="${pageContext.request.contextPath}/assets/images/no-image.png" alt="No image available" />
                                </c:otherwise>
                            </c:choose>
                            
                            <h3 class="event-title highlight-target">${event.title}</h3>
                            <div class="event-info">
                                <p><strong>Category:</strong> <span class="highlight-target">${event.category}</span></p>
                                <p><strong>Date:</strong> ${event.date}</p>
                                <p><strong>Price:</strong> $${event.price}</p>
                                <p><strong>Status:</strong> 
                                    <span class="event-status-badge ${isUpcoming ? 'status-upcoming' : 'status-past'}">
                                        ${isUpcoming ? 'Upcoming' : 'Past'}
                                    </span>
                                </p>
                                <p><strong>Description:</strong> <span class="highlight-target event-description">${event.description}</span></p>
                            </div>
                            
                            <div class="card-buttons">
                                <button class="btn-edit" data-event-id="${event.id}">Edit</button>
                                <form action="${pageContext.request.contextPath}/DeleteEventServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="eventId" value="${event.id}">
                                    <button type="submit" class="btn-delete" data-event-id="${event.id}" onclick="return confirm('Are you sure you want to delete this event?')">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${not empty events and totalPages > 1}">
        <div class="pagination-container">
            <div class="pagination-info">
                Showing ${startItem} - ${endItem} of ${totalItems} events
            </div>
            <nav aria-label="Event pagination">
                <ul class="pagination">
                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?type=events-mg&page=${currentPage - 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.categoryFilter ? '&categoryFilter='.concat(param.categoryFilter) : ''}${not empty param.statusFilter ? '&statusFilter='.concat(param.statusFilter) : ''}">Previous</a>
                    </li>
                    
                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?type=events-mg&page=${pageNum}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.categoryFilter ? '&categoryFilter='.concat(param.categoryFilter) : ''}${not empty param.statusFilter ? '&statusFilter='.concat(param.statusFilter) : ''}">${pageNum}</a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/AllSearchandPagination?type=events-mg&page=${currentPage + 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.categoryFilter ? '&categoryFilter='.concat(param.categoryFilter) : ''}${not empty param.statusFilter ? '&statusFilter='.concat(param.statusFilter) : ''}">Next</a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>

    <!-- Event Details Modal -->
    <div class="event-modal" id="eventModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <h2 id="modalEventTitle">Event Title</h2>
                    <span class="modal-badge" id="modalEventStatus">Active</span>
                </div>
                <span class="close">&times;</span>
            </div>
            
            <img id="modalEventImg" class="modal-img" alt="Event Image">
            
            <div class="modal-details" id="eventDetails">
                <!-- Event details will be populated here -->
            </div>

            <!-- Edit Form (Initially Hidden) -->
            <div class="edit-form" id="editForm" style="display: none;">
                <form id="eventEditForm" action="${pageContext.request.contextPath}/EditEventServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="editEventId" name="eventId" value="">
                    
                    <div class="form-group">
                        <label for="editEventTitle">Event Title:</label>
                        <input type="text" id="editEventTitle" name="title" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="editEventImg">Update Image (optional):</label>
                        <input type="file" id="editEventImg" name="image" class="form-control" accept="image/*">
                    </div>

                    <div class="form-group">
                        <label for="editEventDescription">Description:</label>
                        <textarea id="editEventDescription" name="description" class="form-control" rows="5" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="editEventDate">Date:</label>
                        <input type="date" id="editEventDate" name="date" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="editEventPrice">Price:</label>
                        <input type="number" id="editEventPrice" name="price" class="form-control" step="0.01" required>
                    </div>

                    <div class="form-group">
                        <label for="editEventCategory">Category:</label>
                        <select id="editEventCategory" name="category" class="form-control" required>
                            <option value="">-- Select Category --</option>
                            <c:forEach var="ccategories" items="${category}">
                                <option value="${ccategories}">${ccategories}</option>
                            </c:forEach>
                        </select>
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
                    <form action="${pageContext.request.contextPath}/DeleteEventServlet" method="post" style="display:inline;">
                        <input type="hidden" name="eventId" id="modalDeleteEventId" value="">
                        <button type="submit" class="btn-delete-modal" onclick="return confirm('Are you sure you want to delete this event?')">Delete</button>
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
            const events = document.querySelectorAll('.event-card');
            const eventSearch = document.getElementById('eventSearch');
            const categoryFilter = document.getElementById('categoryFilter');
            const statusFilter = document.getElementById('statusFilter');
            const eventModal = document.getElementById('eventModal');
            const editForm = document.getElementById('editForm');
            const eventDetails = document.getElementById('eventDetails');
            const eventEditForm = document.getElementById('eventEditForm');

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
                const eventCards = document.querySelectorAll('.event-card');
                
                eventCards.forEach(card => {
                    removeHighlights(card);
                });
                
                if (!searchTerm || searchTerm.trim() === '') return;
                
                const term = searchTerm.trim().toLowerCase();
                
                eventCards.forEach(card => {
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
                
                const searchVal = eventSearch.value.trim();
                const categoryVal = categoryFilter.value;
                const statusVal = statusFilter.value;
                
                if (searchVal) {
                    url.searchParams.set('search', searchVal);
                } else {
                    url.searchParams.delete('search');
                }
                
                if (categoryVal) {
                    url.searchParams.set('categoryFilter', categoryVal);
                } else {
                    url.searchParams.delete('categoryFilter');
                }
                
                if (statusVal) {
                    url.searchParams.set('statusFilter', statusVal);
                } else {
                    url.searchParams.delete('statusFilter');
                }
                
                url.searchParams.set('type', 'events-mg');
                
                window.location.href = url.toString();
            }

            // ===== EVENT LISTENERS =====
            // Search input - live highlighting + debounced search
            eventSearch.addEventListener('input', function() {
                const searchTerm = this.value.trim();
                
                applySearchHighlights(searchTerm);
                
                if (searchTimer) {
                    clearTimeout(searchTimer);
                }
                
                if (searchTerm === '') {
                    searchTimer = setTimeout(function() {
                        performSearchAndFilter();
                    }, 300);
                    return;
                }
                
                if (searchTerm.length >= 2) {
                    searchTimer = setTimeout(function() {
                        performSearchAndFilter();
                    }, 500);
                }
            });

            eventSearch.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (searchTimer) {
                        clearTimeout(searchTimer);
                    }
                    performSearchAndFilter();
                }
            });

            categoryFilter.addEventListener('change', function() {
                performSearchAndFilter();
            });

            statusFilter.addEventListener('change', function() {
                performSearchAndFilter();
            });

            // ===== MODAL FUNCTIONALITY =====
            events.forEach(event => {
                event.addEventListener('click', function(e) {
                    if (e.target.classList.contains('btn-edit') || e.target.classList.contains('btn-delete')) {
                        return;
                    }
                    showEventModal(this);
                });
            });

            function showEventModal(eventCard) {
                const eventId = eventCard.getAttribute('data-id');
                const eventTitle = eventCard.querySelector('.event-title').textContent;
                const eventImg = eventCard.querySelector('.event-img');
                const eventInfo = eventCard.querySelector('.event-info');
                
                document.getElementById('modalEventTitle').textContent = eventTitle;
                document.getElementById('modalEventImg').src = eventImg.src;
                document.getElementById('modalEventImg').alt = eventImg.alt;
                document.getElementById('modalDeleteEventId').value = eventId;
                
                // Set status badge
                const statusElement = eventInfo.querySelector('.event-status-badge');
                const statusBadge = document.getElementById('modalEventStatus');
                if (statusElement) {
                    const statusText = statusElement.textContent.trim();
                    statusBadge.textContent = statusText;
                    statusBadge.className = 'modal-badge' + (statusText === 'Past' ? ' modal-badge-past' : '');
                }
                
                const infoPs = eventInfo.querySelectorAll('p');
                let detailsHTML = '';
                infoPs.forEach(p => {
                    detailsHTML += '<p>' + p.innerHTML + '</p>';
                });
                
                detailsHTML += '<p><strong>Event ID:</strong> ' + eventId + '</p>';

                eventDetails.innerHTML = detailsHTML;
                
                eventModal.classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            function closeModal() {
                eventModal.classList.remove('active');
                editForm.style.display = 'none';
                eventDetails.style.display = 'block';
                document.querySelector('.action-buttons').style.display = 'none';
                document.body.style.overflow = '';
            }

            // Modal event listeners
            eventModal.querySelector('.close').addEventListener('click', closeModal);
            eventModal.addEventListener('click', function(e) {
                if (e.target === eventModal) {
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
                    eventDetails.style.display = 'none';
                    populateEditForm();
                }
            });

            document.querySelector('.btn-cancel').addEventListener('click', function() {
                editForm.style.display = 'none';
                eventDetails.style.display = 'block';
            });

            // Populate edit form with event data
            function populateEditForm() {
                const eventDetails = document.getElementById('eventDetails');
                const details = eventDetails.querySelectorAll('p');

                let category = '', date = '', price = '', description = '', eventId = '';
                
                details.forEach(p => {
                    const text = p.textContent;
                    if (text.includes('Category:')) category = text.split('Category:')[1].trim();
                    if (text.includes('Date:')) date = text.split('Date:')[1].trim();
                    if (text.includes('Price:')) price = text.split('$')[1].trim();
                    if (text.includes('Description:')) description = text.split('Description:')[1].trim();
                    if (text.includes('Event ID:')) eventId = text.split('Event ID:')[1].trim();
                });

                document.getElementById('editEventId').value = eventId;
                document.getElementById('editEventTitle').value = document.getElementById('modalEventTitle').textContent;
                document.getElementById('editEventDescription').value = description;
                document.getElementById('editEventDate').value = formatDateForInput(date);
                document.getElementById('editEventPrice').value = price;
                document.getElementById('editEventCategory').value = category;
            }

            function formatDateForInput(dateString) {
                const months = {
                    'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
                    'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
                };
                
                const parts = dateString.split(' ');
                if (parts.length === 3) {
                    const month = months[parts[0]];
                    const day = parts[1].replace(',', '').padStart(2, '0');
                    const year = parts[2];
                    return `${year}-${month}-${day}`;
                }
                return dateString;
            }

            // Edit form submission
            eventEditForm.addEventListener('submit', function(e) {
                e.preventDefault();

                const formData = new FormData(this);
                const eventId = formData.get('eventId');

                fetch('${pageContext.request.contextPath}/EditEventServlet', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(data => {
                    if (data.toLowerCase().includes("success")) {
                        alert('Event updated successfully!');
                        window.location.href = "${pageContext.request.contextPath}/manage_events.jsp?highlightId=" + eventId;
                    } else {
                        alert('Error updating event: ' + data);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating event. Please try again.');
                });
            });

            // Edit buttons on cards
            document.querySelectorAll('.btn-edit').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const eventId = this.getAttribute('data-event-id');
                    const eventCard = this.closest('.event-card');
                    showEventModal(eventCard);
                    
                    setTimeout(() => {
                        document.querySelector('.btn-manage').click();
                        document.querySelector('.btn-edit-modal').click();
                    }, 100);
                });
            });

            // Check for event ID to highlight from session/URL
            const urlParams = new URLSearchParams(window.location.search);
            const highlightId = urlParams.get('highlightId');
            const editEventIdFromSession = '<%= session.getAttribute("editEventId") %>';

            if (highlightId) {
                const eventCard = document.querySelector(`.event-card[data-id="${highlightId}"]`);
                if (eventCard) {
                    eventCard.scrollIntoView({behavior: 'smooth', block: 'center'});
                    eventCard.style.animation = 'highlight-pulse 2s ease-in-out';
                    
                    if (editEventIdFromSession && editEventIdFromSession !== 'null') {
                        const editButton = eventCard.querySelector('.btn-edit');
                        if (editButton) {
                            fetch('${pageContext.request.contextPath}/ClearEditEventIdServlet')
                                .then(() => {
                                    setTimeout(() => {
                                        editButton.click();
                                    }, 300);
                                });
                        }
                    }
                }
            }

            // Handle URL parameters for search
            const searchQuery = urlParams.get('search');
            if (searchQuery) {
                eventSearch.value = searchQuery;
                setTimeout(function() {
                    applySearchHighlights(searchQuery);
                }, 200);
            }

            // Delete event from modal
            document.querySelector('.btn-delete-modal').addEventListener('click', function(e) {
                const eventId = document.getElementById('modalDeleteEventId').value;
                if (!eventId) {
                    alert('Event ID not found');
                    return;
                }
                // The form will handle the submission
            });

            // Page reload handling
            const navEntries = performance.getEntriesByType("navigation");
            if (navEntries.length > 0 && navEntries[0].type === "reload") {
                const isLoggedIn = <%= isUserLoggedIn %>;
                if (!isLoggedIn) {
                    window.location.replace("LoginForm.jsp");
                }
            }
        });

        function clearAllFilters() {
            window.location.href = '${pageContext.request.contextPath}/AllSearchandPagination?type=events-mg';
        }
    </script>
</c:set>

<!-- Include the base template -->
<jsp:include page="Base.jsp" />