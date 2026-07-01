<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Long otpGeneratedTime = (Long) session.getAttribute("otpGeneratedTime");
    long currentTime = System.currentTimeMillis();
    long otpValidDuration = 5 * 60 * 1000;
    long remainingTime = 0;

    if (otpGeneratedTime != null) {
        remainingTime = (otpGeneratedTime + otpValidDuration) - currentTime;
        if (remainingTime < 0) remainingTime = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>OTP Verification</title>
    <% String path =request.getContextPath(); %>
    <link rel="stylesheet" href="<%= path %>/assets/vendors/mdi/css/materialdesignicons.min.css" />
    <link rel="stylesheet" href="<%= path %>/assets/vendors/css/vendor.bundle.base.css" />
    <link rel="stylesheet" href="<%= path %>/assets/css/style.css" />
    <link rel="shortcut icon" href="<%= path %>/assets/images/favicon.png" />

    <style>
      .otp-input {
        width: 50px;
        height: 55px;
        text-align: center;
        font-size: 20px;
        font-weight: bold;
        background-color: #2c2e33;
        border: 1px solid #444;
        color: #fff;
        border-radius: 6px;
      }

      .otp-input:focus {
        outline: none;
        border-color: #0097e7;
        box-shadow: 0 0 0 2px rgba(0, 151, 231, 0.3);
      }

      .otp-wrapper {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 1.5rem;
      }

      .timer-text {
        text-align: center;
        font-size: 14px;
        color: #aaa;
        margin-top: -10px;
        margin-bottom: 15px;
      }

      @media (max-width: 576px) {
        .otp-input {
          width: 42px;
          height: 48px;
          font-size: 18px;
        }

        .card {
          padding: 1.2rem !important;
        }

        h3.card-title {
          font-size: 1.2rem;
        }
      }
    </style>
  </head>
<body>
    <div class="container-scroller">
      <div class="container-fluid page-body-wrapper full-page-wrapper">
        <div class="row w-100 m-0">
          <div class="content-wrapper full-page-wrapper d-flex align-items-center auth login-bg">
            <div class="card col-lg-4 col-md-6 col-sm-10 mx-auto">
              <div class="card-body px-4 py-5">
                <h3 class="card-title text-center mb-3">OTP Verification</h3>
                <p class="text-muted text-center mb-4">Enter the 6 Digit-code sent to your email address</p>


<% if ("true".equals(request.getParameter("resent"))) { %>
    <p style="color: green;">OTP resent successfully.</p>
<% } %>

<% if (request.getAttribute("error") != null) { %>
    <p style="color: red;"><%= request.getAttribute("error") %></p>
<% } %>

            <form id="otp-form" action="${pageContext.request.contextPath}/VerifyOTPServlet" method="post">
                <input type="hidden" name="email" value="${param.email}">
                <input type="hidden" name="otp" id="otpCode">

                <div class="otp-wrapper">
                    <input type="text" maxlength="1" class="otp-input" data-index="1" />
                    <input type="text" maxlength="1" class="otp-input" data-index="2" />
                    <input type="text" maxlength="1" class="otp-input" data-index="3" />
                    <input type="text" maxlength="1" class="otp-input" data-index="4" />
                    <input type="text" maxlength="1" class="otp-input" data-index="5" />
                    <input type="text" maxlength="1" class="otp-input" data-index="6" />
                </div>

                 <!-- Countdown Timer -->
                  <div class="timer-text">
                    <small>Code expires in <span id="timer">5:00</span></small>
                  </div>

                  <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-block enter-btn w-100">Verify Account</button>
                  </div>
            </form>

            <!-- Hidden resend form -->
            <form id="resendOtpForm" action="SendOTPServlet" method="post" style="display:none;">
                <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
            </form>
                <div class="text-center mt-3">
                  <small class="text-muted">Didn't receive code?</small>
                  <a href="#" class="text-primary font-weight-bold" id="resendLink" onclick="document.getElementById('resendOtpForm').submit(); return false;" > Resend OTP</a>
               </div>
             </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="<%= path %>/assets/vendors/js/vendor.bundle.base.js"></script>
    <script src="<%= path %>/assets/js/off-canvas.js"></script>
    <script src="<%= path %>/assets/js/hoverable-collapse.js"></script>
    <script src="<%= path %>/assets/js/misc.js"></script>

<script>
    const inputs = document.querySelectorAll('.otp-input');
    let otpValues = ['', '', '', '', '', ''];

    inputs.forEach((input, i) => {
        input.addEventListener('input', (e) => {
            if (e.target.value.match(/^\d$/)) { // Only allow digits
                otpValues[i] = e.target.value;
                if (i < inputs.length - 1) {
                    inputs[i + 1].focus();
                }
            } else {
                e.target.value = '';
            }
        });

        input.addEventListener('keydown', (e) => {
            if (e.key === 'Backspace' && !e.target.value && i > 0) {
                inputs[i - 1].focus();
            }
        });
    });

    document.getElementById("otp-form").addEventListener("submit", function(e) {
        const otp = otpValues.join('');
        if (otp.length !== 6) {
            alert("Please enter a complete 6-digit OTP code");
            e.preventDefault();
            return;
        }
        document.getElementById("otpCode").value = otp;
        console.log("Submitting OTP:", otp); // Debug log
    });
</script>
</body>
</html>
