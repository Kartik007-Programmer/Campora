<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Corona Admin</title>

  <!-- plugins:css -->
  <link rel="stylesheet" href="../../assets/vendors/mdi/css/materialdesignicons.min.css">
  <link rel="stylesheet" href="../../assets/vendors/css/vendor.bundle.base.css">
  <!-- Layout styles -->
  <link rel="stylesheet" href="../../assets/css/style.css">
  <link rel="shortcut icon" href="../../assets/images/favicon.png" />
  

  <style>
    .role-toggle-wrapper {
      position: absolute;
      top: 15px;
      right: 15px;
      z-index: 10;
      background-color: #2c2e33;
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

    a {
      color: #2c2e33;
    }

    input[type="radio"] {
      accent-color: #0097e7;
    }

    @media (max-width: 576px) {
      .role-toggle-wrapper {
        position: static;
        justify-content: center;
        margin-bottom: 10px;
      }
    }

    .auth .card {
      background-color: #191c24;
      border: none;
      box-shadow: 0 0 12px rgba(0, 0, 0, 0.3);
    }

    .auth .form-control {
      background-color: rgba(255, 255, 255, 0.05);
      color: #fff;
    }

    .auth .form-control::placeholder {
      color: rgba(255, 255, 255, 0.6);
    }

    .auth .btn-primary {
      background-color: #0097e7;
      border: none;
      padding: 10px 25px;
      font-weight: 600;
    }

    .auth .btn-primary:hover {
      background-color: #007fc2;
    }

    .forgot-pass {
      color: #ccc;
      text-decoration: underline;
      font-size: 14px;
    }

    .action-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 25px;
    }

    @media (max-width: 576px) {
      .action-row {
        flex-direction: column-reverse;
        gap: 15px;
        text-align: center;
      }
    }
  </style>
</head>

<body>
  <div class="container-scroller">
    <div class="container-fluid page-body-wrapper full-page-wrapper">
      <div class="row w-100 m-0">
        <div class="content-wrapper full-page-wrapper d-flex align-items-center auth login-bg">
          <div class="card col-lg-4 col-md-6 col-sm-10 mx-auto position-relative">
            <div class="card-body px-5 py-5">
              <h3 class="card-title text-center mb-4">Forgot Password?</h3>

              <!-- Optional success/error message -->
              <c:if test="${not empty message}">
                <div style="color: red; text-align: center; margin-bottom: 15px;">
                  <c:out value="${message}"/>
                </div>
              </c:if>

              <form action="<%= request.getContextPath() %>/SendOTPServlet" method="post">
                <div class="form-group">
                  <label>Enter Your Email Address</label>
                  <input type="email" name="email" class="form-control p_input" placeholder="Enter your Email Address" required>
                </div>

                <div class="action-row">
                  <a href="LoginForm.jsp" class="forgot-pass">Go back to Login</a>
                  <button type="submit" class="btn btn-primary">Send OTP</button>
                </div>
              </form>

            </div>
          </div>
        </div>
        <!-- content-wrapper ends -->
      </div>
      <!-- row ends -->
    </div>
    <!-- page-body-wrapper ends -->
  </div>

  <!-- plugins:js -->
  <script src="../../assets/vendors/js/vendor.bundle.base.js"></script>
  <script src="../../assets/js/off-canvas.js"></script>
  <script src="../../assets/js/hoverable-collapse.js"></script>
  <script src="../../assets/js/misc.js"></script>
  <script src="../../assets/js/settings.js"></script>
  <script src="../../assets/js/todolist.js"></script>
</body>

</html>
