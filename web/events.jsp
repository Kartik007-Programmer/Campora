<%@ page import="java.util.List" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="mypackage.Event" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ page import="java.sql.SQLException" %>
<%
// Load data if coming directly to JSP for Events
try {
    DAO EventDAO = new DAO();
    List<Event> event = EventDAO.getAllEvents();
    List<String> category = EventDAO.getAllCategoriesOfEvents(false);
    request.setAttribute("category", category);
    request.setAttribute("Event", event);
} catch (SQLException e) {
    request.setAttribute("error", "Database error: " + e.getMessage());
}
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
    <meta name="author" content="Template Mo">
    <link href="https://fonts.googleapis.com/css?family=Poppins:100,200,300,400,500,600,700,800,900" rel="stylesheet">

    <title>Education - List of Events</title>

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
  <style>
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
</style>
<body>

   

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
                          <li><a href="courses.jsp" class="">Courses</a></li>
                          <li><a href="index.jsp?href=#faq">Apply Now</a></li>
                          <li class="has-sub">
                              <a href="javascript:void(0)">Pages</a>
                              <ul class="sub-menu">
                                  <li><a href="courses.jsp">Upcoming Courses</a></li>
                                  <li><a href="index.jsp?href=#courses">Course Details</a></li>
                              </ul>
                          </li>
                          <li><a href="events.jsp" class="active">Events</a></li> 
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
          <h6>Here are our upcoming Events</h6>
          <h2>Upcoming Events</h2>
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
                  <li data-filter="*" class="active">All Events</li>
                  <c:forEach var="category" items="${category}">
                  <li data-filter=".${category}">${category}</li>
                  </c:forEach>
                </ul>
              </div>
            </div>
            <div class="col-lg-12">
              <div class="row grid">
               <c:forEach var="event" items="${Event}">
                <div class="col-lg-4 templatemo-item-col all ${event.category}">
                  <div class="meeting-item">
                    <div class="thumb">
                      <div class="price">
                        <span>&#8377; ${event.price}</span>
                      </div>
                        <c:if test="${not empty event.imageBase64}">
                          <a>
                            <img src="data:image/jpeg;base64,${event.imageBase64}" alt="Event Image"/>
                          </a>
                        </c:if>
                    </div>
                   <div class="down-content d-flex align-items-start">
                  <div class="date me-3">
                    <h6>
                         <fmt:formatDate value="${event.date}" pattern="MMM" />
                    <span><fmt:formatDate value="${event.date}" pattern="dd" /></span>
                    </h6>
                  </div>
                  <div class="event-text">
                        <a><h4>${event.title}</h4></a>
                        <p>${event.description}</p>
                   </div>
                  </div>
                 </div>
                </div>
               </c:forEach>               
              </div>
            </div>
            <div class="col-lg-12">
              <div class="pagination">
                <ul>
                  <li class="active"><a href="#">1</a></li>
                  <li><a href="#">2</a></li>
                  <li><a href="#">3</a></li>
                  <li><a href="#"><i class="fa fa-angle-right"></i></a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="footer">
<!--      <p>Copyright © 2022 Edu Meeting Co., Ltd. All Rights Reserved. 
          <br>
          Design: <a href="https://templatemo.com" target="_parent" title="free css templates">TemplateMo</a>
          <br>
          Distibuted By: <a href="https://themewagon.com" target="_blank" title="Build Better UI, Faster">ThemeWagon</a>
        </p>-->
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
