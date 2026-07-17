<%-- 
    Document   : edit-student-form
    Created on : Jul 9, 2025, 1:49:03 PM
    Author     : Batch2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.Course" %>
<%@ page import="mypackage.*" %>
<%@ page import="java.sql.SQLException" %>
<%   
    DAO dao = new DAO();
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
<html>
<head>
    <title>Edit Student</title>
    <link rel="icon" type="image/svg+xml" href="assets/images/C Logo gold.svg?v=1.1" />
    <style>
        :root {
            --bg-color: #1a1a2e;
            --card-color: #16213e;
            --text-color: #e6e6e6;
            --primary-color: #0f3460;
            --secondary-color: #4CAF50;
            --accent-color: #00b894;
            --border-color: #2d4059;
            --error-color: #ff6b6b;
            --success-color: #55efc4;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }
        
        .form-container {
            max-width: 600px;
            margin: 20px auto;
            padding: 30px;
            background-color: var(--card-color);
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        
        h2 {
            color: var(--accent-color);
            text-align: center;
            margin-bottom: 25px;
            font-size: 28px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--accent-color);
        }
        
        input, select, button {
            width: 100%;
            padding: 12px;
            border-radius: 5px;
            border: 1px solid var(--border-color);
            background-color: rgba(255, 255, 255, 0.05);
            color: var(--text-color);
            font-size: 16px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 2px rgba(0, 184, 148, 0.2);
        }
        
        button {
            background-color: var(--secondary-color);
            color: white;
            border: none;
            cursor: pointer;
            font-weight: 600;
            margin-top: 10px;
            padding: 14px;
            font-size: 16px;
        }
        
        button:hover {
            background-color: #3e8e41;
            transform: translateY(-2px);
        }
        
        .current-image {
            max-width: 200px;
            max-height: 200px;
            display: block;
            margin: 15px 0;
            border-radius: 5px;
            border: 2px solid var(--border-color);
        }
        
        .error {
            color: var(--error-color);
            margin-bottom: 15px;
            padding: 10px;
            background-color: rgba(255, 107, 107, 0.1);
            border-radius: 5px;
            text-align: center;
        }
        
        .success {
            color: var(--success-color);
            margin-bottom: 15px;
            padding: 10px;
            background-color: rgba(85, 239, 196, 0.1);
            border-radius: 5px;
            text-align: center;
        }
        
        hr {
            border: none;
            height: 1px;
            background-color: var(--border-color);
            margin: 25px 0;
        }
        
        #stuSelect {
            background-color: var(--primary-color);
            color: var(--text-color);
            padding: 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .cancel-btn {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: var(--accent-color);
            text-decoration: none;
            padding: 10px;
            border: 1px solid var(--accent-color);
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        
        .cancel-btn:hover {
            background-color: rgba(0, 184, 148, 0.1);
        }
        
        input[type="checkbox"] {
            width: auto;
            margin-right: 10px;
            transform: scale(1.3);
        }
        
        .checkbox-label {
            display: flex;
            align-items: center;
        }
        
        @media (max-width: 768px) {
            .form-container {
                padding: 20px;
                margin: 10px;
            }
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Edit Student</h2>

    <c:if test="${param.success == '1'}">
        <div class="success">Student updated successfully!</div>
    </c:if>

    <!-- Use contextPath so action works regardless of app context -->
    <form id="stuSelectForm" action="${pageContext.request.contextPath}/edit-student" method="get">
        <div class="form-group">
            <label for="stuSelect">Select Student:</label>
            <select id="stuSelect" name="id" onchange="if(this.value) this.form.submit();">
                <option value="">-- Select --</option>
                <c:forEach var="s" items="${studentList}">
                    <!-- use eq for safe comparison and output selected as attribute -->
                    <option value="${s.id}" <c:if test="${student != null and student.id eq s.id}">selected="selected"</c:if>>
                        <c:out value="${s.firstName}"/> <c:out value="${s.lastName}"/>
                    </option>
                </c:forEach>
            </select>
            <!-- In case user has JS disabled -->
            <noscript><button type="submit">Go</button></noscript>
        </div>
    </form>

    <c:if test="${not empty student}">
        <hr/>
        <form action="edit-student" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${student.id}" />
            
            <div class="form-group">
                <label>First Name:</label>
                <input name="firstName" value="${student.firstName}" required />
            </div>
            
            <div class="form-group">
                <label>Last Name:</label>
                <input name="lastName" value="${student.lastName}" required />
            </div>
            
            <div class="form-group">
                <label>Current Image:</label>
                <c:if test="${not empty student.photo}">
                    <img class="current-image" 
                         src="data:image/jpeg;base64,${student.getImageBase64()}" 
                         alt="Current Student Image">
                </c:if>
                <label>Update Image (optional):</label>
                <input type="file" name="studentImg" accept="image/*">
            </div>
            
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" value="${student.email}" required />
            </div>
            
            <div class="form-group">
                <label>Mobile:</label>
                <input name="mobile" value="${student.mobile}" required />
            </div>
            
            <div class="form-group"> 
                <label>Password:</label>
                <input type="password" name="password" value="${student.password}" required />
            </div>
            
            <div class="form-group">
                <label>Gender:</label>     
                <select name="gender" required>
                    <option value="Male" ${student.gender=='Male' ? 'selected' : ''}>Male</option>
                    <option value="Female" ${student.gender=='Female' ? 'selected' : ''}>Female</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Date of Birth:</label>
                <input type="date" name="dob" value="${student.dob}" required />
            </div>
            
            <div class="form-group">
                <label>Course:</label>
                <input name="course" value="${student.course}" required />
            </div>
            
            <div class="form-group">
                <label>Qualification:</label>
                <input name="qualification" value="${student.qualification}" required />
            </div>
            
            <div class="form-group">
                <label>% Last Year:</label>
                <input type="number" name="lastYearPercentage" value="${student.lastYearPercentage}" min="0" max="100" step="0.01" required />
            </div>
            
            <div class="form-group">
                <label>Address Line 1:</label>
                <input name="addressLine1" value="${student.addressLine1}" required />
            </div>
            
            <div class="form-group">
                <label>Address Line 2:</label>
                <input name="addressLine2" value="${student.addressLine2}" />
            </div>
            
            <div class="form-group">
                <label>Landmark:</label>
                <input name="landmark" value="${student.landmark}" />
            </div>
            
            <div class="form-group">
                <label>Pincode:</label>
                <input type="text" name="pincode" value="${student.pincode}" required pattern="[0-9]{6}" title="6-digit pincode" />
            </div>
            
            <div class="form-group">
                <label>State:</label>
                <input name="state" value="${student.state}" required />
            </div>
            
            <div class="form-group">
                <label>City:</label>
                <input name="city" value="${student.city}" required />
            </div>
            
            <div class="form-group checkbox-label">
                <input type="checkbox" name="rememberMe" id="rememberMe" ${student.rememberMe ? 'checked' : ''} />
                <label for="rememberMe">Remember Me</label>
            </div>
            
            <div class="form-group">
                <label>Status:</label>
                <input name="status" value="${student.status}" required />
            </div>
            
            <button type="submit">Update Student</button>
            <a href="manage_students.jsp" class="cancel-btn">
                Cancel
            </a>
        </form>
    </c:if>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
</div>
        
    <script>
        window.onload = function() {
            const navEntries = performance.getEntriesByType("navigation");
            if (navEntries.length > 0 && navEntries[0].type === "reload") {
                const isLoggedIn = <%= isUserLoggedIn %>;
                if (isLoggedIn) {
                    window.location.href = 'pages/regiseterlogin_page/LoginForm.jsp';
                }
            }
        };
    </script>        
</body>
</html>