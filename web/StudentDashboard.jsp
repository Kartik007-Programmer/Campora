<%-- 
    Document   : StudentDashboard
    Created on : Jun 12, 2025, 12:35:24 PM
    Author     : Batch2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mypackage.Student" %>
<%@page import="mypackage.DAO" %>

<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader ("Expires", 0);

    if (session == null || session.getAttribute("student") == null) {
        RequestDispatcher rd = request.getRequestDispatcher("LoginForm.jsp");
        rd.forward(request, response);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1000px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .profile {
            display: flex;
            align-items: center;
        }
        .profile-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 20px;
            border: 3px solid #4CAF50;
        }
        .profile-info h2 {
            margin: 0;
            color: #333;
        }
        .profile-info p {
            margin: 5px 0;
            color: #666;
        }
        .status {
            padding: 10px 15px;
            border-radius: 20px;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 14px;
        }
        .status-pending {
            background-color: #FFF3CD;
            color: #856404;
        }
        .status-approved {
            background-color: #D4EDDA;
            color: #155724;
        }
        .status-rejected {
            background-color: #F8D7DA;
            color: #721C24;
        }
        .details {
            margin-top: 30px;
        }
        .details h3 {
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .details-table {
            width: 100%;
            border-collapse: collapse;
        }
        .details-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        .details-table tr:last-child td {
            border-bottom: none;
        }
        .details-table td:first-child {
            font-weight: bold;
            width: 30%;
            color: #555;
        }
        .logout-btn {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .logout-btn:hover {
            background-color: #d32f2f;
        }
        .address-section {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="profile">
                <% 
                    Student student = (Student) session.getAttribute("student");
                    String imgSrc = "";
                    if (student.getPhoto() != null && student.getPhoto().length > 0) {
                        imgSrc = "data:image/jpeg;base64," + student.getImageBase64();
                    } else {
                        imgSrc = "https://via.placeholder.com/100";
                    }
                %>
                <img src="<%= imgSrc %>" alt="Profile Image" class="profile-img">
                <div class="profile-info">
                    <h2><%= student.getFirstName() %> <%= student.getLastName() %></h2>
                    <p><%= student.getEmail() %></p>
                    <p>Registered on: <fmt:formatDate value="<%= student.getRegistrationDate() %>" pattern="dd-MMM-yyyy HH:mm" /></p>
                    <span class="status status-<%= student.getStatus().toLowerCase() %>">
                        <%= student.getStatus() %>
                    </span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">Logout</a>
        </div>
        
        <div class="details">
            <h3>Personal Details</h3>
            <table class="details-table">
                <tr>
                    <td>Application ID</td>
                    <td><%= student.getId() %></td>
                </tr>
                <tr>
                    <td>First Name</td>
                    <td><%= student.getFirstName() %></td>
                </tr>
                <tr>
                    <td>Last Name</td>
                    <td><%= student.getLastName() %></td>
                </tr>
                <tr>
                    <td>Course</td>
                    <td><%= student.getCourse() %></td>
                </tr>
                <tr>
                    <td>Qualification</td>
                    <td><%= student.getQualification() %></td>
                </tr>
                <tr>
                    <td>Date of Birth</td>
                    <td><fmt:formatDate value="<%= student.getDob() %>" pattern="dd-MMM-yyyy" /></td>
                </tr>
                <tr>
                    <td>Gender</td>
                    <td><%= student.getGender() %></td>
                </tr>
                <tr>
                    <td>Mobile Number</td>
                    <td><%= student.getMobile() %></td>
                </tr>
                <tr>
                    <td>Last Year Percentage</td>
                    <td><%= student.getLastYearPercentage() %>%</td>
                </tr>
                <tr>
                    <td>Application Status</td>
                    <td><%= student.getStatus() %></td>
                </tr>
                <tr>
                    <td>Processed Date</td>
                    <td>
                        <% if (student.getProcessedDate() != null) { %>
                            <fmt:formatDate value="<%= student.getProcessedDate() %>" pattern="dd-MMM-yyyy HH:mm" />
                        <% } else { %>
                            Not processed yet
                        <% } %>
                    </td>
                </tr>
            </table>
            
            <div class="address-section">
                <h3>Address Details</h3>
                <table class="details-table">
                    <tr>
                        <td>Address Line 1</td>
                        <td><%= student.getAddressLine1() %></td>
                    </tr>
                    <tr>
                        <td>Address Line 2</td>
                        <td><%= student.getAddressLine2() != null ? student.getAddressLine2() : "N/A" %></td>
                    </tr>
                    <tr>
                        <td>Landmark</td>
                        <td><%= student.getLandmark() != null ? student.getLandmark() : "N/A" %></td>
                    </tr>
                    <tr>
                        <td>Pincode</td>
                        <td><%= student.getPincode() %></td>
                    </tr>
                    <tr>
                        <td>City</td>
                        <td><%= student.getCity() %></td>
                    </tr>
                    <tr>
                        <td>State</td>
                        <td><%= student.getState() %></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</body>
</html>