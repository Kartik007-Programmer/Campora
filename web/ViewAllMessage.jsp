<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="mypackage.Message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
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
    // Handle search parameter - MUST be BEFORE pagination 
    String searchParam = request.getParameter("search");
    
    // Handle filter parameters
    String statusFilter = request.getParameter("status");
    
    // Handle One Message - Initialize with 0
    int messageIdParam = 0;
    try {
        String messageIdStr = request.getParameter("messageId");
        if (messageIdStr != null && !messageIdStr.trim().isEmpty()) {
            messageIdParam = Integer.parseInt(messageIdStr);
        }
    } catch (NumberFormatException e) {
        messageIdParam = 0;
    }
    
    List<Message> allMessages = null;
    List<Message> messages = null;

    Message singleMessage = null; // Add this variable to hold single message

    // Check if we're looking for a specific message ID
    if (messageIdParam > 0) {
        try {
            DAO dao = new DAO();
            singleMessage = dao.getMessageById(messageIdParam);
            if (singleMessage != null) {
                allMessages = new ArrayList<>();
                allMessages.add(singleMessage);
                // Set as viewed when directly accessed by ID
                if (!singleMessage.isIsViewed()) {
                    dao.markMessageAsViewed(messageIdParam);
                    singleMessage.setIsViewed(true);
                }
            } else {
                // Message not found, show error
                request.setAttribute("error", "Message with ID " + messageIdParam + " not found.");
                allMessages = new ArrayList<>(); // Empty list
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching message: " + e.getMessage());
            allMessages = new ArrayList<>();
        }
    } 
    // Check if messages are already in request attribute (e.g., from a servlet)
    else if (request.getAttribute("messages") == null) {
        try {
            DAO dao = new DAO();
            allMessages = dao.getAllMessages();
            messages = allMessages;
            
            // Apply search filter if search parameter exists (like view_courses.jsp)
            if (searchParam != null && !searchParam.trim().isEmpty()) {
                String searchTerm = searchParam.toLowerCase().trim();
                List<Message> filteredMessages = new ArrayList<>();
                
                for (Message message : allMessages) {
                    // Search in multiple fields with null checks
                    String fullName = message.getFullName() != null ? message.getFullName().toLowerCase() : "";
                    String email = message.getEmail() != null ? message.getEmail().toLowerCase() : "";
                    String subject = message.getSubject() != null ? message.getSubject().toLowerCase() : "";
                    String messageText = message.getMessage() != null ? message.getMessage().toLowerCase() : "";
                    
                    if (fullName.contains(searchTerm) ||
                        email.contains(searchTerm) ||
                        subject.contains(searchTerm) ||
                        messageText.contains(searchTerm)) {
                        filteredMessages.add(message);
                    }
                }
                allMessages = filteredMessages;
            }
            
            // Apply status filter
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                List<Message> filteredByStatus = new ArrayList<>();
                String filterStatus = statusFilter.trim();
                
                for (Message message : allMessages) {
                    if ("unread".equals(filterStatus) && !message.isIsViewed()) {
                        filteredByStatus.add(message);
                    } else if ("read".equals(filterStatus) && message.isIsViewed()) {
                        filteredByStatus.add(message);
                    }
                }
                allMessages = filteredByStatus;
            }
            
            request.setAttribute("messages", allMessages);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching messages: " + e.getMessage());
        }
    } else {
        allMessages = (List<Message>) request.getAttribute("messages");
        
        // Apply search filter to existing messages if search parameter exists
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            String searchTerm = searchParam.toLowerCase().trim();
            List<Message> filteredMessages = new ArrayList<>();
            
            for (Message message : allMessages) {
                // Search in multiple fields with null checks
                String fullName = message.getFullName() != null ? message.getFullName().toLowerCase() : "";
                String email = message.getEmail() != null ? message.getEmail().toLowerCase() : "";
                String subject = message.getSubject() != null ? message.getSubject().toLowerCase() : "";
                String messageText = message.getMessage() != null ? message.getMessage().toLowerCase() : "";
                
                if (fullName.contains(searchTerm) ||
                    email.contains(searchTerm) ||
                    subject.contains(searchTerm) ||
                    messageText.contains(searchTerm)) {
                    filteredMessages.add(message);
                }
            }
            allMessages = filteredMessages;
        }
        
        // Apply status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            List<Message> filteredByStatus = new ArrayList<>();
            String filterStatus = statusFilter.trim();
            
            for (Message message : allMessages) {
                if ("unread".equals(filterStatus) && !message.isIsViewed()) {
                    filteredByStatus.add(message);
                } else if ("read".equals(filterStatus) && message.isIsViewed()) {
                    filteredByStatus.add(message);
                }
            }
            allMessages = filteredByStatus;
        }
    }
    
    // Count unread messages from the filtered list
    int unreadCount = 0;
    if (allMessages != null) {
        for (Message msg : allMessages) {
            if (!msg.isIsViewed()) {
                unreadCount++;
            }
        }
    }
    request.setAttribute("unreadCount", unreadCount);
    
    // Pagination parameters (EXACTLY like view_courses.jsp)
    int pageSize = 4; // Number of entries per page
    int currentPage = 1;
    int totalPages = 0;
    List<Message> paginatedMessages = new ArrayList<>();
    
    if (allMessages != null && !allMessages.isEmpty()) {
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
        int totalItems = allMessages.size();
        totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
        // Ensure current page is within bounds
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        
        // Calculate start and end indices
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalItems);
        
        // Get paginated messages
        for (int i = startIndex; i < endIndex; i++) {
            paginatedMessages.add(allMessages.get(i));
        }
        
        // Set pagination attributes (EXACTLY like view_courses.jsp)
        request.setAttribute("paginatedMessages", paginatedMessages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("startItem", startIndex + 1);
        request.setAttribute("endItem", endIndex);
    }

%>

<!-- Set page title -->
<c:set var="pageTitle" value="View All Messages" scope="request" />

<!-- Set page CSS -->
<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mdi/font@6.5.95/css/materialdesignicons.min.css">
    <style>
        /* Filter form styles from view_courses.jsp */
        #messageSearch,
        #statusFilter {
            box-shadow: none;
            transition: 0.3s ease;
            background-color: #2a2a2a;
            color: #e0e0e0;
            border: 1px solid #444;
        }

        #messageSearch:focus,
        #statusFilter:focus {
            outline: none;
            box-shadow: 0 0 0 2px #a5b4fc;
            border-color: #81d4fa;
        }
        
        .form-label {
            color: #81d4fa;
        }
        
        .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        
        .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
            border-color: #6c757d;
        }

        /* Pagination styles from view_courses.jsp */
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

        /* Search highlight styling from view_courses.jsp */
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

        /* Rest of your existing styles */
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

        #messagesTable tbody tr {
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

        #messagesTable tbody tr:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.05) !important;
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

        #messagesTable th,
        #messagesTable td {
            vertical-align: middle;
        }

        /* Table body styling - transparent and no borders */
        #messagesTable tbody tr {
            background-color: transparent !important;
        }
        
        #messagesTable tbody td {
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
        #view3:checked ~ .card4,
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

        /* Message specific styles */
        .message-preview {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .message-full {
            white-space: pre-wrap;
            word-wrap: break-word;
            line-height: 1.6;
        }
        
        .email-link {
            color: #81d4fa;
            text-decoration: none;
        }
        
        .email-link:hover {
            color: #4fc3f7;
            text-decoration: underline;
        }
        
        /* Statistics cards */
        .stat-card {
            background: linear-gradient(135deg, #1e1e1e 0%, #2a2a2a 100%);
            border-radius: 10px;
            padding: 20px;
            border: 1px solid #333;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            border-color: #81d4fa;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            color: #81d4fa;
            margin-bottom: 15px;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #fff;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #b0b0b0;
            font-size: 0.9rem;
        }

        /* Modal styling */
        .modal-content {
            background-color: #191c24;
            color: #d6d6d6;
            border: 1px solid #333;
        }
        
        .modal-header {
            border-bottom: 1px solid #333;
        }
        
        .modal-footer {
            border-top: 1px solid #333;
        }
        
        .modal-title {
            color: #81d4fa;
        }

        /* Card styling */
        .card {
            background-color: #191c24;
            border: 1px solid #333;
            border-radius: 10px;
        }
        
        .card-body {
            color: #d6d6d6;
        }
        
        .card-title {
            color: #81d4fa;
        }

        /* Button styling */
        .btn-primary {
            background-color: #81d4fa;
            border-color: #81d4fa;
            color: #191c24;
        }
        
        .btn-primary:hover {
            background-color: #4fc3f7;
            border-color: #4fc3f7;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
        
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        
        /* Action buttons */
        .btn-view {
            background-color: transparent;
            border: 1px solid #81d4fa;
            color: #81d4fa;
        }
        
        .btn-view:hover {
            background-color: #81d4fa;
            color: #191c24;
        }
        
        .btn-reply {
            background-color: transparent;
            border: 1px solid #28a745;
            color: #28a745;
        }
        
        .btn-reply:hover {
            background-color: #28a745;
            color: white;
        }

        /* Filter card styling */
        .filter-card {
            background-color: transparent;
            border: none;
        }
        
        .filter-card .card-body {
            padding: 15px;
        }
        
        .form-label.small {
            font-size: 0.8rem;
            margin-bottom: 2px;
        }

        /* Unread message styling */
        .unread-message {
            background-color: rgba(129, 212, 250, 0.1) !important;
            border-left: 3px solid #81d4fa !important;
        }

        .unread-message:hover {
            background-color: rgba(129, 212, 250, 0.2) !important;
        }

        /* Badge styling */
        .badge {
            padding: 4px 8px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-success {
            background-color: #28a745;
            color: white;
        }

        .badge-secondary {
            background-color: #6c757d;
            color: white;
        }

        .badge-warning {
            background-color: #ffc107;
            color: #212529;
        }

        /* Status indicators */
        .status-indicator {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
        }

        .status-new {
            background-color: #28a745;
            animation: pulse-new 2s infinite;
        }

        .status-viewed {
            background-color: #6c757d;
        }

        @keyframes pulse-new {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        /* Toast notification */
        .toast-container {
            z-index: 1055;
        }
        
        .toast {
            background-color: #191c24;
            border: 1px solid #81d4fa;
        }
        
        .toast-body {
            color: #fff;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .message-preview {
                max-width: 150px;
            }
            
            .stat-card {
                margin-bottom: 15px;
            }
            
            .btn-group {
                flex-direction: column;
                gap: 5px;
            }
            
            .btn-group .btn {
                width: 100%;
            }
        }
    </style>
</c:set>

<!-- Set page content -->
<c:set var="pageContent" scope="request">
<div class="page-header">
    <h3 class="page-title"> All Messages </h3>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="Admin_penal.jsp">Dashboard</a></li>
            <li class="breadcrumb-item active" aria-current="page">View Messages</li>
        </ol>
    </nav>
</div>

<!-- Statistics Cards - Updated to use paginatedMessages for stats -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="mdi mdi-email-outline"></i>
            </div>
            <div class="stat-number">${totalItems != null ? totalItems : fn:length(allMessages)}</div>
            <div class="stat-label">Total Messages</div>
            <c:if test="${not empty param.search or not empty param.status}">
                <small class="text-muted">(Filtered)</small>
            </c:if>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="mdi mdi-email-alert"></i>
            </div>
            <div class="stat-number">${unreadCount}</div>
            <div class="stat-label">Unread Messages</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="mdi mdi-account-outline"></i>
            </div>
            <div class="stat-number">
                <c:set var="uniqueEmails" value="" />
                <c:set var="emailCount" value="0" />
                <c:forEach var="message" items="${messages}">
                    <c:if test="${not fn:contains(uniqueEmails, message.email)}">
                        <c:set var="uniqueEmails" value="${uniqueEmails},${message.email}" />
                        <c:set var="emailCount" value="${emailCount + 1}" />
                    </c:if>
                </c:forEach>
                ${emailCount}
            </div>
            <div class="stat-label">Unique Senders</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="mdi mdi-clock-outline"></i>
            </div>
            <c:if test="${not empty messages and fn:length(messages) > 0}">
                <c:set var="latestMessage" value="${messages[0]}" />
                <div class="stat-number">
                    <fmt:formatDate value="${latestMessage.createdAt}" pattern="dd MMMM" />
                </div>
            </c:if>
            <div class="stat-label">Latest Message</div>
        </div>
    </div>
</div>

<!-- Filters Card Section -->
<form method="get" action="ViewAllMessage.jsp" id="filterForm">
<div class="card mb-3 border-0" style="background-color: transparent;">
    <div class="card-body py-2 px-3">
        <div class="row align-items-end g-3">
            <div class="col-md-4">
                <label class="form-label mb-1 small" for="messageSearch">Search</label>
                <div class="input-group">
                    <input type="text" class="form-control form-control-sm" 
                           placeholder="Search in messages..." 
                           id="messageSearch"
                           name="search"
                           value="${param.search}">
                    <c:if test="${not empty param.search or not empty param.status}">
                        <button class="btn btn-sm btn-outline-secondary" type="button" 
                                onclick="clearAllFilters()" 
                                title="Clear all filters">
                            <i class="mdi mdi-close"></i>
                        </button>
                    </c:if>
                </div>
            </div>

            <div class="col-md-3">
                <label class="form-label mb-1 small" for="statusFilter">Status</label>
                <select class="form-control form-control-sm" id="statusFilter" name="status">
                    <option value="">All Messages</option>
                    <option value="unread" ${param.status == 'unread' ? 'selected' : ''}>Unread Only</option>
                    <option value="read" ${param.status == 'read' ? 'selected' : ''}>Read Only</option>
                </select>
            </div>

            <div class="col-md-3 d-flex justify-content-end align-items-end" style="gap: 10px;">
                <div>
                    <label class="form-label mb-1 small text-white d-block">Refresh</label>
                    <button type="button" class="btn btn-sm d-flex align-items-center justify-content-center" 
                            id="refreshBtn"
                            style="background-color: #4f46e5; color: white; height: 32px; font-size: 13px; padding: 0 12px;"
                            onclick="refreshMessages()">
                        <i class="mdi mdi-refresh me-1" style="font-size: 14px;"></i> Refresh
                    </button>
                </div>
                <div>
                    <c:if test="${not empty param.search or not empty param.status}">
                    <label class="form-label mb-1 small text-white d-block">Clear</label>
                        <button type="button" class="btn btn-sm d-flex align-items-center justify-content-center" 
                                onclick="clearAllFilters()" 
                                style="background-color: #dfb016; color: white; height: 32px; font-size: 13px; padding: 0 12px;">
                            <i class="mdi mdi-filter-remove me-1" style="font-size: 14px;"></i> Clear
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</form>

<!-- Alerts -->
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>

<!-- Hidden radio buttons for detail view -->
<input type="radio" id="back" name="message-toggle" hidden checked>
<c:forEach var="message" items="${paginatedMessages}" varStatus="status">
    <input type="radio" id="view${status.index + 1}" name="message-toggle" hidden>
</c:forEach>

<!-- Messages Table - Updated to use paginatedMessages -->
<div class="table-responsive draggable-table-container table-view">
    <table class="table table-striped mb-0" id="messagesTable">
        <thead class="thead-dark">
            <tr>
                <th>#</th>
                <th>Status</th>
                <th class="sortable">Sender Name</th>
                <th class="sortable">Email</th>
                <th class="sortable">Subject</th>
                <th>Received</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty paginatedMessages}">
                    <tr>
                        <td colspan="7" style="text-align:center; color: #f44336; font-weight: bold;">
                            <c:choose>
                                <c:when test="${not empty param.search or not empty param.status}">
                                    No messages found matching your filters
                                </c:when>
                                <c:otherwise>
                                    No messages available
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="message" items="${paginatedMessages}" varStatus="status">
                        <tr class="clickable-row ${message.isViewed ? '' : 'unread-message'}" 
                            data-toggle="modal" 
                            data-target="#messageModal${status.index}"
                            data-message-id="${message.id}"
                            data-is-viewed="${message.isViewed}">
                            <td>${(currentPage - 1) * 5 + status.index + 1}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${message.isViewed}">
                                        <span class="badge badge-secondary">
                                            <span class="status-indicator status-viewed"></span>
                                            Viewed
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-success">
                                            <span class="status-indicator status-new"></span>
                                            New
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="highlight-target">
                                <c:choose>
                                    <c:when test="${message.isViewed}">
                                        ${message.fullName}
                                    </c:when>
                                    <c:otherwise>
                                        <strong>${message.fullName}</strong>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="highlight-target">
                                <a href="mailto:${message.email}" class="email-link">
                                    <c:choose>
                                        <c:when test="${message.isViewed}">
                                            ${message.email}
                                        </c:when>
                                        <c:otherwise>
                                            <strong>${message.email}</strong>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </td>
                            <td class="highlight-target">
                                <c:choose>
                                    <c:when test="${fn:length(message.subject) > 30}">
                                        <c:choose>
                                            <c:when test="${message.isViewed}">
                                                ${fn:substring(message.subject, 0, 30)}...
                                            </c:when>
                                            <c:otherwise>
                                                <strong>${fn:substring(message.subject, 0, 30)}...</strong>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${message.isViewed}">
                                                ${message.subject}
                                            </c:when>
                                            <c:otherwise>
                                                <strong>${message.subject}</strong>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <small>
                                    <c:if test="${not empty message.createdAt}">
                                        <fmt:formatDate value="${message.createdAt}" pattern="dd MMM yyyy HH:mm" />
                                    </c:if>
                                    <c:if test="${message.isViewed and not empty message.viewedAt}">
                                        <br><span class="text-muted">Viewed: 
                                            <fmt:formatDate value="${message.viewedAt}" pattern="dd MMM HH:mm" />
                                        </span>
                                    </c:if>
                                </small>
                            </td>
                            <td>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-view" 
                                            data-toggle="modal" data-target="#messageModal${status.index}"
                                            onclick="markAsViewed(${message.id}, ${status.index})">
                                        <i class="mdi mdi-eye"></i> 
                                        <c:choose>
                                            <c:when test="${message.isViewed}">View</c:when>
                                            <c:otherwise>Mark as Read</c:otherwise>
                                        </c:choose>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-reply" 
                                            onclick="replyToMessage('${message.email}', '${message.subject}')">
                                        <i class="mdi mdi-reply"></i> Reply
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<!-- Message Detail Modals - Updated to use paginatedMessages -->
<c:forEach var="message" items="${paginatedMessages}" varStatus="status">
    <div class="modal fade" id="messageModal${status.index}" tabindex="-1" role="dialog" 
         aria-labelledby="messageModalLabel${status.index}" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="messageModalLabel${status.index}">
                        Message Details
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p><strong>Status:</strong> 
                                <c:choose>
                                    <c:when test="${message.isViewed}">
                                        <span class="badge badge-secondary">Viewed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-success">Unread</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Received:</strong> 
                                <fmt:formatDate value="${message.createdAt}" pattern="dd MMMM yyyy 'at' HH:mm:ss" />
                            </p>
                            <c:if test="${message.isViewed and not empty message.viewedAt}">
                                <%
                                    // Calculate delete date (viewedAt + 1 day)
                                    if (pageContext.getAttribute("message") != null) {
                                        Message msg = (Message) pageContext.getAttribute("message");
                                        if (msg.isIsViewed() && msg.getViewedAt() != null) {
                                            java.util.Date deleteDate = new java.util.Date(msg.getViewedAt().getTime() + 86400000L);
                                            pageContext.setAttribute("deleteDate", deleteDate);
                                        }
                                    }
                                %>
                                <p><strong>Viewed:</strong> 
                                    <fmt:formatDate value="${message.viewedAt}" pattern="dd MMMM yyyy 'at' HH:mm:ss" />
                                </p>
                                <p><strong>Will be deleted:</strong> 
                                    <fmt:formatDate value="${deleteDate}" pattern="dd MMMM yyyy 'at' HH:mm:ss" />
                                </p>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <p><strong>From:</strong> ${message.fullName}</p>
                            <p><strong>Email:</strong> 
                                <a href="mailto:${message.email}" class="email-link">${message.email}</a>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <p><strong>Subject:</strong> ${message.subject}</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <p><strong>Message:</strong></p>
                            <div class="card">
                                <div class="card-body">
                                    <p class="card-text message-full">${message.message}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="location.replace("ViewAllMessage.jsp");>Close</button>
                    <button type="button" class="btn btn-primary" 
                            onclick="replyToMessage('${message.email}', '${message.subject}')">
                        <i class="mdi mdi-reply"></i> Reply via Email
                    </button>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<!-- Table Footer Row with Entry Info & Pagination (EXACTLY like view_courses.jsp) -->
<c:if test="${not empty paginatedMessages and totalPages > 0}">
    <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
        <!-- Entry Count Info (Left) -->
        <div class="table-info text-muted small">
            Showing <strong>${startItem}</strong> to <strong>${endItem}</strong> of <strong>${totalItems}</strong> entries
            <c:if test="${not empty param.search or not empty param.status}">
                (Filtered Results)
            </c:if>
        </div>

        <!-- Pagination (Right) - EXACTLY like view_courses.jsp -->
        <nav>
            <ul class="pagination mb-0">
                <!-- Previous Button -->
                <c:choose>
                    <c:when test="${currentPage == 1}">
                        <li class="page-item disabled"><span class="page-link">Previous</span></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.status}">&status=${param.status}</c:if>">Previous</a>
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
                                <a class="page-link" href="?page=${pageNum}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.status}">&status=${param.status}</c:if>">${pageNum}</a>
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
                            <a class="page-link" href="?page=${currentPage + 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.status}">&status=${param.status}</c:if>">Next</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
</c:if>

<!-- Toast container for notifications -->
<div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3"></div>
</c:set>

<!-- Additional Scripts - Updated with search highlight functionality from view_courses.jsp -->
<c:set var="additionalScripts" scope="request">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Apply search highlights on page load (from view_courses.jsp)
            const urlParams = new URLSearchParams(window.location.search);
            const searchParam = urlParams.get('search');
            
            if (searchParam) {
                // Apply highlights after a short delay to ensure DOM is ready
                setTimeout(() => {
                    applySearchHighlights(searchParam);
                }, 100);
            }
            
            // Search functionality - Auto-submit on Enter key (from view_courses.jsp)
            document.getElementById('messageSearch').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    // Remove page parameter when searching (go to page 1)
                    const url = new URL(window.location.href);
                    url.searchParams.delete('page');
                    document.getElementById('filterForm').action = url.toString();
                    document.getElementById('filterForm').submit();
                }
            });

            // Add debouncing for search input (from view_courses.jsp)
            document.getElementById('messageSearch').addEventListener('input', function() {
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

            // Status filter - Auto-submit on change (from view_courses.jsp)
            document.getElementById('statusFilter').addEventListener('change', function() {
                // Remove page parameter when filtering (go to page 1)
                const url = new URL(window.location.href);
                url.searchParams.delete('page');
                document.getElementById('filterForm').action = url.toString();
                document.getElementById('filterForm').submit();
            });

            // Mark message as viewed when modal is shown
            $('.modal').on('show.bs.modal', function (event) {
                const button = $(event.relatedTarget);
                const messageId = button.closest('tr').data('message-id');
                const isViewed = button.closest('tr').data('is-viewed');
                
                // Only mark as viewed if it's not already viewed
                if (messageId && !isViewed) {
                    markAsViewed(messageId);
                }
            });
            
            // This is for Universal Search
            const urlParams2 = new URLSearchParams(window.location.search);
            const searchQuery = urlParams2.get('searchQuery');
            const highlightId = urlParams2.get('highlightId');
            const OneMessageId = urlParams2.get('messageId');
            
            if (searchQuery) {
                document.getElementById('messageSearch').value = searchQuery;
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
            
            if (OneMessageId && OneMessageId !== 'null') {
               // Open the modal
                setTimeout(() => {
                    const modalIndex = findModalIndexByMessageId(OneMessageId);
                    if (modalIndex !== -1) {
                        openMessageModalByIndex(modalIndex);
                    } else {
                        // If modal index not found, check if it's a single message view
                        const rows = document.querySelectorAll('#messagesTable tbody tr');
                        if (rows.length === 1) {
                            // If there's only one row, it might be our single message
                            openMessageModalByIndex(0);
                        }
                    }
                }, 500); // Increased delay to ensure DOM is fully loaded
            }
        });
        
        // Function to open modal by message ID
        function openMessageModalByIndex(modalIndex) {
    if (modalIndex >= 0) {
        // Find the modal element
        const modalId = '#messageModal' + modalIndex;
        const modalElement = $(modalId);
        
        if (modalElement.length) {
            // Show the modal
            modalElement.modal('show');
            
            // Mark as viewed if not already
            const messageId = modalElement.data('message-id') || 
                             modalElement.find('.modal-content').data('message-id');
            if (messageId) {
                // Find the corresponding row to check if already viewed
                const row = document.querySelector(`tr[data-message-id="${messageId}"]`);
                if (row && row.getAttribute('data-is-viewed') === 'false') {
                    markAsViewed(messageId);
                }
            }
        } else {
            console.error('Modal not found for index:', modalIndex);
        }
    }
}

        function findModalIndexByMessageId(messageId) {
    // Find the row with this message ID in paginatedMessages
    const rows = document.querySelectorAll('#messagesTable tbody tr[data-message-id]');
    
    for (let i = 0; i < rows.length; i++) {
        const rowMessageId = rows[i].getAttribute('data-message-id');
        if (parseInt(rowMessageId) === parseInt(messageId)) {
            return i; // Return the index (0-based)
        }
    }
    
    // If not found, check if there's only one message (single message view)
    if (rows.length === 1) {
        const rowMessageId = rows[0].getAttribute('data-message-id');
        if (parseInt(rowMessageId) === parseInt(messageId)) {
            return 0;
        }
    }
    
    return -1; // Not found
}     
       
        
        // Utility functions for highlighting (from view_courses.jsp)
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
            const tableBody = document.querySelector('#messagesTable tbody');
            if (!tableBody) return;
            
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
            const tableBody = document.querySelector('#messagesTable tbody');
            const rows = tableBody.querySelectorAll('tr');
            
            rows.forEach(row => {
                removeHighlights(row);
                row.classList.remove('highlighted-row');
            });
        }
        
        function clearAllFilters() {
            window.location.href = 'ViewAllMessage.jsp';
        }

        // Function to mark message as viewed
        function markAsViewed(messageId) {
            // Show loading state
            const row = document.querySelector(`tr[data-message-id="${messageId}"]`);
            if (row) {
                const button = row.querySelector('.btn-view');
                if (button) {
                    const originalHtml = button.innerHTML;
                    button.innerHTML = '<i class="mdi mdi-loading mdi-spin"></i> Loading...';
                    button.disabled = true;
                }
            }
            
            // Call the MessageServlet to mark as viewed
            fetch('MessageServlet?messageId=' + messageId, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(result => {
                if (result === 'SUCCESS' || result.includes('success')) {
                    showToast('Message marked as read', 'success');
                    updateMessageUI(messageId);
                } else {
                    showToast('Failed to mark message as read', 'danger');
                    // Restore button
                    if (row) {
                        const button = row.querySelector('.btn-view');
                        if (button) {
                            button.innerHTML = '<i class="mdi mdi-eye"></i> Mark as Read';
                            button.disabled = false;
                        }
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Network error occurred', 'danger');
                // Restore button on error
                if (row) {
                    const button = row.querySelector('.btn-view');
                    if (button) {
                        button.innerHTML = '<i class="mdi mdi-eye"></i> Mark as Read';
                        button.disabled = false;
                    }
                }
            });
        }

        // Update UI after marking message as viewed
        function updateMessageUI(messageId) {
            const row = document.querySelector(`tr[data-message-id="${messageId}"]`);
            if (!row) return;
            
            // Remove unread styling
            row.classList.remove('unread-message');
            
            // Update status badge
            const statusBadge = row.querySelector('.badge');
            if (statusBadge) {
                statusBadge.className = 'badge badge-secondary';
                statusBadge.innerHTML = '<span class="status-indicator status-viewed"></span> Viewed';
            }
            
            // Update button text
            const viewButton = row.querySelector('.btn-view');
            if (viewButton) {
                viewButton.innerHTML = '<i class="mdi mdi-eye"></i> View';
                viewButton.disabled = false;
            }
            
            // Remove bold styling from text
            const cells = row.querySelectorAll('td:nth-child(3), td:nth-child(4), td:nth-child(5)');
            cells.forEach(cell => {
                const strongTag = cell.querySelector('strong');
                if (strongTag) {
                    // Replace strong tag with just the text
                    const textNode = document.createTextNode(strongTag.textContent);
                    cell.replaceChild(textNode, strongTag);
                }
            });
            
            // Specifically update email link
            const emailLink = row.querySelector('a.email-link');
            if (emailLink) {
                const strongTag = emailLink.querySelector('strong');
                if (strongTag) {
                    emailLink.innerHTML = strongTag.textContent;
                }
            }
            
            // Update data attribute
            row.setAttribute('data-is-viewed', 'true');
            
            // Update unread count in statistics
            updateUnreadCount(-1);
        }

        // Show toast notification
        function showToast(message, type) {
            // Set default type to 'success' if not provided
            if (!type) type = 'success';

            const toastContainer = document.getElementById('toastContainer');

            // Create toast element
            const toast = document.createElement('div');

            // Fix: Use JavaScript comparison instead of template literal with JS syntax
            const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
            const iconClass = type === 'success' ? 'check-circle' : 'alert-circle';

            toast.className = 'toast align-items-center text-white ' + bgClass + ' border-0';
            toast.setAttribute('role', 'alert');
            toast.setAttribute('aria-live', 'assertive');
            toast.setAttribute('aria-atomic', 'true');

            toast.innerHTML = '<div class="d-flex">' +
                '<div class="toast-body">' +
                '<i class="mdi mdi-' + iconClass + ' me-2"></i>' +
                message +
                '</div>' +
                '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>';

            toastContainer.appendChild(toast);

            // Initialize and show the toast
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();

            // Remove toast after it's hidden
            toast.addEventListener('hidden.bs.toast', function () {
                toast.remove();
            });
        }

        // Update unread count (for UI only)
        function updateUnreadCount(change) {
            const unreadStat = document.querySelector('.stat-card:nth-child(2) .stat-number');
            if (unreadStat) {
                let currentCount = parseInt(unreadStat.textContent) || 0;
                currentCount += change;
                if (currentCount < 0) currentCount = 0;
                unreadStat.textContent = currentCount;
            }
        }

        function replyToMessage(email, subject) {
            let mailtoLink = 'mailto:' + encodeURIComponent(email);
            
            // Add RE: prefix to subject if not already present
            if (subject && !subject.toUpperCase().startsWith('RE:')) {
                mailtoLink += '?subject=' + encodeURIComponent('RE: ' + subject);
            } else if (subject) {
                mailtoLink += '?subject=' + encodeURIComponent(subject);
            }
            
            window.open(mailtoLink, '_blank');
        }
        
        function refreshMessages() {
            window.location.reload();
        }
    </script>
    <script>
    // Update notification badge in parent window if we're in an iframe or same window
    if (window.opener) {
        // If opened in new window
        window.opener.updateNotificationBadge();
    } else if (window.parent && window.parent !== window) {
        // If in iframe
        window.parent.updateNotificationBadge();
    } else {
        // Same window - just update directly
        const badge = document.querySelector('.count');
        if (badge) {
            const currentCount = parseInt(badge.textContent);
            if (currentCount > 1) {
                badge.textContent = currentCount - 1;
            } else {
                badge.remove();
            }
        }
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