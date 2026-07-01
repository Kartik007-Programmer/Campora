<%-- 
    Document   : AddAdmin
    Created on : 12 Jan 2026, 7:56:50 pm
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="mypackage.*" %>

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

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Administrator</title>
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
            --success: #4CAF50;
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
        
        .add-container {
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
            background: #2a2a2a;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .admin-photo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }
        
        .admin-photo .photo-icon {
            font-size: 50px;
            color: #4CAF50;
            z-index: 1;
            position: relative;
        }
        
        .admin-photo.has-photo .photo-icon {
            display: none;
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
            cursor: pointer;
        }
        
        .photo-container:hover .photo-overlay {
            opacity: 1;
        }
        
        .photo-icon {
            font-size: 50px;
            color: #4CAF50;
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
            cursor: pointer;
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
            z-index: 2;
        }
        
        .password-container {
            position: relative;
        }
        
        .password-strength {
            height: 4px;
            margin-top: 5px;
            border-radius: 2px;
            background: #444;
            overflow: hidden;
        }
        
        .strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
        }
        
        .strength-weak { background: var(--error); width: 33%; }
        .strength-medium { background: var(--warning); width: 66%; }
        .strength-strong { background: var(--success); width: 100%; }
        
        .strength-text {
            font-size: 0.8rem;
            margin-top: 3px;
            text-align: right;
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
        
        .submit-btn {
            background: var(--primary);
            color: white;
        }
        
        .submit-btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        
        .submit-btn:disabled {
            background: #666;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
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
            display: none;
        }
        
        .error-message i {
            margin-right: 5px;
        }
        
        .success-message {
            color: var(--success);
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
        
        .info-box {
            background: rgba(76, 175, 80, 0.1);
            border-left: 4px solid var(--primary);
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .info-box p {
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .info-box i {
            margin-right: 10px;
            color: var(--primary);
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
    <a href="Admin_penal.jsp" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
    
    <div class="add-container">
        <form id="addAdminForm" action="AddAdminServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            
            <div class="form-header">
                <div class="photo-container">
                    <div id="adminPhotoPreview" class="admin-photo">
                        <i class="fas fa-user-plus photo-icon"></i>
                    </div>
                    <div class="photo-overlay" onclick="document.getElementById('adminPhoto').click()">
                        <label class="photo-change-btn">
                            <i class="fas fa-camera"></i> Upload Photo
                        </label>
                    </div>
                </div>
                <div class="header-info">
                    <h1 class="header-title">Add New Administrator</h1>
                    <div class="header-subtitle">Create a new admin account</div>
                </div>
            </div>
            
            <div class="info-box">
                <p><i class="fas fa-info-circle"></i> All fields marked with * are required. Passwords must be at least 8 characters long. Maximum photo size is 2MB.</p>
            </div>

            <div class="form-section">
                <h3><i class="fas fa-id-card"></i> Basic Information</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">
                            <i class="fas fa-user"></i> Full Name
                        </label>
                        <input type="text" 
                               id="adminName" 
                               name="adminName" 
                               class="form-input" 
                               required
                               placeholder="Enter admin full name"
                               oninput="validateName()">
                        <div id="nameError" class="error-message">
                            <i class="fas fa-exclamation-circle"></i> Please enter a valid name (minimum 3 characters)
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label required">
                            <i class="fas fa-at"></i> Username
                        </label>
                        <input type="text" 
                               id="adminUsername" 
                               name="adminUsername" 
                               class="form-input" 
                               required
                               placeholder="Enter username"
                               oninput="validateUsername()">
                        <div id="usernameError" class="error-message">
                            <i class="fas fa-exclamation-circle"></i> Username must be 4-20 characters (letters, numbers, underscore)
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
                    
                    <div class="photo-preview" id="photoPreviewSection" style="display: none;">
                        <div>Preview:</div>
                        <div class="photo-actions">
                            <button type="button" class="photo-action-btn" onclick="removePhoto()">
                                <i class="fas fa-trash"></i> Remove Photo
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="form-section">
                <h3><i class="fas fa-key"></i> Account Security</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">
                            <i class="fas fa-lock"></i> Password
                        </label>
                        <div class="password-container">
                            <input type="password" 
                                   id="adminPassword" 
                                   name="adminPassword" 
                                   class="form-input" 
                                   required
                                   placeholder="Enter password"
                                   oninput="validatePassword()">
                            <button type="button" class="password-toggle" onclick="togglePassword('adminPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength">
                            <div id="passwordStrengthBar" class="strength-bar"></div>
                        </div>
                        <div id="passwordStrengthText" class="strength-text"></div>
                        <div id="passwordError" class="error-message">
                            <i class="fas fa-exclamation-circle"></i> Password must be at least 8 characters
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label required">
                            <i class="fas fa-lock"></i> Confirm Password
                        </label>
                        <div class="password-container">
                            <input type="password" 
                                   id="confirmPassword" 
                                   name="confirmPassword" 
                                   class="form-input" 
                                   required
                                   placeholder="Confirm password"
                                   oninput="validatePassword()">
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="confirmError" class="error-message">
                            <i class="fas fa-exclamation-circle"></i> Passwords do not match
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="form-btn cancel-btn" onclick="window.location.href='Admin_penal.jsp'">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button type="button" class="form-btn reset-btn" onclick="resetForm()">
                    <i class="fas fa-redo"></i> Reset
                </button>
                <button type="submit" class="form-btn submit-btn" id="submitBtn">
                    <i class="fas fa-user-plus"></i> Create Admin
                </button>
            </div>
        </form>
    </div>

    <script>
        let isFormValid = false;
        let photoFile = null;
        
        function previewPhoto(event) {
            const file = event.target.files[0];
            if (file) {
                photoFile = file;
                
                // Validate file type
                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                if (!validTypes.includes(file.type)) {
                    alert('Please select a valid image file (JPEG, PNG, GIF, WebP)');
                    event.target.value = '';
                    photoFile = null;
                    return;
                }
                
                // Validate file size (max 2MB as per servlet)
                const maxSize = 2 * 1024 * 1024;
                if (file.size > maxSize) {
                    alert('Image size should be less than 2MB');
                    event.target.value = '';
                    photoFile = null;
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('adminPhotoPreview');
                    preview.innerHTML = '';
                    
                    // Create img element for preview
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = 'Admin Photo Preview';
                    
                    preview.appendChild(img);
                    preview.classList.add('has-photo');
                    
                    // Show preview section
                    document.getElementById('photoPreviewSection').style.display = 'flex';
                };
                
                reader.onerror = function() {
                    alert('Error reading file. Please try again.');
                    event.target.value = '';
                    photoFile = null;
                };
                
                reader.readAsDataURL(file);
            }
        }
        
        function removePhoto() {
            document.getElementById('adminPhoto').value = '';
            photoFile = null;
            
            const preview = document.getElementById('adminPhotoPreview');
            preview.innerHTML = '<i class="fas fa-user-plus photo-icon"></i>';
            preview.classList.remove('has-photo');
            
            document.getElementById('photoPreviewSection').style.display = 'none';
        }
        
        function togglePassword(fieldId, button) {
            const field = document.getElementById(fieldId);
            const icon = button.querySelector('i');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                field.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }
        
        function validateName() {
            const field = document.getElementById('adminName');
            const errorElement = document.getElementById('nameError');
            const isValid = field.value.trim().length >= 3;
            
            if (field.value.trim() === '') {
                errorElement.style.display = 'none';
                field.style.borderColor = 'var(--border)';
            } else if (isValid) {
                errorElement.style.display = 'none';
                field.style.borderColor = 'var(--primary)';
            } else {
                errorElement.style.display = 'flex';
                field.style.borderColor = 'var(--error)';
            }
            
            return isValid;
        }
        
        function validateUsername() {
            const field = document.getElementById('adminUsername');
            const errorElement = document.getElementById('usernameError');
            const usernameRegex = /^[a-zA-Z0-9_]{4,20}$/;
            const isValid = usernameRegex.test(field.value);
            
            if (field.value.trim() === '') {
                errorElement.style.display = 'none';
                field.style.borderColor = 'var(--border)';
            } else if (isValid) {
                errorElement.style.display = 'none';
                field.style.borderColor = 'var(--primary)';
            } else {
                errorElement.style.display = 'flex';
                field.style.borderColor = 'var(--error)';
            }
            
            return isValid;
        }
        
        function validatePassword() {
            const password = document.getElementById('adminPassword');
            const confirm = document.getElementById('confirmPassword');
            const passwordError = document.getElementById('passwordError');
            const confirmError = document.getElementById('confirmError');
            const strengthBar = document.getElementById('passwordStrengthBar');
            const strengthText = document.getElementById('passwordStrengthText');
            
            let passwordValid = false;
            let confirmValid = false;
            
            // Validate password length
            if (password.value.length >= 8) {
                passwordValid = true;
                passwordError.style.display = 'none';
                password.style.borderColor = 'var(--primary)';
                
                // Calculate password strength
                let strength = 0;
                if (password.value.length >= 8) strength++;
                if (/[A-Z]/.test(password.value)) strength++;
                if (/[0-9]/.test(password.value)) strength++;
                if (/[^A-Za-z0-9]/.test(password.value)) strength++;
                
                // Reset and apply strength classes
                strengthBar.className = 'strength-bar';
                strengthBar.style.width = '0%';
                
                switch(strength) {
                    case 1:
                        strengthBar.classList.add('strength-weak');
                        strengthBar.style.width = '33%';
                        strengthText.textContent = 'Weak';
                        strengthText.style.color = 'var(--error)';
                        break;
                    case 2:
                        strengthBar.classList.add('strength-medium');
                        strengthBar.style.width = '66%';
                        strengthText.textContent = 'Medium';
                        strengthText.style.color = 'var(--warning)';
                        break;
                    case 3:
                    case 4:
                        strengthBar.classList.add('strength-strong');
                        strengthBar.style.width = '100%';
                        strengthText.textContent = 'Strong';
                        strengthText.style.color = 'var(--success)';
                        break;
                    default:
                        strengthText.textContent = '';
                }
            } else {
                passwordValid = false;
                passwordError.style.display = password.value ? 'flex' : 'none';
                password.style.borderColor = password.value ? 'var(--error)' : 'var(--border)';
                strengthBar.className = 'strength-bar';
                strengthBar.style.width = '0%';
                strengthText.textContent = '';
            }
            
            // Validate password match
            if (passwordValid && password.value === confirm.value) {
                confirmValid = true;
                confirmError.style.display = 'none';
                confirm.style.borderColor = 'var(--primary)';
            } else if (confirm.value) {
                confirmValid = false;
                confirmError.style.display = 'flex';
                confirm.style.borderColor = 'var(--error)';
            } else {
                confirmValid = false;
                confirmError.style.display = 'none';
                confirm.style.borderColor = 'var(--border)';
            }
            
            return passwordValid && confirmValid;
        }
        
        function checkFormValidity() {
            const nameValid = validateName();
            const usernameValid = validateUsername();
            const passwordValid = validatePassword();
            
            isFormValid = nameValid && usernameValid && passwordValid;
            return isFormValid;
        }
        
        function validateForm() {
            // Run all validations
            const nameValid = validateName();
            const usernameValid = validateUsername();
            const passwordValid = validatePassword();
            
            isFormValid = nameValid && usernameValid && passwordValid;
            
            if (!isFormValid) {
                // Find first error and scroll to it
                const firstError = document.querySelector('.error-message[style*="display: flex"]');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    // Find the input field related to this error
                    const inputId = firstError.id.replace('Error', '');
                    const inputField = document.getElementById(inputId);
                    if (inputField) {
                        inputField.focus();
                    }
                }
                
                alert('Please fix all errors before submitting.');
                return false;
            }
            
            // Show loading state
            const submitBtn = document.getElementById('submitBtn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
            submitBtn.disabled = true;
            
            // Allow form submission
            return true;
        }
        
        function resetForm() {
            if (confirm('Are you sure you want to reset all fields?')) {
                document.getElementById('addAdminForm').reset();
                removePhoto();
                
                // Reset validation states
                document.querySelectorAll('.error-message').forEach(el => {
                    el.style.display = 'none';
                });
                
                document.querySelectorAll('.form-input').forEach(el => {
                    el.style.borderColor = 'var(--border)';
                });
                
                // Reset password strength
                const strengthBar = document.getElementById('passwordStrengthBar');
                strengthBar.className = 'strength-bar';
                strengthBar.style.width = '0%';
                document.getElementById('passwordStrengthText').textContent = '';
                
                isFormValid = false;
            }
        }
        
        // Initialize validation on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Add live validation for all fields
            const inputs = document.querySelectorAll('.form-input[required]');
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.id === 'adminName') {
                        validateName();
                    } else if (this.id === 'adminUsername') {
                        validateUsername();
                    } else if (this.id === 'adminPassword' || this.id === 'confirmPassword') {
                        validatePassword();
                    }
                });
                
                input.addEventListener('input', function() {
                    if (this.id === 'adminName') {
                        validateName();
                    } else if (this.id === 'adminUsername') {
                        validateUsername();
                    } else if (this.id === 'adminPassword' || this.id === 'confirmPassword') {
                        validatePassword();
                    }
                });
            });
            
            // Also validate when user tries to submit
            document.getElementById('addAdminForm').addEventListener('submit', function(e) {
                // Validation is already handled by validateForm() return value
                // Just make sure we run the validation
                if (!validateForm()) {
                    e.preventDefault();
                }
            });
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
</body>
</html>