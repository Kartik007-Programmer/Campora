<%-- 
    Document   : error
    Created on : Apr 11, 2025, 10:52:04 AM
    Author     : Kartik
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Error Page</title>
    <!-- plugins:css -->
    <link rel="stylesheet" href="../../assets/vendors/mdi/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="../../assets/vendors/css/vendor.bundle.base.css">
    <!-- endinject -->
    <!-- Layout styles -->
    <link rel="stylesheet" href="../../assets/css/style.css">
    <!-- End layout styles -->
    <link rel="shortcut icon" href="../../assets/images/favicon.png" />
    <style>
      <c:choose>
        <c:when test="${pageContext.errorData.statusCode == 404}">
          .error-page { background-color: #4b49ac; } /* Primary color for 404 */
        </c:when>
        <c:when test="${pageContext.errorData.statusCode == 500}">
          .error-page { background-color: #0d6efd; } /* Info color for 500 */
        </c:when>
        <c:otherwise>
          .error-page { background-color: #ff4444; } /* Default error color */
        </c:otherwise>
      </c:choose>
      
      /* Additional styles for error details */
      .error-details {
        margin-top: 20px;
        padding: 15px;
        background-color: rgba(255,255,255,0.1);
        border-radius: 5px;
        text-align: left;
      }
    </style>
  </head>
  <body>
    <div class="container-scroller">
      <div class="container-fluid page-body-wrapper full-page-wrapper">
        <div class="content-wrapper d-flex align-items-center text-center error-page">
          <div class="row flex-grow">
            <div class="col-lg-7 mx-auto text-white">
              <div class="row align-items-center d-flex flex-row">
                <div class="col-lg-6 text-lg-right pr-lg-4">
                  <h1 class="display-1 mb-0">
                    <c:choose>
                      <c:when test="${not empty pageContext.errorData.statusCode}">
                        ${pageContext.errorData.statusCode}
                      </c:when>
                      <c:otherwise>Error</c:otherwise>
                    </c:choose>
                  </h1>
                </div>
                <div class="col-lg-6 error-page-divider text-lg-left pl-lg-4">
                  <h2>SORRY!</h2>
                  <h3 class="font-weight-light">
                    <c:choose>
                      <c:when test="${pageContext.errorData.statusCode == 404}">
                        The page you're looking for was not found.
                      </c:when>
                      <c:when test="${pageContext.errorData.statusCode == 500}">
                        Internal server error!
                      </c:when>
                      <c:when test="${not empty error}">
                        ${error}
                      </c:when>
                      <c:otherwise>
                        An unexpected error occurred.
                      </c:otherwise>
                    </c:choose>
                  </h3>
                </div>
              </div>
              
              <!-- Error details section -->
              <c:if test="${not empty pageContext.exception or not empty error}">
                <div class="error-details">
                  <h4>Error Details:</h4>
                  <p>
                    <c:if test="${not empty pageContext.exception}">
                      <strong>Exception:</strong> ${pageContext.exception}<br/>
                      <c:forEach var="trace" items="${pageContext.exception.stackTrace}">
                        ${trace}<br/>
                      </c:forEach>
                    </c:if>
                    <c:if test="${not empty error and empty pageContext.exception}">
                      ${error}
                    </c:if>
                  </p>
                </div>
              </c:if>
              
              <div class="row mt-5">
                <div class="col-12 text-center mt-xl-2">
                  <a class="text-white font-weight-medium" href="../../index.html">Back to home</a>
                </div>
              </div>
              <div class="row mt-5">
                <div class="col-12 mt-xl-2">
                  <p class="text-white font-weight-medium text-center">Copyright &copy; 2025 All rights reserved.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- content-wrapper ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!-- container-scroller -->
    <!-- plugins:js -->
    <script src="../../assets/vendors/js/vendor.bundle.base.js"></script>
    <!-- endinject -->
    <!-- inject:js -->
    <script src="../../assets/js/off-canvas.js"></script>
    <script src="../../assets/js/hoverable-collapse.js"></script>
    <script src="../../assets/js/misc.js"></script>
    <script src="../../assets/js/settings.js"></script>
    <script src="../../assets/js/todolist.js"></script>
    <!-- endinject -->
  </body>
</html>