<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="mypackage.*" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="java.util.ArrayList" %>

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
    // Get today's date for status comparison
    Date today = new Date();
    request.setAttribute("today", today);
%>

<%
    // Handle search parameter - MUST be BEFORE pagination
    String searchParam = request.getParameter("search");
    
    // Handle filter parameters
    String categoryFilter = request.getParameter("categoryFilter");
    String statusFilter = request.getParameter("statusFilter");
    
    List<Event> allEvents = null;
    
    if (request.getAttribute("events") == null) {
        try {
            DAO eventDAO = new DAO();
            allEvents = eventDAO.getAllEvents();
            List<String> category = eventDAO.getAllCategoriesOfEvents(true);
            request.setAttribute("category", category);
            
            // Apply search filter if search parameter exists
            if (searchParam != null && !searchParam.trim().isEmpty()) {
                String searchTerm = searchParam.toLowerCase().trim();
                List<Event> filteredEvents = new ArrayList<>();
                
                for (Event event : allEvents) {
                    // Search in multiple fields with null checks
                    String eventTitle = event.getTitle() != null ? event.getTitle().toLowerCase() : "";
                    String eventCategory = event.getCategory() != null ? event.getCategory().toLowerCase() : "";
                    String eventDescription = event.getDescription() != null ? event.getDescription().toLowerCase() : "";
                    
                    if (eventTitle.contains(searchTerm) ||
                        eventCategory.contains(searchTerm) ||
                        eventDescription.contains(searchTerm)) {
                        filteredEvents.add(event);
                    }
                }
                allEvents = filteredEvents;
            }
            
            // Apply category filter
            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                List<Event> filteredByCategory = new ArrayList<>();
                String filterCategory = categoryFilter.trim();
                
                for (Event event : allEvents) {
                    if (event.getCategory() != null && 
                        event.getCategory().equalsIgnoreCase(filterCategory)) {
                        filteredByCategory.add(event);
                    }
                }
                allEvents = filteredByCategory;
            }
            
            // Apply status filter
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                List<Event> filteredByStatus = new ArrayList<>();
                String filterStatus = statusFilter.trim();
                Date todayFilter = new Date();
                
                for (Event event : allEvents) {
                    Date eventDate = event.getDate();
                    boolean matches = false;
                    
                    if (filterStatus.equalsIgnoreCase("Upcoming")) {
                        matches = (eventDate != null && eventDate.after(todayFilter));
                    } else if (filterStatus.equalsIgnoreCase("Completed")) {
                        matches = (eventDate != null && (eventDate.before(todayFilter) || eventDate.equals(todayFilter)));
                    }
                    
                    if (matches) {
                        filteredByStatus.add(event);
                    }
                }
                allEvents = filteredByStatus;
            }
            
            request.setAttribute("events", allEvents);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
    } else {
        allEvents = (List<Event>) request.getAttribute("events");
        
        // Apply search filter to existing events if search parameter exists
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            String searchTerm = searchParam.toLowerCase().trim();
            List<Event> filteredEvents = new ArrayList<>();
            
            for (Event event : allEvents) {
                String eventTitle = event.getTitle() != null ? event.getTitle().toLowerCase() : "";
                String eventCategory = event.getCategory() != null ? event.getCategory().toLowerCase() : "";
                String eventDescription = event.getDescription() != null ? event.getDescription().toLowerCase() : "";
                
                if (eventTitle.contains(searchTerm) ||
                    eventCategory.contains(searchTerm) ||
                    eventDescription.contains(searchTerm)) {
                    filteredEvents.add(event);
                }
            }
            allEvents = filteredEvents;
        }
        
        // Apply category filter
        if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
            List<Event> filteredByCategory = new ArrayList<>();
            String filterCategory = categoryFilter.trim();
            
            for (Event event : allEvents) {
                if (event.getCategory() != null && 
                    event.getCategory().equalsIgnoreCase(filterCategory)) {
                    filteredByCategory.add(event);
                }
            }
            allEvents = filteredByCategory;
        }
        
        // Apply status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            List<Event> filteredByStatus = new ArrayList<>();
            String filterStatus = statusFilter.trim();
            Date todayFilter = new Date();
            
            for (Event event : allEvents) {
                Date eventDate = event.getDate();
                boolean matches = false;
                
                if (filterStatus.equalsIgnoreCase("Upcoming")) {
                    matches = (eventDate != null && eventDate.after(todayFilter));
                } else if (filterStatus.equalsIgnoreCase("Completed")) {
                    matches = (eventDate != null && (eventDate.before(todayFilter) || eventDate.equals(todayFilter)));
                }
                
                if (matches) {
                    filteredByStatus.add(event);
                }
            }
            allEvents = filteredByStatus;
        }
    }
    
    // Pagination parameters
    int pageSize = 5; // Number of entries per page
    int currentPage = 1;
    int totalPages = 0;
    List<Event> paginatedEvents = new ArrayList<>();
    
    if (allEvents != null && !allEvents.isEmpty()) {
        // Get page number from request parameter
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        
        // Calculate pagination
        int totalItems = allEvents.size();
        totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
        // Ensure current page is within bounds
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        
        // Calculate start and end indices
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalItems);
        
        // Get paginated events
        for (int i = startIndex; i < endIndex; i++) {
            paginatedEvents.add(allEvents.get(i));
        }
        
        // Set pagination attributes
        request.setAttribute("paginatedEvents", paginatedEvents);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("startItem", startIndex + 1);
        request.setAttribute("endItem", endIndex);
    }
%>

<c:set var="pageTitle" value="View Events - Campora Admin" scope="request" />

<c:set var="additionalCSS" scope="request">
    <style>
        /* Custom styles for events */
        .event-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
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
        
        .status-badge-upcoming {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
        
        .status-badge-completed {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        #eventsTable tbody tr {
            background-color: transparent;
            color: #b8b8b8;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        #eventsTable tbody tr:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.05) !important;
        }

        #eventsTable .badge-success {
            background-color: #2e7d32;
            color: #e3fbe5;
        }

        #eventsTable .badge-warning {
            background-color: #b58900;
            color: #fff9e6;
        }

        #eventsTable .badge-danger {
            background-color: #b22222;
            color: #fceaea;
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

        #eventsTable th,
        #eventsTable td {
            vertical-align: middle;
        }

        /* Table body styling - transparent and no borders */
        #eventsTable tbody tr {
            background-color: transparent !important;
        }
        
        #eventsTable tbody td {
            border: none !important;
            background-color: transparent !important;
        }

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
        
        .card-detail .event-img-large {
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
        
        .card-detail .event-img-large:hover {
            transform: translateY(-55%) scale(1.2);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .highlight {
            background-color: #FFEB3B;
            font-weight: normal;
        }

        .highlighted-row {
            background-color: rgba(255, 235, 59, 0.2) !important;
            transition: background-color 0.3s ease;
        }
        
        /* Responsive styles */
        @media (max-width: 768px) {
            .card-detail .event-img-large {
                position: static;
                width: 150px;
                height: 150px;
                margin: 0 auto 20px;
                transform: none;
            }
            
            .card-detail ul {
                margin-left: 0;
            }
        }

        /* View toggle functionality */
        #back:checked ~ .table-view {
            display: block;
        }
        #back:checked ~ .card-detail {
            display: none;
        }

        <c:forEach var="event" items="${paginatedEvents}" varStatus="loop">
            #view${loop.index + 1}:checked ~ .table-view {
                display: none;
            }
            #view${loop.index + 1}:checked ~ .card${loop.index + 1} {
                display: block;
            }
        </c:forEach>

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
        #eventSearch,
        #categoryFilter,
        #statusFilter {
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #eventSearch:focus,
        #categoryFilter:focus,
        #statusFilter:focus {
            outline: none;
            box-shadow: 0 0 0 2px #a5b4fc;
            border-color: #81d4fa;
        }
    </style>
</c:set>

<c:set var="pageContent" scope="request">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <h3 class="page-title mb-0">View Events</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="#">Events</a></li>
                <li class="breadcrumb-item active" aria-current="page">View Events</li>
            </ol>
        </nav>
    </div>

    <!-- Error Alert -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

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
    <form method="get" action="view_events.jsp" id="filterForm">
    <div class="card mb-3 border-0" style="background-color: transparent;">
        <div class="card-body py-2 px-3">
            <div class="row align-items-end g-3">
                <div class="col-md-3">
                    <label class="form-label mb-1 small" for="eventSearch">Search</label>
                    <div class="input-group">
                        <input type="text" class="form-control form-control-sm" 
                               placeholder="Search all events" 
                               id="eventSearch"
                               name="search"
                               value="${param.search}">
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
                    <select class="form-control form-control-sm" id="categoryFilter" name="categoryFilter">
                        <option value="">All</option>
                        <c:forEach var="ccategories" items="${category}">
                        <option value="${ccategories}" ${param.categoryFilter == '${ccategories}' ? 'selected' : ''}>${ccategories}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label mb-1 small" for="statusFilter">Status</label>
                    <select class="form-control form-control-sm" id="statusFilter" name="statusFilter">
                        <option value="">All</option>
                        <option value="Upcoming" ${param.statusFilter == 'Upcoming' ? 'selected' : ''}>Upcoming</option>
                        <option value="Completed" ${param.statusFilter == 'Completed' ? 'selected' : ''}>Completed</option>
                    </select>
                </div>

                <div class="col-md-5 d-flex justify-content-end align-items-end" style="gap: 10px;">
                    <div>
                        <label class="form-label mb-1 small text-white d-block">Add</label>
                        <a href="add_events.jsp"><button type="button" class="btn btn-sm d-flex align-items-center justify-content-center" id="addBtn"
                            style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                            <i class="mdi mdi-plus-circle-outline me-1" style="font-size: 14px;"></i> Add
                        </button></a>
                    </div>
                    <div>
                        <label class="form-label mb-1 small text-white d-block">Manage</label>
                        <a href="manage_events.jsp"><button type="button" class="btn btn-sm d-flex align-items-center justify-content-center" id="exportBtn"
                            style="background-color: #dfb016; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                            <i class="mdi mdi-cog me-1" style="font-size: 14px;"></i> Manage
                        </button></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>

    <!-- Hidden radio buttons to control view -->
    <input type="radio" id="back" name="event-toggle" hidden checked>
    <c:forEach var="event" items="${paginatedEvents}" varStatus="loop">
        <input type="radio" id="view${loop.index + 1}" name="event-toggle" hidden>
    </c:forEach>

    <!-- Events Table with Expandable Details -->
    <div class="table-responsive draggable-table-container table-view">
        <table class="table table-striped mb-0" id="eventsTable">
            <thead class="thead-dark">
                <tr>
                    <th>#</th>
                    <th>Image</th>
                    <th class="sortable">Title</th>
                    <th class="sortable">Description</th>
                    <th class="sortable">Date</th>
                    <th class="sortable">Price</th>
                    <th class="sortable">Category</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty paginatedEvents}">
                        <tr>
                            <td colspan="8" style="text-align:center; color: #f44336; font-weight: bold;">
                                <c:choose>
                                    <c:when test="${not empty param.search or not empty param.categoryFilter or not empty param.statusFilter}">
                                        No events found matching your filters
                                    </c:when>
                                    <c:otherwise>
                                        No events available
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="event" items="${paginatedEvents}" varStatus="loop">
                            <tr class="clickable-row" data-target="view${loop.index + 1}" data-id="${event.id}">
                                <td>${(currentPage - 1) * 5 + loop.index + 1}</td>
                                <td class="py-1">
                                    <c:if test="${not empty event.image}">
                                        <img src="data:image/jpeg;base64,${event.imageBase64}" alt="Event Image" class="event-img"/>
                                    </c:if>
                                    <c:if test="${empty event.image}">
                                        <img src="${pageContext.request.contextPath}/assets/images/meeting-0${(loop.index % 4) + 1}.jpg" alt="Event Image" class="event-img"/>
                                    </c:if>
                                </td>
                                <td class="highlight-target">${event.title}</td>
                                <td class="highlight-target">${fn:substring(event.description, 0, 30)}${fn:length(event.description) > 30 ? '...' : ''}</td>
                                <td class="highlight-target"><fmt:formatDate value="${event.date}" pattern="MMM dd, yyyy" /></td>
                                <td class="highlight-target">&#8377;${event.price}</td>
                                <td class="highlight-target">${event.category}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/EditEventServlet" method="get" style="display:inline;">
                                        <input type="hidden" name="id" value="${event.id}" />
                                        <button type="submit" class="btn btn-icon btn-edit">
                                            <i class="mdi mdi-pencil"></i> Edit
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

    <!-- Event Detail Cards -->
    <c:forEach var="event" items="${paginatedEvents}" varStatus="loop">
        <div class="card-detail card${loop.index + 1} position-relative p-3">
            <!-- Manage Button (Top Right) -->
            <a href="manage_events.jsp"><button class="btn btn-info position-absolute" style="top: 22px; right: 42px; z-index: 1;">
                ⚙ Manage
            </button></a>

            <div class="card-content text-start">
                <c:if test="${not empty event.image}">
                    <img src="data:image/jpeg;base64,${event.imageBase64}" alt="Event Image" class="event-img-large" />
                </c:if>
                <c:if test="${empty event.image}">
                    <img src="${pageContext.request.contextPath}/assets/images/meeting-0${(loop.index % 4) + 1}.jpg" alt="Event Image" class="event-img-large" />
                </c:if>
                
                <h4>${event.title}</h4>
                <c:choose>
                    <c:when test="${event.date > today}">
                        <span class="status-badge">Upcoming</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge-completed">Completed</span>
                    </c:otherwise>
                </c:choose>
                
                <ul class="mt-2">
                    <li><strong>Description:</strong> ${event.description}</li>
                    <li><strong>Date:</strong> <fmt:formatDate value="${event.date}" pattern="MMMM dd, yyyy" /></li>
                    <li><strong>Time:</strong> <fmt:formatDate value="${event.date}" pattern="h:mm a" /></li>
                    <li><strong>Price:</strong> $${event.price}</li>
                    <li><strong>Category:</strong> ${event.category}</li>
                    <li><strong>Location:</strong> Main Campus Auditorium</li>
                    <li><strong>Organizer:</strong> Student Affairs Office</li>
                    <li><strong>Contact:</strong> events@campora.edu</li>
                </ul>
                
                <label for="back" class="btn btn-outline-info mt-4" style="display: flex; justify-self: center; justify-content: center; width: 400px; text-align: center;">← Back to List</label>
            </div>
        </div>
    </c:forEach>

    <!-- Table Footer Row with Entry Info & Pagination -->
    <c:if test="${not empty paginatedEvents and totalPages > 0}">
        <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
            <!-- Entry Count Info (Left) -->
            <div class="table-info text-muted small">
                Showing <strong>${startItem}</strong> to <strong>${endItem}</strong> of <strong>${totalItems}</strong> entries
                <c:if test="${not empty param.search or not empty param.categoryFilter or not empty param.statusFilter}">
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
                                <a class="page-link" href="?page=${currentPage - 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.categoryFilter}">&categoryFilter=${param.categoryFilter}</c:if><c:if test="${not empty param.statusFilter}">&statusFilter=${param.statusFilter}</c:if>">Previous</a>
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
                                    <a class="page-link" href="?page=${pageNum}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.categoryFilter}">&categoryFilter=${param.categoryFilter}</c:if><c:if test="${not empty param.statusFilter}">&statusFilter=${param.statusFilter}</c:if>">${pageNum}</a>
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
                                <a class="page-link" href="?page=${currentPage + 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.categoryFilter}">&categoryFilter=${param.categoryFilter}</c:if><c:if test="${not empty param.statusFilter}">&statusFilter=${param.statusFilter}</c:if>">Next</a>
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
            document.getElementById('eventSearch').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    // Remove page parameter when searching (go to page 1)
                    const url = new URL(window.location.href);
                    url.searchParams.delete('page');
                    document.getElementById('filterForm').action = url.toString();
                    document.getElementById('filterForm').submit();
                }
            });

            // Add debouncing for search input
            document.getElementById('eventSearch').addEventListener('input', function() {
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

            // Category filter - Auto-submit on change
            document.getElementById('categoryFilter').addEventListener('change', function() {
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
        
            // This is for Universal Search
            const urlParams2 = new URLSearchParams(window.location.search);
            const searchQuery = urlParams2.get('searchQuery');
            const highlightId = urlParams2.get('highlightId');
            
            if (searchQuery) {
                document.getElementById('eventSearch').value = searchQuery;
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
            const tableBody = document.querySelector('#eventsTable tbody');
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
            const tableBody = document.querySelector('#eventsTable tbody');
            const rows = tableBody.querySelectorAll('tr');
            
            rows.forEach(row => {
                removeHighlights(row);
                row.classList.remove('highlighted-row');
            });
        }
        
        function clearAllFilters() {
            window.location.href = 'view_events.jsp';
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

<%@ include file="Base.jsp" %>