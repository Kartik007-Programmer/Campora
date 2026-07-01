<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Corona Admin</title>
    <% String path = request.getContextPath(); %>
    <link rel="icon" type="image/svg+xml" href="<%= request.getContextPath() %>/assets/images/C Logo gold.svg?v=1.1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-icons/3.0.1/iconfont/material-icons.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Roboto', sans-serif;
        }
        
        body {
            background-image:  url('<%= request.getContextPath() %>/assets/images/auth/Login_bg.jpg');
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
            color: white;
            min-height: 100vh;
        }
        
        .container-scroller {
            display: flex;
            min-height: 100vh;
        }
        
        .page-body-wrapper {
            width: 100%;
        }
        
        .row {
            display: flex;
            flex-wrap: wrap;
            width: 100%;
            margin: 0;
        }
        
        .content-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            min-height: 100vh;
            background: url('<%= path %>/assets/images/auth-bg.jpg') no-repeat center center;
            background-size: cover;
            padding: 20px;
        }
        
        .card {
            background: rgba(26, 26, 46, 0.9);
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 450px;
            position: relative;
            overflow: hidden;
        }
        
        .card-body {
            padding: 40px;
        }
        
        .card-title {
            font-size: 24px;
            font-weight: 500;
            margin-bottom: 30px;
            color: #fff;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 5px;
            color: white;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.1);
        }
        
        .form-check {
            display: flex;
            align-items: center;
        }
        
        .form-check-input {
            margin-right: 8px;
            cursor: pointer;
        }
        
        .form-check-label {
            color: rgba(255, 255, 255, 0.8);
            cursor: pointer;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 20px;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }
        
        .btn-primary {
            background-color: #4b49ac;
            color: white;
            width: 100%;
        }
        
        .btn-primary:hover {
            background-color: #3f3d8f;
        }
        
        .forgot-pass {
            color: rgba(255, 255, 255, 0.6);
            text-decoration: none;
            font-size: 13px;
            transition: color 0.3s;
        }
        
        .forgot-pass:hover {
            color: white;
        }
        
        .sign-up {
            margin-top: 20px;
            text-align: center;
            color: rgba(255, 255, 255, 0.6);
            font-size: 14px;
        }
        
        .sign-up a {
            color: #4b49ac;
            text-decoration: none;
            margin-left: 5px;
        }
        
        .sign-up a:hover {
            text-decoration: underline;
        }
        
        .text-center {
            text-align: center;
        }
        
        .d-flex {
            display: flex;
        }
        
        .align-items-center {
            align-items: center;
        }
        
        .justify-content-between {
            justify-content: space-between;
        }
        
        .role-toggle-wrapper {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 10;
            background-color: rgba(255, 255, 255, 0.05);
            padding: 6px 14px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .role-toggle-wrapper .form-check {
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .role-toggle-wrapper .form-check-input {
            margin-right: 5px;
            cursor: pointer;
        }
        
        .role-toggle-wrapper .form-check-label {
            color: white;
            font-weight: 500;
            cursor: pointer;
        }
        
        @media (max-width: 576px) {
            .role-toggle-wrapper {
                position: static;
                justify-content: center;
                margin-bottom: 10px;
            }
            
            .card-body {
                padding: 30px 20px;
            }
        }
        
        .p_input {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white !important;
        }
        
        .position-relative {
            position: relative;
        }
        
        .mx-auto {
            margin-left: auto;
            margin-right: auto;
        }
        
        .m-0 {
            margin: 0;
        }
        
        .w-100 {
            width: 100%;
        }
        
        .mb-3 {
            margin-bottom: 1rem;
        }
        
        .enter-btn {
            background: #4b49ac;
            color: white;
            border: none;
            padding: 12px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
            width: 100%;
        }
        
        .enter-btn:hover {
            background: #3f3d8f;
        }
    </style>
</head>
<body>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <script>alert('<%= error %>');</script>
    <%
        }
    %>
    <div class="container-scroller">
        <div class="page-body-wrapper">
            <div class="row w-100 m-0">
                <div class="content-wrapper">
                    <div class="card col-lg-4 mx-auto position-relative">
                        <form id="loginForm" method="post" autocomplete="off">    
                            <!-- Role Toggle -->
                            <div class="role-toggle-wrapper">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" id="studentRadio" name="userType" value="student" checked>
                                    <label class="form-check-label" for="studentRadio">Student</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" id="teacherRadio" name="userType" value="admin">
                                    <label class="form-check-label" for="teacherRadio">Admin</label>
                                </div>
                            </div>

                            <div class="card-body">
                                <h3 class="card-title">Login</h3>

                                <div class="form-group">
                                    <label>Email/Number</label>
                                    <input type="text" name="username" class="form-control p_input" placeholder="Enter your Email or Number"
                                        value="<c:out value='${param.username}'/>" required>
                                </div>
                                <div class="form-group">
                                    <label>Password</label>
                                    <input type="password" name="password" class="form-control p_input" placeholder="Enter your Password" required>
                                </div>
                                <input type="hidden" name="action" value="login" id="actionField">

                                <div class="form-group d-flex align-items-center justify-content-between">
                                    <div class="form-check">
                                        <label class="form-check-label">
                                            <input type="checkbox" name="rememberMe" class="form-check-input"> Remember me
                                        </label>
                                    </div>
                                    <a href="forgot-passwordForm.jsp" class="forgot-pass">Forgot password?</a>
                                </div>
                                <div class="text-center">
                                    <button type="submit" class="enter-btn">Login</button>
                                </div>
                                <p class="sign-up">Don't have an Account?<a href="register.jsp"> Sign Up</a></p>
                            </div>
                        </form>     
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        const form = document.getElementById('loginForm');
        const actionField = document.getElementById('actionField');

        form.addEventListener('submit', function(e) {
            const userType = document.querySelector('input[name="userType"]:checked').value;

            if (userType === 'admin') {
                form.action = '${pageContext.request.contextPath}/AdminServlet';
                actionField.disabled = false; // Include the hidden field
            } else {
                form.action = '<%= request.getContextPath() %>/StudentLoginServlet';
                actionField.disabled = true; // Disable hidden field for student
            }
        });
    </script>
</body>
</html>