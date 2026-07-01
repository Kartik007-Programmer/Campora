<%-- 
    Document   : EditAdminProfile
    Created on : 12 Jan 2026, 6:21:09 pm
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="mypackage.Admin" %>

<%
    // Get admin ID from request parameter
    String adminIdParam = request.getParameter("id");
    Admin admin = null;
    
    if (adminIdParam != null && !adminIdParam.isEmpty()) {
        try {
            int adminId = Integer.parseInt(adminIdParam);
            DAO dao = new DAO();
            admin = dao.getAdminById(adminId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // If admin not found, redirect
    if (admin == null) {
        response.sendRedirect("adminManagement.jsp");
        return;
    }
    
    // Store in request attribute for JSTL
    request.setAttribute("admin", admin);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Admin Profile</title>
    <style>
        :root {
            --primary: #4CAF50;
            --primary-hover: #45a049;
            --background: #121212;
            --surface: #1e1e1e;
            --on-background: #e1e1e1;
            --on-surface: #ffffff;
            --border: #333333;
            --error: #f44336;
            --warning: #ff9800;
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
        
        .edit-container {
            max-width: 900px;
            margin: 20px auto;
            background: var(--surface);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        
        .form-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 20px;
        }
        
        .photo-container {
            position: relative;
            margin-right: 30px;
        }
        
        .admin-photo {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        
        .admin-photo:hover {
            transform: scale(1.05);
        }
        
        .photo-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .photo-container:hover .photo-overlay {
            opacity: 1;
        }
        
        .photo-change-btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
        }
        
        .header-info {
            flex: 1;
        }
        
        .header-title {
            margin: 0;
            color: var(--on-surface);
            font-size: 2rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .header-subtitle {
            color: #aaa;
            margin-top: 8px;
            font-size: 1.2rem;
        }
        
        .form-section {
            margin-bottom: 25px;
            background: rgba(255, 255, 255, 0.03);
            padding: 25px;
            border-radius: 8px;
            border: 1px solid var(--border);
        }
        
        .form-section h3 {
            border-bottom: 1px solid var(--border);
            padding-bottom: 10px;
            color: var(--primary);
            margin-top: 0;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
        }
        
        .form-section h3 i {
            margin-right: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #aaa;
            display: flex;
            align-items: center;
        }
        
        .form-label i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .required::after {
            content: " *";
            color: var(--error);
        }
        
        .form-input {
            width: 90%;
            padding: 12px 15px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border);
            border-radius: 6px;
            color: var(--on-surface);
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
            background: rgba(255, 255, 255, 0.08);
        }
        
        .form-input[type="file"] {
            padding: 8px 0;
            background: transparent;
            border: none;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #aaa;
            cursor: pointer;
        }
        
        .password-container {
            position: relative;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .checkbox-label {
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .checkbox-input {
            margin-right: 8px;
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }
        
        .form-btn {
            padding: 12px 30px;
            border-radius: 6px;
            border: none;
            font-weight: 500;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 120px;
        }
        
        .save-btn {
            background: var(--primary);
            color: white;
        }
        
        .save-btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        
        .cancel-btn {
            background: #666;
            color: white;
        }
        
        .cancel-btn:hover {
            background: #555;
            transform: translateY(-2px);
        }
        
        .reset-btn {
            background: var(--warning);
            color: white;
        }
        
        .reset-btn:hover {
            background: #e68900;
            transform: translateY(-2px);
        }
        
        .form-btn i {
            margin-right: 8px;
        }
        
        .error-message {
            color: var(--error);
            font-size: 0.9rem;
            margin-top: 5px;
            display: flex;
            align-items: center;
        }
        
        .error-message i {
            margin-right: 5px;
        }
        
        .success-message {
            color: var(--primary);
            font-size: 0.9rem;
            margin-top: 5px;
            display: flex;
            align-items: center;
        }
        
        .success-message i {
            margin-right: 5px;
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
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .back-link:hover {
            background: #555;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        
        .back-link i {
            margin-right: 8px;
        }
        
        .photo-preview {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-top: 15px;
        }
        
        .current-photo {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--border);
        }
        
        .photo-actions {
            display: flex;
            gap: 10px;
        }
        
        .photo-action-btn {
            padding: 6px 12px;
            background: #444;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
        }
        
        .photo-action-btn:hover {
            background: #555;
        }
        
        @media (max-width: 768px) {
            .form-header {
                flex-direction: column;
                text-align: center;
            }
            
            .photo-container {
                margin-right: 0;
                margin-bottom: 20px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 15px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .form-btn {
                width: 100%;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    
    <a href="ViewAdmin.jsp?id=${admin.adminId}" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Admin Profile
    </a>
    
    <div class="edit-container">
        <form id="editAdminForm" action="UpdateAdminServlet" method="post" enctype="multipart/form-data" 
            onsubmit="return validateFormAndSubmit()">
            <input type="hidden" name="adminId" value="${admin.adminId}">
            
            <div class="form-header">
                <div class="photo-container">
                    <c:choose>
                        <c:when test="${not empty admin.adminPhoto}">
                            <img id="adminPhotoPreview" 
                                 src="data:image/jpeg;base64,${admin.getImageBase64()}" 
                                 class="admin-photo" 
                                 alt="${admin.adminName}">
                        </c:when>
                        <c:otherwise>
                            <div id="adminPhotoPreview" class="admin-photo" 
                                 style="background: #2a2a2a; display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-user-shield" style="font-size: 50px; color: #4CAF50;"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="photo-overlay">
                        <label for="adminPhoto" class="photo-change-btn">
                            <i class="fas fa-camera"></i> Change Photo
                        </label>
                    </div>
                </div>
                <div class="header-info">
                    <h1 class="header-title">Edit Admin Profile</h1>
                    <div class="header-subtitle">ID: ${admin.adminId} | @${admin.adminUsername}</div>
                </div>
            </div>

            <div class="form-section">
                <h3><i class="fas fa-id-card"></i> Basic Information</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">
                            <i class="fas fa-user"></i> Full Name
                        </label>
                        <input type="text" 
                               name="adminName" 
                               class="form-input" 
                               value="${admin.adminName}" 
                               required
                               placeholder="Enter admin full name">
                        <div id="nameError" class="error-message" style="display: none;">
                            <i class="fas fa-exclamation-circle"></i> Name is required
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label required">
                            <i class="fas fa-at"></i> Username
                        </label>
                        <input type="text" 
                               name="adminUsername" 
                               class="form-input" 
                               value="${admin.adminUsername}" 
                               required
                               placeholder="Enter username">
                        <div id="usernameError" class="error-message" style="display: none;">
                            <i class="fas fa-exclamation-circle"></i> Username is required
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-camera"></i> Profile Photo
                    </label>
                    <input type="file" 
                           id="adminPhoto" 
                           name="adminPhoto" 
                           class="form-input" 
                           accept="image/*"
                           onchange="previewPhoto(event)">
                    
                    <div class="photo-preview">
                        <div>Current Photo:</div>
                        <c:if test="${not empty admin.adminPhoto}">
                            <img src="data:image/jpeg;base64,${admin.getImageBase64()}" 
                                 class="current-photo" 
                                 alt="Current Photo">
                            <div class="photo-actions">
                                <button type="button" class="photo-action-btn" onclick="removePhoto()">
                                    <i class="fas fa-trash"></i> Remove
                                </button>
                                <input type="hidden" id="deletePhoto" name="deletePhoto" value="false">
                            </div>
                        </c:if>
                        <c:if test="${empty admin.adminPhoto}">
                            <div style="color: #888; font-style: italic;">No photo uploaded</div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="form-section">
                <h3><i class="fas fa-key"></i> Security Settings</h3>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-lock"></i> New Password
                    </label>
                    <div class="password-container">
                        <input type="password" 
                               id="adminPassword" 
                               name="adminPassword" 
                               class="form-input" 
                               placeholder="Enter new password (leave blank to keep current)">
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div id="passwordHelp" class="success-message">
                        <i class="fas fa-info-circle"></i> Leave blank to keep current password
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-lock"></i> Confirm Password
                    </label>
                    <div class="password-container">
                        <input type="password" 
                               id="confirmPassword" 
                               class="form-input" 
                               placeholder="Confirm new password">
                        <button type="button" class="password-toggle" onclick="toggleConfirmPassword()">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div id="passwordError" class="error-message" style="display: none;">
                        <i class="fas fa-exclamation-circle"></i> Passwords do not match
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="form-btn cancel-btn" onclick="window.history.back()">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button type="button" class="form-btn reset-btn" onclick="resetForm()">
                    <i class="fas fa-redo"></i> Reset
                </button>
                <button type="submit" class="form-btn save-btn">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </div>
        </form>
    </div>

    <script>
    // Flag to track if form is being submitted
    let isSubmitting = false;
    
    function previewPhoto(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('adminPhotoPreview');
                preview.src = e.target.result;
                preview.style.display = 'block';
                
                // If it was a div with icon, change to img
                if (preview.tagName === 'DIV') {
                    const img = document.createElement('img');
                    img.id = 'adminPhotoPreview';
                    img.className = 'admin-photo';
                    img.src = e.target.result;
                    img.alt = 'Profile Preview';
                    preview.parentNode.replaceChild(img, preview);
                }
            };
            reader.readAsDataURL(file);
        }
    }
    
    function removePhoto() {
        document.getElementById('deletePhoto').value = 'true';
        const preview = document.getElementById('adminPhotoPreview');
        
        // Replace with default icon
        const defaultDiv = document.createElement('div');
        defaultDiv.id = 'adminPhotoPreview';
        defaultDiv.className = 'admin-photo';
        defaultDiv.style.background = '#2a2a2a';
        defaultDiv.style.display = 'flex';
        defaultDiv.style.alignItems = 'center';
        defaultDiv.style.justifyContent = 'center';
        
        const icon = document.createElement('i');
        icon.className = 'fas fa-user-shield';
        icon.style.fontSize = '50px';
        icon.style.color = '#4CAF50';
        defaultDiv.appendChild(icon);
        
        preview.parentNode.replaceChild(defaultDiv, preview);
    }
    
    function togglePassword() {
        const passwordField = document.getElementById('adminPassword');
        const toggleIcon = passwordField.nextElementSibling.querySelector('i');
        
        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            toggleIcon.className = 'fas fa-eye-slash';
        } else {
            passwordField.type = 'password';
            toggleIcon.className = 'fas fa-eye';
        }
    }
    
    function toggleConfirmPassword() {
        const confirmField = document.getElementById('confirmPassword');
        const toggleIcon = confirmField.nextElementSibling.querySelector('i');
        
        if (confirmField.type === 'password') {
            confirmField.type = 'text';
            toggleIcon.className = 'fas fa-eye-slash';
        } else {
            confirmField.type = 'password';
            toggleIcon.className = 'fas fa-eye';
        }
    }
    
    function validateForm() {
        let isValid = true;
        
        // Reset errors
        document.querySelectorAll('.error-message').forEach(el => {
            el.style.display = 'none';
        });
        
        // Validate name
        const nameField = document.getElementsByName('adminName')[0];
        if (!nameField.value.trim()) {
            document.getElementById('nameError').style.display = 'flex';
            nameField.focus();
            isValid = false;
        }
        
        // Validate username
        const usernameField = document.getElementsByName('adminUsername')[0];
        if (!usernameField.value.trim()) {
            document.getElementById('usernameError').style.display = 'flex';
            if (isValid) usernameField.focus();
            isValid = false;
        }
        
        // Validate password match
        const password = document.getElementById('adminPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        if (password && password !== confirmPassword) {
            document.getElementById('passwordError').style.display = 'flex';
            if (isValid) document.getElementById('confirmPassword').focus();
            isValid = false;
        }
        
        return isValid;
    }
    
    function validateFormAndSubmit() {
        if (!validateForm()) {
            return false;
        }
        
        // Set submitting flag to prevent beforeunload warning
        isSubmitting = true;
        
        // Show loading state on button
        const saveBtn = document.querySelector('.save-btn');
        const originalHtml = saveBtn.innerHTML;
        saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        saveBtn.disabled = true;
        
        // The form will submit normally to UpdateAdminServlet
        return true;
    }
    
    function resetForm() {
        if (confirm('Are you sure you want to reset all changes?')) {
            document.getElementById('editAdminForm').reset();
            document.getElementById('deletePhoto').value = 'false';
            
            // Reset photo preview to original
            const originalPhoto = '${admin.getImageBase64()}';
            const preview = document.getElementById('adminPhotoPreview');
            
            if (originalPhoto && originalPhoto.length > 0) {
                preview.src = 'data:image/jpeg;base64,' + originalPhoto;
            } else {
                preview.src = '';
                preview.innerHTML = '<i class="fas fa-user-shield" style="font-size: 50px; color: #4CAF50;"></i>';
            }
            
            // Hide error messages
            document.querySelectorAll('.error-message').forEach(el => {
                el.style.display = 'none';
            });
        }
    }
    
    // Show warning if trying to leave with unsaved changes
    window.addEventListener('beforeunload', function (e) {
        // Don't show warning if form is being submitted
        if (isSubmitting) {
            return;
        }
        
        const originalName = '${admin.adminName}';
        const originalUsername = '${admin.adminUsername}';
        const currentName = document.getElementsByName('adminName')[0].value;
        const currentUsername = document.getElementsByName('adminUsername')[0].value;
        const password = document.getElementById('adminPassword').value;
        const photoFile = document.getElementById('adminPhoto').files[0];
        const deletePhoto = document.getElementById('deletePhoto').value === 'true';
        
        if (currentName !== originalName || 
            currentUsername !== originalUsername || 
            password || 
            photoFile || 
            deletePhoto) {
            
            e.preventDefault();
            e.returnValue = '';
            return '';
        }
    });
    
    // Reset flag when page loads (in case of back button)
    window.addEventListener('pageshow', function(event) {
        isSubmitting = false;
    });
</script>
</body>
</html>