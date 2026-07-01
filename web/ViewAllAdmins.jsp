<%-- 
    Document   : ViewAllAdmins
    Created on : 12 Jan 2026, 8:15:28 pm
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="mypackage.*" %>
<%@ page import="java.util.List" %>

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
    DAO dao = new DAO();
    List<Admin> admins = dao.getAllAdmins();
    request.setAttribute("admins", admins);
    
    // Get current logged in admin
    Admin currentAdmin = dao.getAdminByUsername(AdminUsername);
    request.setAttribute("currentAdmin", currentAdmin);
    
    // Get totals
    int totalAdmins = dao.getTotalAdmins(); // You'll need to add this method to DAO
    request.setAttribute("totalAdmins", totalAdmins);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Administrators</title>
    <style>
        :root {
            --primary: #4CAF50;
            --primary-hover: #45a049;
            --background: #121212;
            --surface: #1e1e1e;
            --on-background: #e1e1e1;
            --on-surface: #ffffff;
            --border: #333333;
            --highlight: rgba(255, 235, 59, 0.3);
            --card-bg: #252525;
            --shadow: rgba(0, 0, 0, 0.3);
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
            background-color: var(--background);
            color: var(--on-background);
            transition: all 0.3s ease;
        }
        
        .admins-container {
            max-width: 1200px;
            margin: 20px auto;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border);
        }
        
        .page-title {
            margin: 0;
            color: var(--on-surface);
            font-size: 2.2rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
        }
        
        .page-title i {
            margin-right: 15px;
            color: var(--primary);
        }
        
        .header-stats {
            display: flex;
            gap: 20px;
        }
        
        .stat-box {
            background: var(--surface);
            padding: 15px 25px;
            border-radius: 8px;
            border: 1px solid var(--border);
            text-align: center;
            min-width: 150px;
            box-shadow: 0 2px 10px var(--shadow);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #aaa;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .controls-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding: 20px;
            background: var(--surface);
            border-radius: 8px;
            border: 1px solid var(--border);
        }
        
        .search-box {
            position: relative;
            flex: 1;
            max-width: 400px;
        }
        
        .search-input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border);
            border-radius: 6px;
            color: var(--on-surface);
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
        }
        
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }
        
        .add-admin-btn {
            padding: 12px 25px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .add-admin-btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }
        
        .add-admin-btn i {
            margin-right: 8px;
        }
        
        .admins-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .admin-card {
            background: var(--card-bg);
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px var(--shadow);
        }
        
        .admin-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.4);
            border-color: var(--primary);
        }
        
        .card-header {
            display: flex;
            align-items: center;
            padding: 25px;
            background: rgba(76, 175, 80, 0.05);
            border-bottom: 1px solid var(--border);
        }
        
        .card-photo {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 20px;
            border: 2px solid var(--primary);
        }
        
        .card-info {
            flex: 1;
        }
        
        .card-name {
            margin: 0;
            color: var(--on-surface);
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .card-username {
            color: #aaa;
            font-size: 0.9rem;
            margin: 0;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .card-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
        }
        
        .detail-label {
            font-size: 0.8rem;
            color: #aaa;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .detail-value {
            color: var(--on-surface);
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .admin-id {
            color: var(--primary);
            font-weight: 700;
        }
        
        .card-actions {
            display: flex;
            gap: 10px;
            padding: 15px 20px;
            background: rgba(255, 255, 255, 0.02);
            border-top: 1px solid var(--border);
        }
        
        .card-btn {
            flex: 1;
            padding: 10px;
            border-radius: 6px;
            text-decoration: none;
            text-align: center;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .view-btn {
            background: rgba(33, 150, 243, 0.1);
            color: #2196F3;
            border: 1px solid rgba(33, 150, 243, 0.3);
        }
        
        .view-btn:hover {
            background: rgba(33, 150, 243, 0.2);
            color: #0b7dda;
            border-color: #2196F3;
        }
        
        .edit-btn {
            background: rgba(76, 175, 80, 0.1);
            color: var(--primary);
            border: 1px solid rgba(76, 175, 80, 0.3);
        }
        
        .edit-btn:hover {
            background: rgba(76, 175, 80, 0.2);
            color: var(--primary-hover);
            border-color: var(--primary);
        }
        
        .delete-btn {
            background: rgba(244, 67, 54, 0.1);
            color: #f44336;
            border: 1px solid rgba(244, 67, 54, 0.3);
        }
        
        .delete-btn:hover {
            background: rgba(244, 67, 54, 0.2);
            color: #da190b;
            border-color: #f44336;
        }
        
        .current-user-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--primary);
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .card-relative {
            position: relative;
        }
        
        .no-admins {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .no-admins i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #444;
        }
        
        .no-admins h3 {
            margin: 0 0 15px 0;
            color: #888;
            font-size: 1.5rem;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }
        
        .page-btn {
            padding: 10px 15px;
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--on-surface);
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .page-btn:hover {
            background: rgba(76, 175, 80, 0.1);
            border-color: var(--primary);
        }
        
        .page-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        
        .page-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            margin-bottom: 25px;
            padding: 10px 20px;
            background: #666;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px var(--shadow);
        }
        
        .back-link:hover {
            background: #555;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px var(--shadow);
        }
        
        .back-link i {
            margin-right: 8px;
        }
        
        @media (max-width: 768px) {
            .admins-grid {
                grid-template-columns: 1fr;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }
            
            .header-stats {
                width: 100%;
                justify-content: space-between;
            }
            
            .stat-box {
                flex: 1;
                min-width: auto;
            }
            
            .controls-bar {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            
            .search-box {
                max-width: 100%;
            }
            
            .add-admin-btn {
                width: 100%;
                justify-content: center;
            }
        }
        
        @media (max-width: 480px) {
            .card-header {
                flex-direction: column;
                text-align: center;
            }
            
            .card-photo {
                margin-right: 0;
                margin-bottom: 15px;
            }
            
            .card-details {
                grid-template-columns: 1fr;
            }
            
            .card-actions {
                flex-direction: column;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>
<body>
    <a href="Admin_penal.jsp" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
    
    <div class="admins-container">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-users-shield"></i> All Administrators
            </h1>
            <div class="header-stats">
                <div class="stat-box">
                    <div class="stat-number">${totalAdmins}</div>
                    <div class="stat-label">Total Admins</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number">${fn:length(admins)}</div>
                    <div class="stat-label">Showing</div>
                </div>
            </div>
        </div>
        
        <div class="controls-bar">
            <div class="search-box">
                <i class="fas fa-search search-icon"></i>
                <input type="text" 
                       class="search-input" 
                       placeholder="Search admins by name or username..."
                       id="searchInput"
                       onkeyup="filterAdmins()">
            </div>
            
            <button onclick="window.location.href='AddAdmin.jsp'" class="add-admin-btn">
                <i class="fas fa-user-plus"></i> Add New Admin
            </button>
        </div>
        
        <c:choose>
            <c:when test="${not empty admins}">
                <div class="admins-grid" id="adminsGrid">
                    <c:forEach var="admin" items="${admins}">
                        <div class="admin-card" data-name="${fn:toLowerCase(admin.adminName)}" 
                             data-username="${fn:toLowerCase(admin.adminUsername)}">
                            <div class="card-relative">
                                <c:if test="${admin.adminId == currentAdmin.adminId}">
                                    <div class="current-user-badge">
                                        <i class="fas fa-user-circle"></i> You
                                    </div>
                                </c:if>
                                <div class="card-header">
                                    <c:choose>
                                        <c:when test="${not empty admin.adminPhoto}">
                                            <img src="data:image/jpeg;base64,${admin.getImageBase64()}" 
                                                 class="card-photo" 
                                                 alt="${admin.adminName}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-photo" style="background: #2a2a2a; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-user-shield" style="font-size: 25px; color: #4CAF50;"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-info">
                                        <h3 class="card-name">${admin.adminName}</h3>
                                        <p class="card-username">@${admin.adminUsername}</p>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="card-details">
                                        <div class="detail-item">
                                            <span class="detail-label">Admin ID</span>
                                            <span class="detail-value admin-id">#${admin.adminId}</span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Account Type</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${admin.adminId == 1}">
                                                        <span style="color: #ff9800;">Main Admin</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--primary);">Administrator</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-actions">
                                    <a href="ViewAdmin.jsp?id=${admin.adminId}" class="card-btn view-btn">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <a href="EditAdminProfile.jsp?id=${admin.adminId}" class="card-btn edit-btn">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <c:if test="${admin.adminId != 1 && admin.adminId != currentAdmin.adminId}">
                                        <button onclick="confirmDelete(${admin.adminId}, '${admin.adminName}')" 
                                                class="card-btn delete-btn">
                                            <i class="fas fa-trash-alt"></i> Delete
                                        </button>
                                    </c:if>
                                    <c:if test="${admin.adminId == 1 || admin.adminId == currentAdmin.adminId}">
                                        <button class="card-btn delete-btn" style="opacity: 0.5; cursor: not-allowed;" 
                                                title="<c:choose>
                                                        <c:when test='${admin.adminId == 1}'>Cannot delete main administrator</c:when>
                                                        <c:otherwise>Cannot delete your own account</c:otherwise>
                                                       </c:choose>">
                                            <i class="fas fa-ban"></i> Delete
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
            </c:when>
            <c:otherwise>
                <div class="no-admins">
                    <i class="fas fa-users-slash"></i>
                    <h3>No Administrators Found</h3>
                    <p>There are no administrator accounts in the system yet.</p>
                    <button onclick="window.location.href='AddAdmin.jsp'" class="add-admin-btn" style="margin-top: 20px;">
                        <i class="fas fa-user-plus"></i> Create First Admin
                    </button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Filter function
        function filterAdmins() {
            const searchInput = document.getElementById('searchInput');
            const searchTerm = searchInput.value.toLowerCase();
            const adminCards = document.querySelectorAll('.admin-card');
            let visibleCount = 0;

            adminCards.forEach(card => {
                const name = card.getAttribute('data-name');
                const username = card.getAttribute('data-username');

                if (name.includes(searchTerm) || username.includes(searchTerm)) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Update showing count
            const showingElement = document.querySelector('.header-stats .stat-box:last-child .stat-number');
            if (showingElement) {
                showingElement.textContent = visibleCount;
            }
        }

        // Delete confirmation function
        function confirmDelete(adminId, adminName) {
            Swal.fire({
                title: 'Delete Administrator',
                html: `
                    <div style="text-align: left;">
                        <p style="color: #e2e8f0; margin-bottom: 15px;">
                            Delete administrator <strong style="color: #ff6b6b;">`+adminName+`</strong>?
                        </p>
                        <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; padding: 12px; border-radius: 4px; margin-bottom: 20px;">
                            <p style="margin: 0; color: #fca5a5; font-size: 0.9rem;">
                                <i class="fas fa-exclamation-triangle"></i> This action is permanent and cannot be undone.
                            </p>
                        </div>
                        <div>
                            <label style="display: block; color: #cbd5e1; margin-bottom: 8px;">
                                <i class="fas fa-key"></i> Confirm your password:
                            </label>
                            <input type="password" 
                                   id="deletePassword" 
                                   style="width: 100%; padding: 10px; background: #2d3748; border: 1px solid #4a5568; border-radius: 6px; color: white;"
                                   placeholder="Enter your password...">
                        </div>
                    </div>
                `,
                background: '#1a1a1a',
                color: '#fff',
                backdrop: 'rgba(0,0,0,0.8)',
                showCancelButton: true,
                confirmButtonText: 'Delete',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#ef4444',
                cancelButtonColor: '#6b7280',
                reverseButtons: true,
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    const password = document.getElementById('deletePassword').value;
                    if (!password) {
                        Swal.showValidationMessage('Password is required');
                        return false;
                    }
                    return password;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    submitDeleteForm(adminId, result.value);
                }
            });
        }

        // Submit delete form
        function submitDeleteForm(adminId, password) {
            // Create and submit form
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'DeleteAdminServlet';
            form.style.display = 'none';

            const adminIdInput = document.createElement('input');
            adminIdInput.type = 'hidden';
            adminIdInput.name = 'adminId';
            adminIdInput.value = adminId;

            const passwordInput = document.createElement('input');
            passwordInput.type = 'hidden';
            passwordInput.name = 'confirmPassword';
            passwordInput.value = password;

            const fileName = document.createElement('input');
            fileName.type = 'hidden';
            fileName.name = 'fileName';
            fileName.value = 'ViewAllAdmins.jsp';

            form.appendChild(adminIdInput);
            form.appendChild(passwordInput);
            form.appendChild(fileName);
            document.body.appendChild(form);
            form.submit();
        }

        // Initialize on DOM load
        document.addEventListener('DOMContentLoaded', function() {
            // Show delete success message
            const deleteSuccess = '<%= session.getAttribute("DeleteSuccess") %>';
            if (deleteSuccess && deleteSuccess !== 'null') {
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: deleteSuccess,
                    background: '#1a1a1a',
                    color: '#ffffff',
                    confirmButtonColor: '#4CAF50',
                    timer: 4995,
                    timerProgressBar: true,
                    showConfirmButton: false,
                    willClose: () => {
                        // Clear session attribute
                        <% session.removeAttribute("DeleteSuccess"); %>
                    }
                });
            }

            // Show delete failure message
            const deleteFailed = '<%= session.getAttribute("DeleteFailed") %>';
            if (deleteFailed && deleteFailed !== 'null') {
                Swal.fire({
                    icon: 'error',
                    title: 'Failed',
                    text: deleteFailed,
                    background: '#1a1a1a',
                    color: '#ffffff',
                    confirmButtonColor: '#ef4444',
                    timer: 4995,
                    timerProgressBar: true,
                    willClose: () => {
                        // Clear session attribute
                        <% session.removeAttribute("DeleteFailed"); %>
                    }
                });
            }

            // Search functionality
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.addEventListener('keydown', function(e) {
                    if (e.key === 'Escape') {
                        this.value = '';
                        filterAdmins();
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

</html>