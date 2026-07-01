<%@ page import="java.util.List" %>
<%@ page import="mypackage.Course" %>
<%@ page import="mypackage.DAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ page import="java.sql.SQLException" %>
<%
// Load data if coming directly to JSP
if (request.getAttribute("courses") == null) {
    try {
        DAO courseDAO = new DAO();
        List<Course> courses = courseDAO.getAllCourses();
        List<String> ccategories = courseDAO.getAllCategoriesOfCourses(false);
        request.setAttribute("ccategories", ccategories);
        request.setAttribute("courses", courses);
    
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }
}
%>

<!DOCTYPE html>
<html lang="en"> 

  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="Template Mo">
    <link href="https://fonts.googleapis.com/css?family=Poppins:100,200,300,400,500,600,700,800,900" rel="stylesheet">

    <title>Education - List of Courses</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">


    <!-- Additional CSS Files -->
    <link rel="stylesheet" href="assets/css/fontawesome.css">
    <link rel="stylesheet" href="assets/css/templatemo-edu-meeting.css">
    <link rel="stylesheet" href="assets/css/owl.css">
    <link rel="stylesheet" href="assets/css/lightbox.css">
    <link rel="icon" type="image/svg+xml" href="assets/images/C Logo gold.svg?v=1.1" />
<!--

TemplateMo 569 Edu Meeting

https://templatemo.com/tm-569-edu-meeting

-->
  </head>

<body>
    <style>
/* Course Card Styles */
.course-card {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
    background: #fff;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.course-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
}

.course-card .thumb {
    position: relative;
    overflow: hidden;
    height: 220px;
}

.course-card .thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.course-card:hover .thumb img {
    transform: scale(1.05);
}

.price-container {
    position: absolute;
    top: 15px;
    right: 15px;
    z-index: 10; /* Increased z-index */
}

.price-tag {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
    padding: 8px 15px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 16px;
    box-shadow: 0 4px 15px rgba(245, 87, 108, 0.3);
    display: inline-block;
    white-space: nowrap;
}

.course-placeholder {
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    align-items: center;
    justify-content: center;
}

.course-placeholder i {
    font-size: 60px;
    color: white;
    opacity: 0.8;
}

.image-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(to bottom, transparent 50%, rgba(0,0,0,0.7));
    opacity: 0;
    transition: opacity 0.3s ease;
    z-index: 1; /* Lower than price */
}

.course-card:hover .image-overlay {
    opacity: 1;
}

.category-badge {
    position: absolute;
    bottom: 15px;
    left: 15px;
    background: rgba(255, 255, 255, 0.95);
    padding: 5px 12px;
    border-radius: 15px;
    font-size: 12px;
    font-weight: 600;
    color: #333;
    z-index: 2;
}

.course-card .down-content {
    padding: 25px;
    flex-grow: 1;
    display: flex;
    flex-direction: column;
}

.course-meta {
    display: flex;
    justify-content: space-between;
    margin-bottom: 15px;
    padding-bottom: 15px;
    border-bottom: 1px solid #eee;
}

.course-meta .duration,
.course-meta .difficulty {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    color: #666;
}

.course-meta i {
    color: #667eea;
}

.course-title h4 {
    font-size: 20px;
    font-weight: 700;
    color: #1e1e1e;
    margin-bottom: 12px;
    line-height: 1.4;
    transition: color 0.3s ease;
}

.course-title:hover h4 {
    color: #667eea;
}

.course-description {
    color: #666;
    line-height: 1.6;
    margin-bottom: 20px;
    flex-grow: 1;
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.course-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: auto;
    padding-top: 15px;
    border-top: 1px solid #eee;
}

.btn-enroll {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-radius: 25px;
    text-decoration: none;
    font-weight: 600;
    font-size: 14px;
    transition: all 0.3s ease;
}

.btn-enroll:hover {
    transform: translateX(5px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.rating {
    display: flex;
    align-items: center;
    gap: 5px;
    color: #ffc107;
    font-weight: 600;
}

.rating i {
    font-size: 14px;
}

.rating .reviews {
    color: #999;
    font-size: 12px;
    margin-left: 5px;
}

/* Grid spacing */
.grid {
    gap: 30px;
}

.grid > div {
    margin-bottom: 30px;
}

/* Responsive adjustments */
@media (max-width: 992px) {
    .course-card .thumb {
        height: 200px;
    }
}

@media (max-width: 768px) {
    .course-card .thumb {
        height: 180px;
    }
    
    .course-title h4 {
        font-size: 18px;
    }
    
    .course-card .down-content {
        padding: 20px;
    }
    
    .price-tag {
        padding: 6px 12px;
        font-size: 14px;
    }
}
    </style>
   

  <!-- Sub Header -->
  <!-- <div class="sub-header">
    <div class="container">
      <div class="row">
        <div class="col-lg-8 col-sm-8">
          <div class="left-content">
            <p>This is an educational <em>HTML CSS</em> template by TemplateMo website.</p>
          </div>
        </div>
        <div class="col-lg-4 col-sm-4">
          <div class="right-icons">
            <ul>
              <li><a href="#"><i class="fa fa-facebook"></i></a></li>
              <li><a href="#"><i class="fa fa-twitter"></i></a></li>
              <li><a href="#"><i class="fa fa-behance"></i></a></li>
              <li><a href="#"><i class="fa fa-linkedin"></i></a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div> -->

  <!-- ***** Header Area Start ***** -->
  <header class="header-area header-sticky">
      <div class="container">
          <div class="row">
              <div class="col-12">
                  <nav class="main-nav">
                      <!-- ***** Logo Start ***** -->
                      <a href="index.jsp" class="logo">
                          Campora
                      </a>
                      <!-- ***** Logo End ***** -->
                      <!-- ***** Menu Start ***** -->
                      <ul class="nav">
                          <li><a href="index.jsp">Home</a></li>
                          <li><a href="courses.jsp" class="active">Courses</a></li>
                          <li><a href="index.jsp?href=#faq">Apply Now</a></li>
                          <li class="has-sub">
                              <a href="javascript:void(0)">Pages</a>
                              <ul class="sub-menu">
                                  <li><a href="events.jsp">Upcoming Events</a></li>
                                  <li><a href="index.jsp?href=#events">Events Details</a></li>
                              </ul>
                          </li>
                          <li><a href="index.jsp?href=#courses">Courses</a></li> 
                          <li><a href="index.jsp?href=#contact">Contact Us</a></li> 
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

  <section class="heading-page header-text" id="top">
    <div class="container">
      <div class="row">
        <div class="col-lg-12">
          <h6>Here are our upcoming Courses</h6>
          <h2>Upcoming Courses</h2>
        </div>
      </div>
    </div>
  </section>

  <section class="meetings-page" id="meetings">
    <div class="container">
      <div class="row">
        <div class="col-lg-12">
          <div class="row">
            <div class="col-lg-12">
              <div class="filters">
                <ul>
                  <li data-filter="*"  class="active">All Courses</li>
                    <c:forEach var="ccategories" items="${ccategories}">
                    <li data-filter=".${ccategories}">${ccategories}</li>
                    </c:forEach>
                </ul>
              </div>
            </div>
            <div class="col-lg-12">
                <div class="row grid">
                    <c:forEach var="course" items="${courses}">
                        <div class="col-lg-4 templatemo-item-col all ${course.category}">
                            <div class="meeting-item course-card">
                                <div class="thumb">
                                    <a href="">
                                        <div class="price-container">
                                            <c:choose>
                                            <c:when test="${course.fees == 0.0}">
                                            <span class="price-tag">Free</span>
                                            </c:when>
                                            <c:otherwise>
                                            <span class="price-tag">&#8377; ${course.fees}</span>                                                
                                            </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:choose>
                                            <c:when test="${not empty course.img}">
                                                <img src="data:image/jpeg;base64,${course.getImageBase64()}" 
                                                     class="course-img" 
                                                     alt="${course.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="course-placeholder">
                                                    <i class="fa fa-graduation-cap"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="image-overlay"></div>
                                    </a>
                                    <div class="category-badge">
                                        <span>${course.category}</span>
                                    </div>
                                </div>
                                <div class="down-content">
                                    <div class="course-meta">
                                        <div class="duration">
                                            <i class="fa fa-clock-o"></i>
                                            <span>${course.durationMonths} Months</span>
                                        </div>
                                        <div class="difficulty">
                                            <i class="fa fa-signal"></i>
                                            <span>Intermediate</span>
                                        </div>
                                    </div>
                                    <a href="meeting-details.html" class="course-title">
                                        <h4>${course.name}</h4>
                                    </a>
                                    <p class="course-description">${course.description}</p>
                                    <div class="course-footer">
                                        <a href="pages/regiseterlogin_page/Student_registration.jsp?StudentCourse=${course.name}" class="btn-enroll">
                                            <i class="fa fa-arrow-right"></i>
                                            <span>Enroll Now</span>
                                        </a>
                                        <div class="rating">
                                            <i class="fa fa-star"></i>
                                            <span>4.5</span>
                                            <span class="reviews">(120)</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div class="col-lg-12">
              <div class="pagination">
<!--                <ul>
                  <li><a href="#">1</a></li>
                  <li class="active"><a href="#">2</a></li>
                  <li><a href="#">3</a></li>
                  <li><a href="#"><i class="fa fa-angle-right"></i></a></li>
                </ul>-->
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="footer">
      <p>Copyright © 2022 Edu Meeting Co., Ltd. All Rights Reserved. 
          <br>
          Design: <a href="https://templatemo.com" target="_parent" title="free css templates">TemplateMo</a>
          <br>
          Distibuted By: <a href="https://themewagon.com" target="_blank" title="Build Better UI, Faster">ThemeWagon</a>
        </p>
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
    <script src="assets/js/isotope.js"></script>
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
