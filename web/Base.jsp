<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.*" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>


<%
    DAO dao = new DAO();
    Admin admin = dao.getAdminByUsername((String) session.getAttribute("admin"));
    request.setAttribute("admin", admin);
    
    List<Message> unReadMessages = dao.getAllUreadMessages();

%>

<!DOCTYPE html>
<html lang="en">
<head>

    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
    <!-- Dynamic Title -->
    <title>
        <c:choose>
            <c:when test="${not empty pageTitle}">${pageTitle} - Coronoa Admin Panel</c:when>
            <c:otherwise>Coronoa Admin Panel</c:otherwise>
        </c:choose>
    </title>

    <!-- plugins:css -->
    
    <link rel="stylesheet" href="assets/mdi/materialdesignicons.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@mdi/font@7.2.96/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="assets/vendors/css/vendor.bundle.base.css">

    <!-- endinject -->
    <!-- Plugin css for this page -->
    <link rel="stylesheet" href="  assets/vendors/jvectormap/jquery-jvectormap.css">
    <link rel="stylesheet" href="assets/vendors/flag-icon-css/css/flag-icon.min.css">
    <link rel="stylesheet" href="  assets/vendors/owl-carousel-2/owl.carousel.min.css">
    <link rel="stylesheet" href="  assets/vendors/owl-carousel-2/owl.theme.default.min.css">

    <!-- End plugin css for this page -->
    <!-- inject:css -->
    <!-- endinject -->
    <!-- Layout styles -->
    <link rel="stylesheet" href="  assets/css/style.css">

    <!-- End layout styles -->
    <link rel="icon" type="image/svg+xml" href="assets/images/C Logo gold.svg?v=1.1" />
    <!-- Additional CSS for child pages -->
    <c:if test="${not empty additionalCSS}">
        <style>
        .form-control:focus {
            outline: none;
            border-color: #81d4fa;
            box-shadow: 0 0 5px rgba(129, 212, 250, 0.3);
        }
        </style>
        ${additionalCSS}
    </c:if>
</head>
<body>
    <div class="container-scroller">
        
      <!-- partial:partials/_sidebar.html -->
      <nav class="sidebar sidebar-offcanvas" id="sidebar">
        <div class="sidebar-brand-wrapper d-none d-lg-flex align-items-center justify-content-center fixed-top">
            <a class="sidebar-brand brand-logo" href="Admin_penal.jsp"><img src="  assets/images/Campora logo.svg" alt="logo" /></a>
            <a class="sidebar-brand brand-logo-mini" href="Admin_penal.jsp"><img src="  assets/images/logo-mini.svg" alt="logo" /></a>
        </div>
        <ul class="nav">
          <li class="nav-item profile">
            <div class="profile-desc">
              <div class="profile-pic" >
                <div class="count-indicator">
                    <a href="ViewAdmin.jsp?id=${admin.adminId}">
                    <img class="img-xs rounded-circle " src="data:image/jpeg;base64,${admin.imageBase64}" alt="">
                    </a>
                </div>
                <div class="profile-name">
                  <h5 class="mb-0 font-weight-normal">${admin.adminName}</h5>
                  <span>Principle</span>
                </div>
              </div>
              <a href="#" id="profile-dropdown" data-toggle="dropdown"><i class="mdi mdi-dots-vertical"></i></a>
              <div class="dropdown-menu dropdown-menu-right sidebar-dropdown preview-list" aria-labelledby="profile-dropdown">
                <a href="ViewAdmin.jsp?id=${admin.adminId}" class="dropdown-item preview-item">
                  <div class="preview-thumbnail">
                    <div class="preview-icon bg-dark rounded-circle">
                      <i class="mdi mdi-account-cog"></i>
                    </div>
                  </div>
                  <div class="preview-item-content">
                    <p class="preview-subject ellipsis mb-1 text-small">Account settings</p>
                  </div>
                </a>
                <div class="dropdown-divider"></div>
                <a href="EditAdminProfile.jsp?id=${admin.adminId}" class="dropdown-item preview-item">
                  <div class="preview-thumbnail">
                    <div class="preview-icon bg-dark rounded-circle">
                      <i class="mdi mdi-lock-reset"></i>
                    </div>
                  </div>
                  <div class="preview-item-content">
                    <p class="preview-subject ellipsis mb-1 text-small">Change Password</p>
                  </div>
                </a>
                <div class="dropdown-divider"></div>
                <a href="view_events.jsp" class="dropdown-item preview-item">
                  <div class="preview-thumbnail">
                    <div class="preview-icon bg-dark rounded-circle">
                      <i class="mdi mdi-calendar-today text-success"></i>
                    </div>
                  </div>
                  <div class="preview-item-content">
                    <p class="preview-subject ellipsis mb-1 text-small">Events list</p>
                  </div>
                </a>
              </div>
            </div>
          </li>
          <li class="nav-item nav-category">
            <span class="nav-link">Navigation</span>
          </li>
          <li class="nav-item menu-items">
              <a class="nav-link" href="universalSearchResults_1.jsp">
              <span class="menu-icon bg-dark">
                <i class="mdi mdi-magnify bg-dark"></i>
              </span>
              <span class="menu-title">Search</span>
            </a>
          </li>
          <li class="nav-item menu-items">
              <a class="nav-link active" href="Admin_penal.jsp">
              <span class="menu-icon bg-dark">
                <i class="mdi mdi-speedometer"></i>
              </span>
              <span class="menu-title">Dashboard</span>
            </a>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" data-toggle="collapse" href="#drop-student" aria-expanded="false" aria-controls="drop-student">
              <span class="menu-icon bg-dark">
                <i class="mdi mdi-school"></i>
              </span>
              <span class="menu-title">Students</span>
              <i class="menu-arrow"></i>            
            </a>
            <div class="collapse" id="drop-student">
              <ul class="nav flex-column sub-menu">
                  <li class="nav-item"> <a class="nav-link" href="add_students.jsp">Add Students</a></li>
                  <li class="nav-item"> <a class="nav-link" href="manage_students.jsp">Manage Students</a></li>
                  <li class="nav-item"> <a class="nav-link" href="view_students.jsp">View Students</a></li>
              </ul>
            </div>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" data-toggle="collapse" href="#drop-teachers" aria-expanded="false" aria-controls="drop-teachers">
              <span class="menu-icon bg-dark">
                <i class="mdi mdi-account-multiple"></i>
              </span>
              <span class="menu-title">Teachers</span>
              <i class="menu-arrow"></i>
            </a>
            <div class="collapse" id="drop-teachers">
              <ul class="nav flex-column sub-menu">
                  <li class="nav-item"> <a class="nav-link" href="add_teacher.jsp">Add Teachers</a></li>
                  <li class="nav-item"> <a class="nav-link" href="manage_teacher.jsp">Manage Teachers</a></li>
                <li class="nav-item"> <a class="nav-link" href="view_teacher.jsp">View Teacher</a></li>
              </ul>
            </div>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" data-toggle="collapse" href="#drop-events" aria-expanded="false" aria-controls="drop-course">
              <span class="menu-icon bg-dark">
                <i class="mdi mdi-calendar-check"></i>
              </span>
              <span class="menu-title">Events</span>
              <i class="menu-arrow"></i>
            </a>
            <div class="collapse" id="drop-events">
              <ul class="nav flex-column sub-menu">
                  <li class="nav-item"> <a class="nav-link" href="add_events.jsp">Add Events</a></li>
                  <li class="nav-item"> <a class="nav-link" href="manage_events.jsp">Manage Events</a></li>
                  <li class="nav-item"> <a class="nav-link" href="view_events.jsp">View Events</a></li>
              </ul>
            </div>
          </li>
          <li class="nav-item menu-items">
          <a class="nav-link" data-toggle="collapse" href="#drop-course" aria-expanded="false" aria-controls="drop-course">
            <span class="menu-icon bg-dark">
              <i class="mdi mdi-book-multiple"></i>
            </span>
            <span class="menu-title">Courses</span>
            <i class="menu-arrow"></i>
          </a>
          <div class="collapse" id="drop-course">
            <ul class="nav flex-column sub-menu">
                <li class="nav-item"> <a class="nav-link" href="add_courses.jsp">Add Courses</a></li>
                <li class="nav-item"> <a class="nav-link" href="manage_courses.jsp">Manage Courses</a></li>
                <li class="nav-item"> <a class="nav-link" href="view_courses.jsp">View Courses</a></li>
            </ul>
          </div>
        </li>
        <li class="nav-item menu-items">
            <a class="nav-link active" href="ViewAllMessage.jsp">
              <span class="menu-icon bg-dark">
                <i class="mdi mdi-email-outline"></i>
              </span>
              <span class="menu-title">Messages</span>
            </a>
          </li>
        </ul>
      </nav>

      <!-- partial -->
      <div class="container-fluid page-body-wrapper">

        <!-- partial:partials/_navbar.html -->
        <nav class="navbar p-0 fixed-top d-flex flex-row">
          <div class="navbar-brand-wrapper d-flex d-lg-none align-items-center justify-content-center">
              <a class="navbar-brand brand-logo-mini" href="Admin_penal.jsp"><img src="  assets/images/logo-mini.svg" alt="logo" /></a>
          </div>
          <div class="navbar-menu-wrapper flex-grow d-flex align-items-stretch">
            <button class="navbar-toggler navbar-toggler align-self-center" type="button" data-toggle="minimize">
              <span class="mdi mdi-menu"></span>
            </button>
            <ul class="navbar-nav w-100">
              <li class="nav-item w-100">
                <form class="nav-link mt-2 mt-md-0 d-none d-lg-flex search">
                    <input type="text" id="searchid" class="form-control bg-dark" placeholder="Search anyone, anything, anyimage, anycourse">
                </form>
                  <div style="display: none; max-width: 500px; margin: 0 auto; padding: 10px 0;"> 
                    <form id="hiddenSearchForm" action="${pageContext.request.contextPath}/UniversalSearchServlet" method="post">
                        <div style="width: 100%; display: flex;">
                            <input 
                                type="text" 
                                name="searchQuery" 
                                id="hiddenSearchInput"
                                placeholder="Search everything..." 
                                aria-label="Search"
                                style="height: 40px; border-radius: 20px 0 0 20px; border-right: none; flex: 1; padding: 0 10px;"
                            >
                            <button 
                                type="submit" 
                                style="height: 40px; border-radius: 0 20px 20px 0; padding: 0 20px; background-color: #0d6efd; color: white; border: none;">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                  </div>
                  <script>
                    document.getElementById('searchid').addEventListener('keydown', function(event) {
                        if (event.key === 'Enter') {
                            event.preventDefault();
                            const query = this.value.trim();
                            if (query) {
                                document.getElementById('hiddenSearchInput').value = query;
                                document.getElementById('hiddenSearchForm').submit();
                            }
                        }
                    });
                  </script>
              </li>
            </ul>
            <ul class="navbar-nav navbar-nav-right">
              <li class="nav-item dropdown d-none d-lg-block">
                <a class="nav-link btn btn-success create-new-button" id="createbuttonDropdown" data-toggle="dropdown" aria-expanded="true" href="#">+ Create New Entry</a>
                <div class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list" aria-labelledby="createbuttonDropdown">
                  <h6 class="p-3 mb-0">Register as: </h6>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item" href="add_students.jsp">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-account-outline text-primary"></i>
                      </div>
                    </div>
                    <div class="preview-item-content" >
                        <p class="preview-subject ellipsis mb-1" >Student</p>
                    </div>
                  </a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item " href="add_teacher.jsp">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-human-greeting text-info"></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p class="preview-subject ellipsis mb-1">Teacher</p>
                    </div>
                  </a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item" href="add_courses.jsp">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-book text-danger"></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p class="preview-subject ellipsis mb-1">Course</p>
                    </div>
                  </a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item" href="add_events.jsp">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-calendar-star "></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p class="preview-subject ellipsis mb-1">Events</p>
                    </div>
                  </a>   
                  <div class="dropdown-divider"></div>
                  <p class="p-3 mb-0 text-center">See all fields</p>
                </div>
              </li>
              <li class="nav-item nav-settings d-none d-lg-block dropdown">
                <a class="nav-link" id="manageDropdown" href="#" data-toggle="dropdown" aria-expanded="false">
                  <i class="mdi mdi-view-grid"></i>
                </a>
                <div class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list" aria-labelledby="manageDropdown">
                  <h6 class="p-3 mb-0">Manage Admins</h6>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item" href="view_events.jsp">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-calendar text-success"></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p class="preview-subject mb-1">Event today</p>
                      <p class="text-muted ellipsis mb-0"> Just a reminder event today</p>
                    </div>
                  </a>
                  <div class="dropdown-divider"></div>                  
                  <a class="dropdown-item preview-item" href="ViewAllAdmins.jsp">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-cog"></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p class="preview-subject mb-1">Settings</p>
                      <p class="text-muted ellipsis mb-0"> View all Admins </p>
                    </div>
                  </a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item" href="AddAdmin.jsp">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-link-variant text-warning"></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p class="preview-subject mb-1">Launch Admin</p>
                      <p class="text-muted ellipsis mb-0"> New admin wow! </p>
                    </div>
                  </a>
                  
                </div>
              </li>
            <li class="nav-item dropdown border-left">
             <a class="nav-link count-indicator dropdown-toggle" id="notificationDropdown" href="#" data-toggle="dropdown">
               <i class="mdi mdi-bell"></i>
               <c:if test="<%= unReadMessages != null && !unReadMessages.isEmpty() %>">
                 <span class="count bg-danger"><%= unReadMessages.size() %></span>
               </c:if>
             </a>
             <div class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list" aria-labelledby="notificationDropdown">
               <h6 class="p-3 mb-0">Notifications</h6>
               <div class="dropdown-divider"></div>

               <c:choose>
                 <c:when test="<%= unReadMessages == null || unReadMessages.isEmpty() %>">
                   <!-- Show this when there are no notifications -->
                   <div class="text-center p-4">
                     <i class="mdi mdi-bell-off-outline text-muted" style="font-size: 48px;"></i>
                     <p class="text-muted mt-2 mb-0">No new notifications</p>
                     <small class="text-muted">You're all caught up!</small>
                   </div>
                 </c:when>
                 <c:otherwise>
                   <!-- Show unread message notifications -->
                   <div class="dropdown-header">
                     <span class="text-primary font-weight-bold"><%= unReadMessages.size() %> unread message(s)</span>
                   </div>

                   <c:forEach var="msg" items="<%= unReadMessages %>" varStatus="loop" end="4">
                     <a class="dropdown-item preview-item" href="ViewAllMessage.jsp?messageId=${msg.getId()}">
                       <div class="preview-thumbnail">
                         <div class="preview-icon bg-dark rounded-circle">
                           <i class="mdi mdi-email text-warning"></i>
                         </div>
                       </div>
                       <div class="preview-item-content">
                         <p class="preview-subject mb-1">New Message from ${msg.getFullName()}</p>
                         <p class="text-muted ellipsis mb-0">${msg.getSubject()}</p>
                         <small class="text-muted"><fmt:formatDate value="${msg.getCreatedAt()}" pattern="MMM dd, yyyy hh:mm a"/></small>
                       </div>
                     </a>
                     <c:if test="${!loop.last}">
                       <div class="dropdown-divider"></div>
                     </c:if>
                   </c:forEach>

                   <c:if test="<%= unReadMessages.size() > 5 %>">
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item text-center text-primary" href="ViewAllMessage.jsp">
                       View all <%= unReadMessages.size() %> messages
                       <i class="mdi mdi-chevron-right"></i>
                     </a>
                   </c:if>
                 </c:otherwise>
               </c:choose>

             </div>
           </li>
              <li class="nav-item dropdown">
                <a class="nav-link" id="profileDropdown" href="#" data-toggle="dropdown">
                  <div class="navbar-profile">
                    <img class="img-xs rounded-circle" src="data:image/jpeg;base64,${admin.imageBase64}" alt="">
                    <p class="mb-0 d-none d-sm-block navbar-profile-name">${admin.adminName}</p>
                    <i class="mdi mdi-menu-down d-none d-sm-block"></i>
                  </div>
                </a>
                <div class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list" aria-labelledby="profileDropdown">
                  <h6 class="p-3 mb-0">Profile</h6>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item" href="ViewAdmin.jsp?id=${admin.adminId}">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-cog"></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p class="preview-subject mb-1">Settings</p>
                    </div>
                  </a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item preview-item" href="${pageContext.request.contextPath}/LogoutServlet">
                    <div class="preview-thumbnail">
                      <div class="preview-icon bg-dark rounded-circle">
                        <i class="mdi mdi-logout text-danger"></i>
                      </div>
                    </div>
                    <div class="preview-item-content">
                      <p>Log out</p>
                    </div>
                  </a>
                  <div class="dropdown-divider"></div>
                  <p class="p-3 mb-0 text-center">Advanced settings</p>
                </div>
              </li>
            </ul>
            <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
              <span class="mdi mdi-format-line-spacing"></span>
            </button>
          </div>
        </nav>

        <!-- partial -->
        <div class="main-panel">
          <div class="content-wrapper">
            <!-- Main content area that child pages will override -->
            <c:choose>
                <c:when test="${not empty pageContent}">
                    ${pageContent}
                </c:when>
                <c:otherwise>
                    <!-- Default content or error message -->
                    <div class="alert alert-warning">
                        No content provided for this page.
                    </div>
                </c:otherwise>
            </c:choose>
          </div>
          
          <!-- Footer -->
          <footer class="footer">
            <div class="d-sm-flex justify-content-center justify-content-sm-between">
              <span class="text-muted d-block text-center text-sm-left d-sm-inline-block">Copyright © Campora 2026</span>
              <span class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center"> 
                  Our 
                  <a href="#" target="_blank">
                      Front Page 
                  </a>
                  from 
                  <b>CORONA University</b>
              </span>
            </div>
          </footer>
        </div>
        <!-- main-panel ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>

    <!-- container-scroller -->

    <!-- plugins:js -->
    <script src="  assets/vendors/js/vendor.bundle.base.js"></script>
    <!-- endinject -->
    <!-- Plugin js for this page -->
    <script src="  assets/vendors/chart.js/Chart.min.js"></script>
    <script src="  assets/vendors/progressbar.js/progressbar.min.js"></script>
    <script src="  assets/vendors/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="  assets/vendors/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <script src="  assets/vendors/owl-carousel-2/owl.carousel.min.js"></script>
    <!-- End plugin js for this page -->
    <!-- inject:js -->
    <script src="  assets/js/alerts.js"></script>
    <script src="  assets/js/off-canvas.js"></script>
    <script src="  assets/js/hoverable-collapse.js"></script>
    <script src="  assets/js/misc.js"></script>
    <script src="  assets/js/settings.js"></script>
    <script src="  assets/js/todolist.js"></script>
    <!-- endinject -->
    <!-- Custom js for this page -->
    <script src="  assets/js/dashboard.js"></script>
    
    <!-- Additional scripts for child pages -->
    <script>
    // Function to update notification badge
    function updateNotificationBadge() {
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

    // If we're on ViewMessage.jsp, the message was just viewed
    // So we should update the notification count
    document.addEventListener('DOMContentLoaded', function() {
        // Check if we're on a message viewing page
        const currentPage = window.location.pathname;
        if (currentPage.includes('ViewMessage.jsp') || currentPage.includes('ViewAllMessage.jsp')) {
            // Badge will be updated on next page load
            console.log('Message viewing page - badge will update on refresh');
        }
    });
    </script>
    <c:if test="${not empty additionalScripts}">
        ${additionalScripts}
    </c:if>
    <!-- End custom js for this page -->
  </body>
</html>