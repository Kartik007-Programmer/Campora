<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.*" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="java.sql.SQLException" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    boolean isUserLoggedIn = true;
    String AdminUsername = (String) session.getAttribute("admin");
    request.setAttribute("AdminUsername", AdminUsername );
            
    if (AdminUsername == null) {
        isUserLoggedIn = false;
        RequestDispatcher rd = request.getRequestDispatcher("LoginForm.jsp");
        rd.forward(request, response);
        return;
    }
%>

<%
    DAO dao = new DAO();
    int TotalStudents = dao.getTotalStudents();
    int TotalTeachers = dao.getTotalTeachers();
    int TotalCourse = dao.getTotalCourses();
    int TotalStudentApproved = dao.getTotalStudentsApproved();
    double SuccessStudentPersntage = ((double) TotalStudentApproved / TotalStudents) * 100;
    
    // Additional statistics for the chart
    int TotalPendingStudents = dao.getTotalStudents() - dao.getTotalStudentsApproved();
    int TotalActiveStudents = dao.getTotalStudentsApproved(); 
    int TotalEnrolledCourses = dao.getTotalEnrolledCourses(); 
%>

<%
if (request.getAttribute("students") == null) {
   try{
       List<Student> students = dao.getAllStudents();
       request.setAttribute("students", students);
   } catch (SQLException e) {
       request.setAttribute("error", "Database error: " + e.getMessage());
   }
}
%>

<%
try {
    DAO eventDAO = new DAO();
    List<Event> events = eventDAO.getAllEvents();
    request.setAttribute("events", events);
} catch (SQLException e) {
    request.setAttribute("error", "Database error: " + e.getMessage());
}
%>

<%
try {
    DAO courseDAO = new DAO();
    List<Course> courses = courseDAO.getAllCourses();
    request.setAttribute("courses", courses);
} catch (SQLException e) {
    request.setAttribute("error", "Database error: " + e.getMessage());
}
%>

<!-- Set variables for base.jsp -->
<c:set var="pageTitle" value="Dashboard" scope="request" />

<c:set var="additionalCSS" scope="request">
         <!-- Required CDN (Place in <head> if not already present) -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"/>

</c:set>
        
        
<c:set var="pageContent" scope="request">
    <div class="row">
      <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
        <div class="card">
          <div class="card-body">
            <div class="row">
              <div class="col-9">
                <div class="d-flex align-items-center align-self-start">
                    <h3 class="mb-0"><%= TotalStudents %></h3>
                </div>
              </div>
              <div class="col-3">
                <div class="icon icon-box-success ">
                  <span class="mdi mdi-school"></span>
                </div>
              </div>
            </div>
            <h6 class="text-muted font-weight-normal">Total Students</h6>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
        <div class="card">
          <div class="card-body">
            <div class="row">
              <div class="col-9">
                <div class="d-flex align-items-center align-self-start">
                  <h3 class="mb-0"><%= TotalTeachers %></h3>
                </div>
              </div>
              <div class="col-3">
                <div class="icon icon-box-success">
                  <span class="mdi mdi-account-multiple"></span>
                </div>
              </div>
            </div>
            <h6 class="text-muted font-weight-normal">Current Teachers</h6>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
        <div class="card">
          <div class="card-body">
            <div class="row">
              <div class="col-9">
                <div class="d-flex align-items-center align-self-start">
                    <h3 class="mb-0"><%= TotalCourse %></h3>
                </div>
              </div>
              <div class="col-3">
                <div class="icon icon-box-danger">
                  <span class="mdi mdi-book-multiple"></span>
                </div>
              </div>
            </div>
            <h6 class="text-muted font-weight-normal">Number of Course</h6>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
        <div class="card">
          <div class="card-body">
            <div class="row">
              <div class="col-9">
                <div class="d-flex align-items-center align-self-start">
                    <h3 class="mb-0"><%= String.format("%.2f", SuccessStudentPersntage) %>%</h3>
                </div>
              </div>
              <div class="col-3">
                <div class="icon icon-box-success ">
                  <span class="mdi mdi-arrow-top-right icon-item"></span>
                </div>
              </div>
            </div>
            <h6 class="text-muted font-weight-normal">Successed Students</h6>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-4 grid-margin stretch-card">
        <div class="card">
          <div class="card-body">
            <h4 class="card-title">University Statistics</h4>
            <!-- Chart Container -->
            <div style="position: relative; height: 200px; margin-bottom: 20px;">
              <canvas id="university-stats-chart" class="transaction-chart" height="200"></canvas>
            </div>
            <div class="bg-gray-dark d-flex d-md-block d-xl-flex flex-row py-3 px-4 px-md-3 px-xl-4 rounded mt-3">
              <div class="text-md-center text-xl-left">
                <h6 class="mb-1">Total Students</h6>
                <p class="text-muted mb-0">All Registered Students</p>
              </div>
              <div class="align-self-center flex-grow text-right text-md-center text-xl-right py-md-2 py-xl-0">
                <h6 class="font-weight-bold mb-0"><%= TotalStudents %></h6>
                <small class="text-info">Registered</small>
              </div>
            </div>
            <div class="bg-gray-dark d-flex d-md-block d-xl-flex flex-row py-3 px-4 px-md-3 px-xl-4 rounded mt-3">
              <div class="text-md-center text-xl-left">
                <h6 class="mb-1">Approved Students</h6>
                <p class="text-muted mb-0">Successfully Admitted</p>
              </div>
              <div class="align-self-center flex-grow text-right text-md-center text-xl-right py-md-2 py-xl-0">
                <h6 class="font-weight-bold mb-0"><%= TotalStudentApproved %></h6>
                <small class="text-success"><%= String.format("%.1f", SuccessStudentPersntage) %>% Rate</small>
              </div>
            </div>
            <div class="bg-gray-dark d-flex d-md-block d-xl-flex flex-row py-3 px-4 px-md-3 px-xl-4 rounded mt-3">
              <div class="text-md-center text-xl-left">
                <h6 class="mb-1">Faculty & Courses</h6>
                <p class="text-muted mb-0">Teachers & Programs</p>
              </div>
              <div class="align-self-center flex-grow text-right text-md-center text-xl-right py-md-2 py-xl-0">
                <h6 class="font-weight-bold mb-0"><%= TotalTeachers %> / <%= TotalCourse %></h6>
                <small class="text-warning">Teachers / Courses</small>
              </div>
            </div>
          </div>
        </div>
      </div>

<div class="col-md-8 grid-margin stretch-card">
  <div class="card bg-gray-dark">
    <div class="card-body">
      <div class="d-flex flex-row justify-content-between mb-3">
        <h4 class="card-title mb-1">Upcoming Events</h4>
              <p class="text-muted mb-1">Your data status</p>
            </div>
            <div class="row">
              <div class="col-12">
                <div class="preview-list bg-dark">
                 <c:forEach var="event" items="${events}">                       
                  <div class="preview-item border-bottom">
                    <div class="preview-thumbnail" style="margin-left: 20px">
                      <div class="preview-icon bg-primary">
                        <i class="mdi mdi-file-document"></i>
                      </div>
                    </div>
                      <div class="preview-item-content d-sm-flex flex-grow ">
                      <div class="flex-grow">
                        <h6 class="preview-subject">${event.title}</h6>
                        <p class="text-muted mb-0">${event.description}</p>
                      </div>
                      <div class="mr-auto text-sm-right pt-2 pt-sm-0">
                        <p class="text-muted m-2">
                            <fmt:formatDate value="${event.date}" pattern="MMM dd, yyyy" />
                        </p>
                      </div>
                    </div>
                  </div>
                 </c:forEach>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="row ">
            <div class="col-12 grid-margin">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">Student Applyed for Addmision</h4>
                    <div class="table-responsive draggable-table-container table-view ">
                      <table class="table table-striped mb-0 ">
                        <thead class="thead-dark">
                          <tr>
                            <th> Id </th>
                            <th> Photo </th>
                            <th> Student Name </th>
                            <th> Pending fees </th>
                            <th> Course </th>
                            <th> Payment Mode </th>
                            <th> Registeration Date </th>
                            <th> Addmision Status </th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="student" items="${students}">             
                             <%
                                String course = ((Student) pageContext.getAttribute("student")).getCourse();
                                Double fee = dao.getFeesByCourse(course);
                              %>
                           <tr>
                            <td> ${student.id} </td>
                            <td>
                                <c:if test="${not empty student.photo}">
                                  <img src="data:image/jpeg;base64,${student.imageBase64}" 
                                     alt="Student Photo" 
                                     class="student-photo">
                                </c:if>
                                <c:if test="${empty student.photo}">
                                   No photo
                               </c:if>   
                            </td>
                            <td>    
                              <span class="pl-2">${student.firstName} ${student.lastName}</span>
                            </td>
                            
                            
                            <td> &#8377;<%= fee == null ? 0 : fee %> </td>
                            <td> ${student.course}</td>
                            <td> Credit card </td>
                            <td> <fmt:formatDate value="${student.registrationDate}" 
                                       pattern="dd-MMM-yyyy HH:mm" />  </td>
                            <td>
                            <c:choose>
                              <c:when test="${student.status == 'APPROVED'}">
                                <div class="badge badge-outline-success">APPROVED</div>
                              </c:when>
                              <c:otherwise>
                                <div class="badge badge-outline-warning">${student.status}</div>
                              </c:otherwise>
                            </c:choose>
                            </td>
                          </tr>
                          </c:forEach>  
                          </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
     </div>

<!-- Our Popular Courses Section Start -->
<div class="row mb-4">
  <div class="col-12">
    <div class="card">
      <div class="card-body">
        <h4 class="card-title mb-4">Listed Courses</h4>
        <div class="owl-carousel owl-theme">

          <c:forEach var="course" items="${courses}">
            <div class="item text-center bg-dark text-white border border-primary rounded p-3">
              <c:choose>
                <c:when test="${not empty course.img}">
                  <img src="data:image/jpeg;base64,${course.imageBase64}" class="img-fluid mb-3 rounded" alt="${course.name}" style="height: 120px; object-fit: cover; width: 100%;">
                </c:when>
                <c:otherwise>
                  <img src="assets/images/no-image.png" class="img-fluid mb-3 rounded" alt="No image available" style="height: 120px; object-fit: cover; width: 100%;">
                </c:otherwise>
              </c:choose>    
              <h6>${course.name}</h6>
              <div class="d-flex justify-content-between align-items-center px-3">
                <div class="text-warning">
                  <c:set var="rating" value="${course.star}" />                  
                  <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                      <c:when test="${rating >= i}">
                        <i class="mdi mdi-star"></i>
                      </c:when>
                      <c:when test="${rating >= (i - 0.5)}">
                        <i class="mdi mdi-star-half"></i>
                      </c:when>
                      <c:otherwise>
                        <i class="mdi mdi-star-outline"></i>
                      </c:otherwise>
                    </c:choose>
                  </c:forEach>
                </div>
                <span class="text-light">&#8377; ${course.fees}</span>
              </div>
            </div>
          </c:forEach>

        </div>
      </div>
    </div>
  </div>
</div>
<!-- Our Popular Courses Section End -->

<div class="row">
  <div class="col-12">
    <div class="card bg-gray-dark">
      <div class="card-body">
        <h4 class="card-title">Visitors by Cities</h4>
            <div class="row">
                <div class="col-md-5">
                    <div class="table-responsive bg-dark">
                        <table class="table">
                            <tbody>
                              <tr>
                                <td>
                                  <i class="flag-icon flag-icon-in"></i>
                                </td>
                                <td>Ahmedabad</td>
                                <td class="text-right"> &#8377;10300 </td>
                                <td class="text-right font-weight-medium"> 56.35% </td>
                              </tr>
                              <tr>
                                <td>
                                  <i class="flag-icon flag-icon-in"></i>
                                </td>
                                <td>Delhi</td>
                                <td class="text-right"> &#8377;7750 </td>
                                <td class="text-right font-weight-medium"> 33.25% </td>
                              </tr>
                              <tr>
                                <td>
                                  <i class="flag-icon flag-icon-in"></i>
                                </td>
                                <td>Ahmedabad</td>
                                <td class="text-right"> &#8377;5360 </td>
                                <td class="text-right font-weight-medium"> 15.45% </td>
                              </tr>
                              <tr>
                                <td>
                                  <i class="flag-icon flag-icon-in"></i>
                                </td>
                                <td>Uttrakhand</td>
                                <td class="text-right"> &#8377;4450 </td>
                                <td class="text-right font-weight-medium"> 25.00% </td>
                              </tr>
                              <tr>
                                <td>
                                  <i class="flag-icon flag-icon-in"></i>
                                </td>
                                <td>Surat</td>
                                <td class="text-right"> &#8377;2270 </td>
                                <td class="text-right font-weight-medium"> 10.25% </td>
                              </tr>
                              <tr>
                                <td>
                                  <i class="flag-icon flag-icon-in"></i>
                                </td>
                                <td>Hyderabad</td>
                                <td class="text-right"> &#8377;1653 </td>
                                <td class="text-right font-weight-medium"> 75.00% </td>
                              </tr>
                            </tbody>
                          </table>
                        </div>
                      </div>
                      <div class="col-md-7">
                        <div id="audience-map" class="vector-map bg-dark"></div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

</c:set>

<c:set var="additionalScripts" scope="request"> 
        <script>
        window.onload = function() {
            const navEntries = performance.getEntriesByType("navigation");
            if (navEntries.length > 0 && navEntries[0].type === "reload") {
                const isLoggedIn = <%= isUserLoggedIn %>;
                if (isLoggedIn) {
                    window.location.replace("LoginForm.jsp");
                }
            }
        };
    </script>
<!-- Required JS (Put before </body>) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
    <!-- Chart.js for statistics graph -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
  $(document).ready(function(){
    // Owl Carousel for courses
    $(".owl-carousel").owlCarousel({
      loop: true,
      margin: 20,
      nav: true,
      dots: false,
      autoplay: true,
      autoplayTimeout: 3000,
      autoplayHoverPause: true,
      responsive: {
        0: { items: 1 },
        576: { items: 2 },
        992: { items: 3 }
      }
    });
    
    // Initialize University Statistics Chart
    initUniversityStatsChart();
  });

  function initUniversityStatsChart() {
    const ctx = document.getElementById('university-stats-chart').getContext('2d');
    
    // Data from JSP variables
    const totalStudents = <%= TotalStudents %>;
    const approvedStudents = <%= TotalStudentApproved %>;
    const totalTeachers = <%= TotalTeachers %>;
    const totalCourses = <%= TotalCourse %>;
    
    // Calculate pending students
    const pendingStudents = totalStudents - approvedStudents;
    
   const computedStepSize = Math.ceil(Math.max(totalStudents, totalTeachers, totalCourses) / 5) || 1;

    const universityChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['Total Students', 'Approved Students', 'Pending Students', 'Teachers', 'Courses'],
        datasets: [{
          label: 'University Statistics',
          data: [totalStudents, approvedStudents, pendingStudents, totalTeachers, totalCourses],
          backgroundColor: [
            'rgba(54, 162, 235, 0.7)',   // Blue for Total Students
            'rgba(75, 192, 192, 0.7)',   // Teal for Approved Students
            'rgba(255, 99, 132, 0.7)',   // Red for Pending Students
            'rgba(255, 159, 64, 0.7)',   // Orange for Teachers
            'rgba(153, 102, 255, 0.7)'   // Purple for Courses
          ],
          borderColor: [
            'rgba(54, 162, 235, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(255, 99, 132, 1)',
            'rgba(255, 159, 64, 1)',
            'rgba(153, 102, 255, 1)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Count',
              color: '#fff'
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            },
            ticks: {
              color: '#fff',
              stepSize: computedStepSize
            }
          },
          x: {
            grid: {
              display: false
            },
            ticks: {
              color: '#fff',
              maxRotation: 45,
              minRotation: 45
            }
          }
        },
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            titleColor: '#fff',
            bodyColor: '#fff',
            callbacks: {
              label: function(context) {
                let label = context.dataset.label || '';
                if (label) {
                  label += ': ';
                }
                
             const value = context.raw !== undefined ? context.raw : context.parsed.y;
                
              if (context.dataIndex === 0) {
                  return ``+label+value+` (Total Registered)`;
                } else if (context.dataIndex === 1) {
                  const percentage = totalStudents > 0 ? Math.round((approvedStudents / totalStudents) * 100) : 0;
                  return ``+label+value+ ` (`+percentage+`% of total)`;
                } else if (context.dataIndex === 2) { 
                  const percentage = totalStudents > 0 ? Math.round((pendingStudents / totalStudents) * 100) : 0;
                  return ``+label+value+ ` (`+percentage+`% of total)`;
                }
                return ``+label+value+``;
              }
            }
          }
        }
      }
    });
  }
</script>

<script>
    // System panel utility adjustments
    document.addEventListener("DOMContentLoaded", function () {
        const body = document.querySelector('body');
        if (body.classList.contains('sidebar-icon-only') === false) {
            body.classList.add('sidebar-icon-only');
        }
    });
</script>
    
</c:set>

<!-- Include the base template -->
<jsp:include page="Base.jsp" />