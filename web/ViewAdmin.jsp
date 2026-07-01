<%-- 
    Document   : ViewAdmin
    Created on : [Current Date]
    Author     : [Your Name]
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="mypackage.*" %>

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
    int AdminID = Integer.parseInt(request.getParameter("id"));
    DAO dao = new DAO();
    Admin admin = dao.getAdminById(AdminID);
    request.setAttribute("admin", admin);
    
    // Get current logged in admin
    Admin currentAdmin = dao.getAdminByUsername(AdminUsername);
    request.setAttribute("currentAdmin", currentAdmin);    
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Details</title>
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
        
        .admin-container {
            max-width: 900px;
            margin: 20px auto;
            background: var(--surface);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        
        .admin-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 20px;
        }
        
        .admin-photo {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 30px;
            border: 4px solid var(--primary);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        
        .admin-photo:hover {
            transform: scale(1.05);
        }
        
        .admin-info {
            flex: 1;
        }
        
        .admin-name {
            margin: 0;
            color: var(--on-surface);
            font-size: 2rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .admin-username {
            color: #aaa;
            margin-top: 8px;
            font-size: 1.2rem;
        }
        
        .info-section {
            margin-bottom: 25px;
            background: rgba(255, 255, 255, 0.03);
            padding: 20px;
            border-radius: 8px;
            border: 1px solid var(--border);
        }
        
        .info-section h3 {
            border-bottom: 1px solid var(--border);
            padding-bottom: 10px;
            color: var(--primary);
            margin-top: 0;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
        }
        
        .info-section h3 i {
            margin-right: 10px;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 12px;
            padding: 8px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.05);
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 500;
            width: 180px;
            color: #aaa;
            display: flex;
            align-items: center;
        }
        
        .info-label i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .info-value {
            flex: 1;
            color: var(--on-surface);
            font-weight: 400;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            margin-bottom: 25px;
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .back-link:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        
        .back-link i {
            margin-right: 8px;
        }
        
        .highlight {
            background-color: var(--highlight);
            padding: 0 4px;
            border-radius: 4px;
            box-shadow: 0 0 4px rgba(255,235,59,0.5);
            font-weight: 600;
        }
        
        .admin-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }
        
        .action-btn {
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
        }
        
        .edit-btn {
            background: #2196F3;
            color: white;
        }
        
        .edit-btn:hover {
            background: #0b7dda;
            transform: translateY(-2px);
        }
        
        .delete-btn {
            background: #f44336;
            color: white;
        }
        
        .delete-btn:hover {
            background: #da190b;
            transform: translateY(-2px);
        }
        
        .action-btn i {
            margin-right: 8px;
        }
        
        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                text-align: center;
            }
            
            .admin-photo {
                margin-right: 0;
                margin-bottom: 20px;
            }
            
            .info-row {
                flex-direction: column;
            }
            
            .info-label {
                width: 100%;
                margin-bottom: 5px;
            }
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <%-- At the top of ViewAdmin.jsp body --%>
<!-- Alert code -->
<c:if test="${not empty successMessage}">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: '${successMessage}',
                background: '#1a1a1a',
                color: '#ffffff',
                confirmButtonColor: '#3b82f6',
                confirmButtonText: 'OK',
                backdrop: 'rgba(0,0,0,0.7)',
                iconColor: '#10b981',
                buttonsStyling: false,
                customClass: {
                    confirmButton: 'dark-swal-button',
                    popup: 'dark-swal-popup'
                }
            });
        });
    </script>
    <style>
        .dark-swal-button {
            background: linear-gradient(135deg, #3b82f6, #2563eb) !important;
            border-radius: 8px !important;
            padding: 10px 24px !important;
            font-weight: 600 !important;
        }
        .dark-swal-popup {
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
        }
    </style>
       <c:remove var="successMessage" scope="session"/>
</c:if>
    <div class="admin-container">
        <c:choose>
            <c:when test="${not empty param.searchQuery}">
                <a href="UniversalSearchServlet?searchQuery=${fn:escapeXml(param.searchQuery)}" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to search results
                </a>
            </c:when>
            <c:otherwise>
                <a href="Admin_penal.jsp" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>                
            </c:otherwise>
        </c:choose>
                
        <div class="admin-header">
            <c:choose>
                <c:when test="${not empty admin.adminPhoto}">
                    <img src="data:image/jpeg;base64,${admin.getImageBase64()}" 
                         class="admin-photo" 
                         alt="${admin.adminName}">
                </c:when>
                <c:otherwise>
                    <div class="admin-photo" style="background: #2a2a2a; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-user-shield" style="font-size: 50px; color: #4CAF50;"></i>
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="admin-info">
                <h1 class="admin-name">
                    <c:if test="${not empty param.searchQuery}">
                        <c:out value="${fn:replace(admin.adminName, param.searchQuery, 
                                  '<span class=\"highlight\">$0</span>')}" escapeXml="false"/>
                    </c:if>
                    <c:if test="${empty param.searchQuery}">
                        ${admin.adminName}
                    </c:if>
                </h1>
                <div class="admin-username">@${admin.adminUsername}</div>
            </div>
        </div>

        <div class="info-section">
            <h3><i class="fas fa-id-card"></i> Administrator Information</h3>
            <div class="info-row">
                <div class="info-label"><i class="fas fa-fingerprint"></i> Admin ID:</div>
                <div class="info-value">${admin.adminId}</div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="fas fa-user"></i> Username:</div>
                <div class="info-value">@${admin.adminUsername}</div>
            </div>
            <div class="info-row">
                <div class="info-label"><i class="fas fa-user-tag"></i> Account Type:</div>
                <div class="info-value"><span style="color: var(--primary);">Administrator</span></div>
            </div>
        </div>
        
        <div class="admin-actions">
            <a href="EditAdminProfile.jsp?id=${admin.adminId}" class="action-btn edit-btn">
                <i class="fas fa-edit"></i> Edit Profile
            </a>
                <c:if test="${admin.adminId != 1 && admin.adminId != currentAdmin.adminId}">
                    <a href="#" class="action-btn delete-btn" onclick="confirmDelete(${admin.adminId}, '${admin.adminName}')">
                        <i class="fas fa-trash-alt"></i> Delete Account
                    </a>
                </c:if>
                <c:if test="${admin.adminId == 1 || admin.adminId == currentAdmin.adminId}">
                    <a href="#" class="action-btn delete-btn" style="opacity: 0.5; cursor: not-allowed"
                       title="
                            <c:choose>
                                <c:when test='${admin.adminId == 1}'>Cannot delete main administrator</c:when>
                                <c:otherwise>Cannot delete your own account</c:otherwise>
                            </c:choose>">
                        <i class="fas fa-trash-alt"></i> Delete Account
                    </a>
                </c:if>
            
        </div>
    </div>
</body>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
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
        fileName.value = 'ViewAdmin.jsp?id='+adminId;
        
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

















