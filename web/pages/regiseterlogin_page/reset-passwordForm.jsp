<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
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
      .toggle-icon {
        position: absolute;
        top: 50%;
        right: 12px;
        transform: translateY(-50%);
        cursor: pointer;
        color: #ccc;
        font-size: 18px;
        z-index: 2;
      }

      .form-control::placeholder {
        color: rgba(255, 255, 255, 0.6);
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

      @media (max-width: 576px) {
        .role-toggle-wrapper {
          position: static;
          justify-content: center;
          margin-bottom: 10px;
        }
      }
    </style>
  </head>

  <body>
    <div class="container-scroller">
      <div class="container-fluid page-body-wrapper full-page-wrapper">
        <div class="row w-100 m-0">
          <div class="content-wrapper full-page-wrapper d-flex align-items-center auth login-bg">
            <div class="card col-lg-4 mx-auto position-relative">
              <div class="card-body px-5 py-5">
                <h3 class="card-title text-center mb-3">Reset Password</h3>
                <p class="text-muted text-center mb-4">Set a New Password for your Account</p>

                <!-- Show server-side success/error -->
                <c:if test="${not empty message}">
                  <div style="color: red; text-align: center; margin-bottom: 15px;">
                    <c:out value="${message}"/>
                  </div>
                </c:if>

                <form id="resetForm" action="<%= request.getContextPath() %>/ResetPasswordServlet" method="post" onsubmit="return validateForm()">
                  <input type="hidden" name="email" value="${param.email}">
                  <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <div class="position-relative">
                      <input type="password" name="newPassword" style="color: aliceblue; padding-right: 40px;" class="form-control p_input" id="newPassword" placeholder="Enter your New Password" oninput="validatePasswords()">
                      <i class="mdi mdi-eye toggle-icon" onclick="togglePassword('newPassword', this)"></i>
                    </div>
                    <small id="newPasswordMsg" class="text-danger d-block mt-1"></small>
                  </div>

                  <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="position-relative">
                      <input type="password" name="password" style="color: aliceblue; padding-right: 40px;" class="form-control p_input" id="confirmPassword" placeholder="Confirm Your Password" oninput="validatePasswords()">
                      <i class="mdi mdi-eye toggle-icon" onclick="togglePassword('confirmPassword', this)"></i>
                    </div>
                    <small id="confirmPasswordMsg" class="text-danger d-block mt-1"></small>
                  </div>

                  <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-block enter-btn" id="submitBtn" disabled>Reset Password</button>
                  </div>
                  <p class="sign-up">Don't have an Account? <a href="register.jsp"> Sign Up</a></p>
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

    <!-- Show/Hide Password + Validation Script -->
    <script>
      function togglePassword(inputId, icon) {
        const input = document.getElementById(inputId);
        const isPassword = input.type === "password";
        input.type = isPassword ? "text" : "password";
        icon.classList.toggle("mdi-eye");
        icon.classList.toggle("mdi-eye-off");
      }

      function validatePasswords() {
        const newPass = document.getElementById("newPassword").value;
        const confirmPass = document.getElementById("confirmPassword").value;
        const newPassMsg = document.getElementById("newPasswordMsg");
        const confirmPassMsg = document.getElementById("confirmPasswordMsg");
        const submitBtn = document.getElementById("submitBtn");

        let isValid = true;

        newPassMsg.textContent = "";
        confirmPassMsg.textContent = "";

        if (newPass.length < 6) {
          newPassMsg.textContent = "Password must be at least 6 characters.";
          isValid = false;
        }

        if (newPass !== confirmPass) {
          confirmPassMsg.textContent = "Passwords do not match.";
          isValid = false;
        }

        submitBtn.disabled = !isValid;
      }

      function validateForm() {
        validatePasswords();
        return !document.getElementById("submitBtn").disabled;
      }
    </script>
  </body>
</html>
