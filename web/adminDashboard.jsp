S<%-- 
    Document   : adminDashboard
    Created on : May 19, 2025, 1:58:47 PM
    Author     : Lenovo
--%>
<%@page import="mypackage.Student"%>
<%@page import="mypackage.DAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.sql.SQLException" %>

<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader ("Expires", 0);

    if (session == null || session.getAttribute("admin") == null) {
        RequestDispatcher rd = request.getRequestDispatcher("LoginForm.jsp");
        rd.forward(request, response);
    }
%>

<%
if (request.getAttribute("students") == null) {
   try{
       DAO dao = new DAO();
       List<Student> students = dao.getAllStudents();
       request.setAttribute("students", students);
   } catch (SQLException e) {
       request.setAttribute("error", "Database error: " + e.getMessage());
   }
}
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Admin Dashboard</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        .status-pending { color: #FFA500; }
        .status-approved { color: #4CAF50; }
        .status-rejected { color: #f44336; }
        .action-btn { padding: 5px 10px; margin: 2px; border: none; border-radius: 4px; cursor: pointer; }
        .approve-btn { background-color: #4CAF50; color: white; }
        .reject-btn { background-color: #f44336; color: white; }
        .logout-btn { background: #f44336; color: white; padding: 8px 16px; text-decoration: none; border-radius: 4px; float: right; }
        .message { color: green; margin: 10px 0; }
        .error { color: red; margin: 10px 0; }
        .photo-cell { width: 100px; }
        .student-photo { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; }
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
    <h1>Student Applications</h1>
    <a href="LogoutServlet" class="logout-btn">Logout</a>
    <div class="clearfix"></div>
    
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
        <c:remove var="message" scope="session" />
    </c:if>
    
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
        <c:remove var="error" scope="session" />
    </c:if>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Photo</th>
                <th>Frist Name</th>
                <th>Last Name</th>
                <th>Mobile</th>
                <th>Email</th>
                <th>Course</th>
                <th>Date of Birth</th>
                <th>Gender</th>
                <th>Last Year Percentage</th>
                <th>Registered On</th>
                <th>Processed On</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="student" items="${students}">
                <tr>
                    <td>${student.id}</td>
                    <td class="photo-cell">
                     <c:if test="${not empty student.photo}">
                       <img src="data:image/jpeg;base64,${student.imageBase64}" 
                          alt="Student Photo" 
                          class="student-photo">
                     </c:if>
                     <c:if test="${empty student.photo}">
                        No photo
                     </c:if>  
                    </td>
                    <td>${student.firstName}</td>
                    <td>${student.lastName}</td>
                    <td>${student.mobile}</td>
                    <td>${student.email}</td>
                    <td>${student.course}</td>
                    <td class="date-column">
                        <fmt:formatDate value="${student.dob}" 
                                       pattern="dd-MMM-yyyy" />
                    </td>
                    <td>${student.gender}</td>
                    <td>${student.lastYearPercentage}</td>
                    <td class="date-column">
                        <fmt:formatDate value="${student.registrationDate}" 
                                       pattern="dd-MMM-yyyy HH:mm" />
                    </td>
                    <td class="date-column">
                        <c:choose>
                            <c:when test="${not empty student.processedDate}">
                                <fmt:formatDate value="${student.processedDate}" 
                                               pattern="dd-MMM-yyyy HH:mm" />
                            </c:when>
                            <c:otherwise>
                                Not processed
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="status-${student.status.toLowerCase()}">
                        ${student.status}
                    </td>
                     <td>
                        <form action="AdminServlet" method="post" style="display:inline">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="studentId" value="${student.id}">
                            <button type="submit" name="status" value="APPROVED" 
                                    class="action-btn approve-btn"
                                    <c:if test="${student.status == 'APPROVED'}">disabled</c:if>>
                                Approve
                            </button>
                            <button type="submit" name="status" value="REJECTED" 
                                    class="action-btn reject-btn"
                                    <c:if test="${student.status == 'REJECTED'}">disabled</c:if>>
                                Reject
                            </button>
                        </form>
                        <!-- Edit button as a link -->
                        <form action="edit-student" method="get" style="display:inline;">
                            <input type="hidden" name="id" value="${student.id}" />
                            <button type="submit" class="action-btn" style="background-color:#2196F3; color:white;">
                                Edit
                            </button>
                        </form>        
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>