<%-- 
    Document   : success
    Created on : May 19, 2025, 2:05:49 PM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="mypackage.DAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration Successful</title>
        <link rel="icon" type="image/svg+xml" href="assets/images/C Logo gold.svg?v=1.1" />
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .success-container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        .success-icon {
            color: #4CAF50;
            font-size: 60px;
            margin-bottom: 20px;
        }
        h1 {
            color: #4CAF50;
            margin-bottom: 20px;
        }
        p {
            color: #555;
            margin-bottom: 30px;
            font-size: 16px;
            line-height: 1.6;
        }
        .btn {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .login-link {
            margin-top: 20px;
            font-size: 14px;
            color: #777;
        }
        .login-link a {
            color: #4CAF50;
            text-decoration: none;
        }
        .success-message {
            color: green;
            font-size: 1.2em;
            margin: 20px; 
        }
        .return-link { 
            display: inline-block; 
            margin-top: 20px; 
        }
    </style>
</head>
<body>
<%
    String StudentFullName = "Student";
    Integer id = null;

    try {
        DAO StudentDAO = new DAO();

        Object nameAttr = request.getAttribute("StudentFirstName");
        if (nameAttr != null) {
            StudentFullName = nameAttr.toString();
            id = StudentDAO.getStudentIdByName(StudentFullName);
        }
    } catch (Exception e) {
        request.setAttribute("error", "Unexpected error: " + e.getMessage());
    }
%>
    <div class="success-container">
        <div class="success-icon">✓</div>
        <h1>Registration Successful!</h1>
        <p>Thank you for registering with our admission portal. Your application has been received and is currently under review.</p>
        <p>You will receive an email notification once your application status is updated.</p>

    <div class="success-message">
        Good Luck <%= StudentFullName %>
    </div>        
    <div class="success-message">
        Application ID: <%= id %>
    </div>
    <a href="StudentForm.jsp" class="return-link">Return to Registration Form</a>
        <div class="login-link">
            Already have an account? <a href="LoginForm.jsp">Sign In</a>
        </div>
    </div>
</body>
</html>