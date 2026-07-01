    
<%@ page import="java.util.List" %>
<%@ page import="mypackage.Course" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="mypackage.Event" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ page import="java.sql.SQLException" %>
<%
// Load data if coming directly to JSP for Courses
if (request.getAttribute("courses") == null) {
    try {
        DAO courseDAO = new DAO();
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }
}
%>

<%
// Load data if coming directly to JSP for Events
try {
    DAO EventDAO = new DAO();
    List<Event> event = EventDAO.getAllEvents();
    request.setAttribute("Event", event);
} catch (SQLException e) {
    request.setAttribute("error", "Database error: " + e.getMessage());
}
%>

<%

        DAO dao = new DAO();
        int TotalStudents = dao.getTotalStudents();
        int TotalTeachers = dao.getTotalTeachers();
        int TotalCourse = dao.getTotalCourses();
        int TotalStudentApproved = dao.getTotalStudentsApproved();
        double SuccessStudentPersntage = ((double) TotalStudentApproved / TotalStudents) * 100;

%>
    <c:if test="${not empty error}">
        <script>alert("${error}");</script>
    </c:if>
        
<!DOCTYPE html>
<html lang="en">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="TemplateMo">
    <link href="https://fonts.googleapis.com/css?family=Poppins:100,200,300,400,500,600,700,800,900" rel="stylesheet">

    <title>CAMPORA University | Student Platform to success</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Additional CSS Files -->
    <script src="https://kit.fontawesome.com/fdf9e4b0ed.js" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="assets/css/fontawesome.css">
    <link rel="stylesheet" href="assets/css/templatemo-edu-meeting.css">
    <link rel="stylesheet" href="assets/css/owl.css">
    <link rel="stylesheet" href="assets/css/lightbox.css">
    <link rel="icon" type="image/svg+xml" href="assets/images/C Logo gold.svg?v=1.1" />

  </head>

<body>
    
    <!-- Alerts -->
    <c:if test="${not empty MessageSuccess }">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
 <script>
        document.addEventListener('DOMContentLoaded', function () {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: '${MessageSuccess}',
                confirmButtonColor: '#4CAF50',
                timer: 4995,
                timerProgressBar: true,
                showConfirmButton: false
            });
        });
    </script>

    <!-- Remove session attribute after use -->
    <c:remove var="MessageSuccess" scope="session"/>
    </c:if>

    <c:if test="${not empty MessageFailed}">
            <script>
        document.addEventListener('DOMContentLoaded', function () {
            Swal.fire({
                icon: 'error',
                title: 'Failed',
                text: '${MessageFailed}',
                confirmButtonColor: '#ef4444',
                timer: 4995,
                timerProgressBar: true
            });
        });
    </script>

    <!-- Remove session attribute after showing alert -->
    <c:remove var="MessageFailed" scope="session"/>
    </c:if>
        
  <div class="fab-container" id="fabContainer">
    <div class="fab-actions">
      
        <a href="pages/regiseterlogin_page/LoginForm.jsp">
        <div class="fab-action" title="Registeration Page">
          <i class="fa-regular fa-user"></i>
        </div></a>
        
        <a href="pages/regiseterlogin_page/Student_registration.jsp"> 
          <div class="fab-action" title="Login Page">
            <i class="fa-solid fa-up-right-from-square"></i>        </div></a>

      <a href="#contact">
        <div class="fab-action" title="Contact Page">
          <i class="fa-regular fa-envelope"></i>
        </div></a>

    </div>
    <div class="fab" id="mainFab">+</div>
  </div>

  <!-- ***** Header Area Start ***** -->
  <header class="header-area header-sticky">
      <div class="container">
          <div class="row">
              <div class="col-12">
                  <nav class="main-nav">
                      <!-- ***** Logo Start ***** -->
                      <a href="index.jsp" class="logo" style="color: #f5a425;">
                          Campora
                      </a>
                      <!-- ***** Logo End ***** -->
                      <!-- ***** Menu Start ***** -->
                      <ul class="nav">
                          <li class="scroll-to-section"><a href="#top" class="active">Home</a></li>
                          <li class="scroll-to-section"><a href="#events">Events</a></li> 
                          <!-- <li class="has-sub">
                            <a href="javascript:void(0)">Pages</a>
                            <ul class="sub-menu">
                              <li><a href="meetings.jsp">Upcoming Courses</a></li>
                              <li><a href="meeting-details.jsp">Course Details</a></li>
                            </ul>
                          </li> -->
                          <li class="scroll-to-section"><a href="#faq">FAQ</a></li>
                          <li class="scroll-to-section"><a href="#courses">Courses</a></li> 
                          <li class="scroll-to-section"><a href="#about">About</a></li> 
                          <li class="scroll-to-section"><a href="#contact">Contact Us</a></li> 
                          <li class=""><a href="LoginForm.jsp" class="btn-login">Login Now</a></li>
                      </ul>        
                      <a class='menu-trigger'>
                          <span>Menu</span>
                      </a>
                      <!-- ***** Menu End ***** -->
                  </nav>
              </div>
          </div>
      </div>
  </header>
  <!-- ***** Header Area End ***** -->

  <!-- ***** Main Banner Area Start ***** -->
  <section class="section main-banner" id="top" data-section="section1">
    <video autoplay muted loop id="bg-video">
      <source src="assets/images/course-video.mp4" type="video/mp4" />
    </video>
  
    <div class="video-overlay header-text">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="caption">
              <!-- <h6>Hello Students</h6> -->
              <h2 style="color: #f5a425">Welcome to Campora</h2>
              <p>
                Empowering minds, shaping futures. Explore our world-class
                programs, experienced faculty, vibrant campus life, and a
                commitment to excellence in education and innovation. Start your
                journey with us today!
              </p>
  
              <!-- Two buttons side by side -->
              <div class="d-flex gap-3">
                <div class="main-button-red">
                  <div class="scroll-to-section">
                    <a href="#contact">Contact us</a>
                  </div>
                </div>
                <div class="main-button-red">
                  <div class="scroll-to-section">
                    <a href="#faq">Apply now</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  
  <!-- ***** Main Banner Area End ***** -->

  <section class="services">
    <div class="container">
      <div class="row">
        <div class="col-lg-12">
          <div class="owl-service-item owl-carousel">
          
            <div class="item">
              <div class="icon">
                <img src="assets/images/service-icon-01.png" alt="">
              </div>
              <div class="down-content">
                <h4>Best Education</h4>
                <p>We provide the best education through expert faculty, modern facilities, and a focused learning environment.</p>
              </div>
            </div>
            
            <div class="item">
              <div class="icon">
                <img src="assets/images/service-icon-02.png" alt="">
              </div>
              <div class="down-content">
                <h4>Best Teachers</h4>
                <p>Our college is proud to have the best teachers who are experienced and passionate towards success.</p>
              </div>
            </div>
            
            <div class="item">
              <div class="icon">
                <img src="assets/images/service-icon-03.png" alt="">
              </div>
              <div class="down-content">
                <h4>Best Students</h4>
                <p>Our college is home to the best students,
                  who are innovative, and committed to both academically and socially.</p>
              </div>
            </div>
            
            <div class="item">
              <div class="icon">
                <img src="assets/images/service-icon-02.png" alt="">
              </div>
              <div class="down-content">
                <h4>Online Courses</h4>
                <p>Our online courses are designed for flexible, allowing students to study anytime, anywhere with expert support.</p>
              </div>
            </div>
            
            <div class="item">
              <div class="icon">
                <img src="assets/images/service-icon-03.png" alt="">
              </div>
              <div class="down-content">
                <h4>Best Networking</h4>
                <p>We offer the best networking opportunities through industry connections and alumni engagement.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
<!--  <style>
      .down-content {
  display: flex;
  align-items: flex-start;
}

.down-content .date {
  margin-right: 15px;
  min-width: 60px;
}

.down-content .event-text h4 {
  margin: 0 0 5px;
}

.down-content .event-text p {
  margin: 0;
}

      </style> -->
      
  <section class="upcoming-meetings" id="events">
    <div class="container">
      <div class="row">
        <div class="col-lg-12">
          <div class="section-heading">
            <h2>Upcoming Events</h2>
          </div>
        </div>
        <div class="col-lg-4">
          <div class="categories">
            <h4>Events Categories</h4>
            <ul>
              <li><a href="#" class="filter-link" data-filter="Educational">Educational Events</a></li>
              <li><a href="#" class="filter-link" data-filter="Social">Social Events</a></li>
              <li><a href="#" class="filter-link" data-filter="Workshop">Skills & Workshops</a></li>
              <li><a href="#" class="filter-link" data-filter="Sports">Sports and Fitness</a></li>
              <li><a href="#" class="filter-link" data-filter="Tech">Technology Fests</a></li>
              <br>
              <li><a href="#" class="filter-link" data-filter="all">Show All</a></li>
            </ul>
            <div class="main-button-red">
              <a href="events.jsp">All Upcoming Events</a>
            </div>
          </div>
        </div>

        <div class="col-lg-8">
          <div class="row">
            <c:forEach var="event" items="${Event}">
              <div class="col-lg-6">
                <div class="meeting-item" data-category="${event.category}">
                  <div class="thumb">
                    <div class="price">
                    <span>&#8377; ${event.price}</span>
                    </div>
                    <c:if test="${not empty event.imageBase64}">
                    <a>
                        <img src="data:image/jpeg;base64,${event.imageBase64}" alt="Event Image" />
                    </a>
                    </c:if>
                  </div>

                  <div class="down-content" style="display: flex; align-items: flex-start;">
                    <div class="date" style="margin-right: 15px; min-width: 60px;">
                      <h6>
                        <fmt:formatDate value="${event.date}" pattern="MMM" />
                        <span><fmt:formatDate value="${event.date}" pattern="dd" /></span>
                      </h6>
                    </div>
                    <div class="event-text">
                      <a><h4 style="margin: 0 0 5px;">${event.title}</h4></a>
                      <p style="margin: 0;">${event.description}</p>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>

          </div>
          
          <div class="col-lg-12">
            <div class="pagination-custom text-center">
              <ul class="pagination justify-content-center" id="pagination">
                <li class="page-item"><a class="page-link" href="#" data-page="1">1</a></li>
                <li class="page-item active"><a class="page-link" href="#" data-page="2">2</a></li>
                <li class="page-item"><a class="page-link" href="#" data-page="3">3</a></li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const filterLinks = document.querySelectorAll(".filter-link");
  
      filterLinks.forEach(link => {
        link.addEventListener("click", function (e) {
          e.preventDefault();
  
          // Remove 'active' from all links
          filterLinks.forEach(link => link.classList.remove("active"));
  
          // Add 'active' to clicked link
          this.classList.add("active");
  
          // Optional: filter logic based on data-filter can go here
          const category = this.getAttribute("data-filter");
          const items = document.querySelectorAll(".meeting-item");
  
          items.forEach(item => {
            if (category === "all" || item.getAttribute("data-category") === category) {
              item.style.display = "block";
            } else {
              item.style.display = "none";
            }
          });
        });
      });
    });
  </script>
  

  <section class="apply-now" id="faq">
    <div class="container">
      <div class="row">
        <div class="col-lg-6 align-self-center">
          <div class="row">
            <div class="col-lg-12">
              <div class="item">
                <h3 style="color: #f5a425;">Apply For Admission Now</h3>
                <p>Take the first step towards your future! Apply for admissions now and join a community of aspiring leaders and innovators.</p>
                <div class="main-button-red">
                  <div ><a href="pages/regiseterlogin_page/Student_registration.jsp">Apply Now</a></div>
              </div>
              </div>
            </div>
            <div class="col-lg-12">
              <div class="item">
                <h3 style="color: #f5a425;">Contact Us For Any Queries</h3>
                <p>We're here to help! Please reach out with any questions you may have about our programs, admissions process, or campus life.</p>
                <div class="main-button-red">
                  <div class="scroll-to-section"><a href="#contact">Contact Us</a></div>
              </div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-6">
          <div class="accordions">
              <article class="accordion">
                  <div class="accordion-head">
                      <span>What programs and courses does the college offer?</span>
                      <span class="icon">
                          <i class="icon fa fa-chevron-right"></i>
                      </span>
                  </div>
                  <div class="accordion-body">
                      <div class="content">
                          <p>We provide various courses about undergraduate, postgraduate, diploma, 
                            and certificate courses across various departments. 
                            You can find detail information in the <a rel="nofollow" href="courses.jsp" target="_blank">Courses section</a></p>
                      </div>
                  </div>
              </article>
              <article class="accordion">
                  <div class="accordion-head">
                      <span>What is the admission process and eligibility criteria?</span>
                      <span class="icon">
                          <i class="icon fa fa-chevron-right"></i>
                      </span>
                  </div>
                  <div class="accordion-body">
                      <div class="content">
                          <p>You can take admission at our University by just filling the basic registration form at <a rel="nofollow" href="pages/regiseterlogin_page/Student_registration.jsp" target="_blank">Registration Form</a></p>
                      </div>
                  </div>
              </article>
              <article class="accordion">
                  <div class="accordion-head">
                      <span>Is the college affiliated and are the courses recognized?</span>
                      <span class="icon">
                          <i class="icon fa fa-chevron-right"></i>
                      </span>
                  </div>
                  <div class="accordion-body">
                      <div class="content">
                          <p>Yes, the college is affiliated and approved by Gov Regulatory Body AICTE and UGC, ensuring recognized qualifications.</p>
                      </div>
                  </div>
              </article>
              <article class="accordion last-accordion">
                  <div class="accordion-head">
                      <span>Does the college offer good placement records?</span>
                      <span class="icon">
                          <i class="icon fa fa-chevron-right"></i>
                      </span>
                  </div>
                  <div class="accordion-body">
                      <div class="content">
                          <p>Yes, our college is well known recognized for our placements. We have various companies like Google, Microsoft, Ola Electric, and many more.</p>
                      </div>
                  </div>
              </article>
          </div>
      </div>
      
      <!-- Include jQuery -->
      <script>
  // Select all accordion heads
  const accordionHeads = document.querySelectorAll(".accordion-head");

  accordionHeads.forEach(head => {
    head.addEventListener("click", () => {
      const parent = head.parentElement;

      // Close any open accordion except the one clicked
      document.querySelectorAll(".accordion").forEach(acc => {
        if (acc !== parent) {
          acc.classList.remove("active");
        }
      });

      // Toggle active state
      parent.classList.toggle("active");
    });
  });
</script>
<style>
    /* Reset unwanted duplicate icon style */
.accordion-head .icon i {
  font-family: "FontAwesome";
  margin-left: 8px;
  transition: transform 0.3s ease;
}

/* Basic accordion styling */
.accordions {
  border: 1px solid #ddd;
  border-radius: 6px;
  overflow: hidden;
}

.accordion {
  border-bottom: 1px solid #ddd;
}

.accordion:last-child {
  border-bottom: none;
}

/* Head (clickable) */
.accordion-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  padding: 12px 16px;
  background: #f8f8f8;
  font-weight: 500;
}

/* Body (hidden by default) */
.accordion-body {
  display: none;
  padding: 12px 16px;
  background: #fff;
}

/* When active, show body */
.accordion.active .accordion-body {
  display: block;
}

/* Rotate chevron when open */
.accordion.active .icon i {
/*  transform: rotate(90deg);*/
}
    </style>
      
      <script>
         const fab = document.getElementById('mainFab');
    const container = document.getElementById('fabContainer');

    fab.addEventListener('click', () => {
      container.classList.toggle('open');
      fab.style.transform = container.classList.contains('open') ? 'rotate(45deg)' : 'rotate(0deg)';
    });

        $(document).ready(function() {
          $('.accordion-head').click(function() {
            var $accordion = $(this).closest('.accordion');
            var $accordionBody = $accordion.find('.accordion-body');
            var $icon = $(this).find('.icon i');
      
            // If this accordion is already open
            if ($accordionBody.is(':visible')) {
              $accordionBody.slideUp();
              $icon.removeClass('fa-chevron-down').addClass('fa-chevron-right');
            } else {
              // Close all other accordions
              $('.accordion-body').slideUp();
              $('.accordion-head .icon i').removeClass('fa-chevron-down').addClass('fa-chevron-right');
      
              // Open the clicked one
              $accordionBody.slideDown();
              $icon.removeClass('fa-chevron-right').addClass('fa-chevron-down');
            }
          });
        });
      </script>
      
      
      <style>
        
          /* Accordion Styling */

      
          /* Optional: Add a hover effect to make it interactive */
          /* .accordion-head:hover {
              border-radius: 20px;
              background-color: #f0f0f0;
          } */

            /* Container for the FAB and actions */
    .fab-container {
      position: fixed;
      bottom: 20px;
      right: 20px;
      display: flex;
      flex-direction: column;
      align-items: center;
      z-index: 1000;
      transition: right 0.3s ease, left 0.3s ease;
    }

    /* Center FAB on mobile */
    @media (max-width: 600px) {
      .fab-container {
        left: 50%;
        right: auto;
        transform: translateX(-50%);
      }
    }

    /* Main FAB button */
    .fab {
      background-color: #f5a425;
      width: 56px;
      height: 56px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 24px;
      cursor: pointer;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
      transition: transform 0.3s ease;
    }

    /* Action buttons */
    .fab-actions {
      color: white;
      display: flex;
      flex-direction: column;
      align-items: center;
      margin-bottom: 10px;
      opacity: 0;
      transform: scale(0);
      transition: all 0.3s ease;
      pointer-events: none;
    }

    .fab-container.open .fab-actions {
      opacity: 1;
      transform: scale(1);
      pointer-events: auto;
    }

    .fab-action {
      background-color: #a12c2f;
      border: 0.5px solid #f5a425;
      width: 48px;
      height: 48px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 20px;
      margin: 6px 0;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      cursor: pointer;
      transition: transform 0.2s ease;
    }

    .fab-action i {
  font-size: 1.1rem;
  color: white; 
  /* color: #f5a425; Optional: change this if needed */
  transition: transform 0.3s ease;
}


    .fab-action:hover {
      transform: scale(1.1);
    }
          
          .icon i {
          font-size: 1.2rem;
          color: #f5a425;
          transition: transform 0.3s ease;
          }
          
      </style>
      
      </div>
    </div>
  </section>

  <section class="our-courses" id="courses">
    <div class="container">
      <div class="row">
        <div class="col-lg-12">
          <div class="section-heading">
            <h2>Our Popular Courses</h2>
          </div>
        </div>
        <div class="col-lg-12">
          <div class="owl-courses-item owl-carousel owl-loaded owl-drag">
           <c:forEach var="course" items="${courses}">
            <div class="item">
             <c:if test="${not empty course.img}">
                <img src="data:image/jpeg;base64,${course.getImageBase64()}" 
                    class="course-img" 
                    alt="${course.name}">
             </c:if> 
               <div class="down-content">
                <h4>${course.name}</h4>
                <div class="info">
                  <div class="row">
                    <div class="col-8">
                      <c:set var="rating" value="${course.star}" />
                     <ul style="list-style: none; padding: 0; margin: 0; display: flex;">

                        <!-- Star 1 -->
                        <c:choose>
                            <c:when test="${rating >= 1}">
                                <li style="color: #f5c518;"><i class="fas fa-star"></i></li>
                        </c:when>
                        <c:when test="${rating >= 0.5}">
                                <li style="color: #f5c518;"><i class="fas fa-star-half-alt"></i></li>
                        </c:when>
                        <c:otherwise>
                                <li style="color: #ccc;"><i class="far fa-star"></i></li>
                        </c:otherwise>
                        </c:choose>

                        <!-- Star 2 -->
                        <c:choose>
                        <c:when test="${rating >= 2}">
                            <li style="color: #f5c518;"><i class="fas fa-star"></i></li>
                        </c:when>
                        <c:when test="${rating >= 1.5}">
                            <li style="color: #f5c518;"><i class="fas fa-star-half-alt"></i></li>
                        </c:when>
                        <c:otherwise>
                            <li style="color: #ccc;"><i class="far fa-star"></i></li>
                        </c:otherwise>
                        </c:choose>

                        <!-- Star 3 -->
                        <c:choose>
                        <c:when test="${rating >= 3}">
                            <li style="color: #f5c518;"><i class="fas fa-star"></i></li>
                        </c:when>
                        <c:when test="${rating >= 2.5}">
                            <li style="color: #f5c518;"><i class="fas fa-star-half-alt"></i></li>
                        </c:when>
                        <c:otherwise>
                            <li style="color: #ccc;"><i class="far fa-star"></i></li>
                        </c:otherwise>
                        </c:choose>

                        <!-- Star 4 -->
                        <c:choose>
                        <c:when test="${rating >= 4}">
                            <li style="color: #f5c518;"><i class="fas fa-star"></i></li>
                        </c:when>
                        <c:when test="${rating >= 3.5}">
                            <li style="color: #f5c518;"><i class="fas fa-star-half-alt"></i></li>
                        </c:when>
                        <c:otherwise>
                            <li style="color: #ccc;"><i class="far fa-star"></i></li>
                        </c:otherwise>
                        </c:choose>

                        <!-- Star 5 -->
                        <c:choose>
                        <c:when test="${rating >= 5}">
                            <li style="color: #f5c518;"><i class="fas fa-star"></i></li>
                        </c:when>
                        <c:when test="${rating >= 4.5}">
                            <li style="color: #f5c518;"><i class="fas fa-star-half-alt"></i></li>
                        </c:when>
                        <c:otherwise>
                            <li style="color: #ccc;"><i class="far fa-star"></i></li>
                        </c:otherwise>
                        </c:choose>

                     </ul>

                    </div>
                    <div class="col-4">
                       <span>${course.fees}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
           </c:forEach>
          </div>         
          <div class="main-button-red text-end mt-4">
            <a href="courses.jsp" class="btn btn-danger">All Upcoming Courses</a>
          </div> 
        </div>
      </div>
    </div>
  </section>

  <section class="our-facts" id="about">
    <div class="container">
      <div class="row">
        <div class="col-lg-6">
          <div class="row">
            <div class="col-lg-12">
              <h2>A Few Facts About Our University</h2>
            </div>
            <div class="col-lg-6">
              <div class="row">
                <div class="col-12">
                  <div class="count-area-content percentage">
                    <div class="count-digit"><%= String.format("%.2f", SuccessStudentPersntage) %></div>
                    <div class="count-title">Succesed Students</div>
                  </div>
                </div>
                <div class="col-12">
                  <div class="count-area-content">
                    <div class="count-digit"><%= TotalTeachers %></div>
                    <div class="count-title">Current Teachers</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-lg-6">
              <div class="row">
                <div class="col-12">
                  <div class="count-area-content new-students">
                    <div class="count-digit"><%= TotalStudents %></div>
                    <div class="count-title">All Students</div>
                  </div>
                </div> 
                <div class="col-12">
                  <div class="count-area-content">
                    <div class="count-digit"><%= TotalCourse %></div>
                    <div class="count-title">Courses</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div> 
        <div class="col-lg-6 align-self-center">
          <div class="video">
            <!-- <iframe width="500" height="315" style="border-radius: 20px;" src="https://www.youtube.com/embed/0Izfzdwg9kc?si=VGxh1Q_sxidUkT5I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->
            <a href="https://www.youtube.com/embed/MsNAzroPKvU?si=htiGzVFM7fXeZ0mK&amp" target="_blank"><img src="assets/images/play-icon.png" alt=""></a>
            <!-- <a href="https://www.youtube.com/embed/0Izfzdwg9kc?si=VGxh1Q_sxidUkT5I" target="_blank"><img src="assets/images/play-icon.png" alt=""></a> -->
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="contact-us" id="contact">
    <div class="container">
      <div class="row">
        <div class="col-lg-9 align-self-center">
          <div class="row">
            <div class="col-lg-12">
              <form id="contact" action="MessageServlet" method="post">
                <div class="row">
                  <div class="col-lg-12">
                    <h2>Let's get in touch</h2>
                  </div>
                  <div class="col-lg-4">
                    <fieldset>
                      <input name="fullName" type="text" id="name" placeholder="Your Full Name*" required="">
                    </fieldset>
                  </div>
                  <div class="col-lg-4">
                    <fieldset>
                    <input name="email" type="text" id="email" pattern="[^ @]*@[^ @]*" placeholder="Your Email Address" required="">
                  </fieldset>
                  </div>
                  <div class="col-lg-4">
                    <fieldset>
                      <input name="subject" type="text" id="subject" placeholder="Your Subject of Message" required="">
                    </fieldset>
                  </div>
                  <div class="col-lg-12">
                    <fieldset>
                      <textarea name="message" type="text" class="form-control" id="message" placeholder="Your Message here" required=""></textarea>
                    </fieldset>
                  </div>
                  <div class="col-lg-12">
                    <fieldset>
                        <button type="submit" id="form-submit" class="button">Submit MESSAGE NOW</button>
                    </fieldset>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
        <div class="col-lg-3">
          <div class="right-info">
            <ul>
              <li>
                <h6>Phone Number</h6>
                <span>70968 84894</span>
              </li>
              <li>
                <h6>Email Address</h6>
                <span>kartiksirabatti009@gmail.com</span>
              </li>
              <li>
                <h6>Street Address</h6>
                <span>Dindoli , Surat, Gujarat - 382420</span>
              </li>
              <li>
                <h6>Website URL</h6>
                <span>Carentily no</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="footer">
      <p>Copyright 2025 Compora University.<br> All Rights Reserved.</p>
    </div>
  </section>

  <!-- Scripts -->
  <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <script src="assets/js/isotope.min.js"></script>
    <script src="assets/js/owl-carousel.js"></script>
    <script src="assets/js/lightbox.js"></script>
    <script src="assets/js/tabs.js"></script>
    <script src="assets/js/video.js"></script>
    <script src="assets/js/slick-slider.js"></script>
    <script src="assets/js/custom.js"></script>
    <script>
        //according to loftblog tut
        $('.nav li:first').addClass('active');

        var showSection = function showSection(section, isAnimate) {
          var
          direction = section.replace(/#/, ''),
          reqSection = $('.section').filter('[data-section="' + direction + '"]'),
          reqSectionPos = reqSection.offset().top - 0;

          if (isAnimate) {
            $('body, html').animate({
              scrollTop: reqSectionPos },
            800);
          } else {
            $('body, html').scrollTop(reqSectionPos);
          }

        };

        var checkSection = function checkSection() {
          $('.section').each(function () {
            var
            $this = $(this),
            topEdge = $this.offset().top - 80,
            bottomEdge = topEdge + $this.height(),
            wScroll = $(window).scrollTop();
            if (topEdge < wScroll && bottomEdge > wScroll) {
              var
              currentId = $this.data('section'),
              reqLink = $('a').filter('[href*=\\#' + currentId + ']');
              reqLink.closest('li').addClass('active').
              siblings().removeClass('active');
            }
          });
        };

        $('.main-menu, .responsive-menu, .scroll-to-section').on('click', 'a', function (e) {
          e.preventDefault();
          showSection($(this).attr('href'), true);
        });

        $(window).scroll(function () {
          checkSection();
        });
    </script>
</body>

</body>
</html>