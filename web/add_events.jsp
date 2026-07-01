<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="mypackage.Event" %>
<%@ page import="mypackage.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    boolean isUserLoggedIn = true;
    String AdminUsername = (String) session.getAttribute("admin");

    if (AdminUsername == null) {
        isUserLoggedIn = false;
        RequestDispatcher rd = request.getRequestDispatcher("LoginForm.jsp");
        rd.forward(request, response);
        return;
    }
%>

<%

    
    try {
        DAO eventDAO = new DAO();
        List<Event> events = eventDAO.getLastTwoEvents();
        List<String> category = eventDAO.getAllCategoriesOfEvents(true);
        request.setAttribute("category", category);
        request.setAttribute("events", events);
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }

    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
    <script>alert('<%= error %>');</script>
<%
    }
%>

<!-- Set variables for base.jsp -->
<c:set var="pageTitle" value="Add Events - Corona Admin" scope="request" />

<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/select2/select2.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/select2-bootstrap-theme/select2-bootstrap.min.css">
    <style>
        body {
  background-color: #121212;
  color: #e0e0e0;
}

.form-control {
  background-color: #1e1e1e;
  color: #f5f5f5;
  border: 1px solid #333;
  border-radius: 6px;
  padding: 10px 12px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.form-control:focus {
  background-color: #252525;
  color: #fff;
  border-color: #3f51b5;
  box-shadow: 0 0 0 3px rgba(63, 81, 181, 0.4);
  outline: none;
}

.form-control::placeholder {
  color: #aaaaaa;
  opacity: 1;
}



label {
  color: #d1d1d1;
  font-weight: 500;
}

.btn {
  border-radius: 6px;
  padding: 10px 16px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.btn-primary {
  background-color: #3f51b5;
  border: none;
  color: #fff;
}

.btn-primary:hover {
  background-color: #5c6bc0;
}

.btn-secondary {
  background-color: #444;
  border: none;
  color: #f5f5f5;
}

.btn-secondary:hover {
  background-color: #555;
}
        .event-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .event-card {
            flex: 1 1 calc(25% - 20px);
            min-width: 250px;
            background: #191c24;
            border: 1px solid #2c2c2c;
            border-radius: 8px;
            padding: 16px;
            box-sizing: border-box;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .event-card h3 {
            color: #81d4fa;
            margin-bottom: 18px;
            font-weight: bold;
        }
        
        .event-card:hover {
            transform: scale(1.02);
            box-shadow: 0 0 10px rgba(129, 212, 250, 0.3);
            border-color: #81d4fa;
            color: #ffffff;
        }
        
        .event-card .event-img {
            display: block;
            position: absolute;
            right: 30px;
            top: 50%;
            transform: translateY(-60%);
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 2px;
            box-shadow: 0 4px 12px rgba(129, 212, 250, 0.3);
        }

        .card-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            gap: 5px;
        }

        .card-buttons .btn-edit {
            flex: 1;
            padding: 10px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: 0.1s ease;
            border: solid 1px #81d4fa;
            color: #e0e0e0;
            background-color: rgba(129, 212, 250, 0.068);
        }

        .card-buttons .btn-edit:hover {
            background-color: #81d4fa;
            color: #121212;
            opacity:0.85;
        }
        
        .card-buttons .btn-delete {
            flex: 1;
            padding: 8px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: 0.1s ease;
            border: solid 1px #81d4fa;
            color: #e0e0e0;
            background-color: rgba(129, 212, 250, 0.068);
        }

        .card-buttons .btn-delete:hover {
            background-color: #81d4fa;
            color: #121212;
            opacity:0.85;
        }
        
        @media screen and (max-width: 992px) {
            .event-card {
                flex: 1 1 calc(50% - 20px);
            }
        }
        
        @media screen and (max-width: 600px) {
            .event-card {
                flex: 1 1 100%;
            }
        }
    </style>
</c:set>

<c:set var="pageContent" scope="request">
    <div class="page-header">
        <h3 class="page-title">Add an Event</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Forms</a></li>
                <li class="breadcrumb-item active" aria-current="page">Form elements</li>
            </ol>
        </nav>
    </div>
    
    <div class="row">
        <div class="col-md-6 grid-margin stretch-card">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title">Events Form</h4>
                    <p class="card-description">Event for CORONA 2025</p>
                    <form class="forms-sample" action="${pageContext.request.contextPath}/AddEventServlet" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label>Event photo</label>
                            <!-- Hidden file input -->
                            <input type="file" name="image" class="file-upload-default" accept=".jpg,.png,.svg" style="display:none" id="fileInput">
                            <div class="input-group col-xs-12">
                                <!-- Display the selected file names here -->
                                <input type="text" class="form-control file-upload-info" disabled placeholder="Upload image size 4MB, Format JPG, PNG, SVG">
                                <span class="input-group-append">
                                    <!-- Button triggers the file input -->
                                    <button class="file-upload-browse btn btn-primary" type="button" id="browseButton">Upload</button>
                                </span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="title">Event Title</label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="Enter Event Name" required>
                        </div>
            
                        <div class="form-group">
                            <label for="price">Event Price</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">₹</span>
                                </div>
                                <input type="number" class="form-control" id="price" name="price" placeholder="Enter Event Price" required>
                            </div>
                        </div>
            
                        <div class="form-group">
                            <label for="date">Event Date</label>
                            <input type="date" class="form-control" id="date" name="date" style="color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                        </div>
            
                        <div class="form-group">
                            <label for="category">Event Category</label>
                            <select class="form-control" id="category" name="category" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                                <option value="">Select Event Category</option>
                                <c:forEach var="ccategories" items="${category}">
                                <option value="${ccategories}">${ccategories}</option>
                                </c:forEach>
                            </select>
                        </div>
            
                        <div class="form-group">
                            <label for="description">Event Description</label>
                            <textarea rows="4" cols="50" class="form-control" id="description" name="description" placeholder="Enter Description.." required></textarea>
                        </div>
            
                        <button type="submit" class="btn btn-primary mr-2">Submit</button>
                        <button type="button" class="btn btn-dark" onclick="window.location.href='${pageContext.request.contextPath}/view_events.jsp'">Cancel</button>
                    </form>
                </div>
            </div>
        </div>
    
        <!-- Right Side: Event Cards -->
        <div class="col-md-6 grid-margin stretch-card">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title">Event List</h4>
                    <p class="card-description">Interactive layout with Edit options</p>
                    <div class="event-container limited" id="eventContainer">
                        <c:forEach var="event" items="${events}">
                            <div class="event-card">
                                <c:if test="${not empty event.image}">
                                    <img class="event-img" src="data:image/jpeg;base64,${event.imageBase64}" alt="${event.title}" />
                                </c:if>
                                <h3>${event.title}</h3>
                                <p><strong>Date:</strong> <fmt:formatDate value="${event.date}" pattern="MMM dd, yyyy" /></p>
                                <p><strong>Price:</strong> ₹${event.price}</p>
                                <p><strong>Category:</strong> ${event.category}</p>
                                <p><strong>Description:</strong> ${event.description}</p>
                                
                                <div class="card-buttons">
                                    <form action="${pageContext.request.contextPath}/EditEventServlet" method="get" style="display:inline;">
                                        <input type="hidden" name="id" value="${event.id}" />
                                        <c:if test="${not empty param.searchQuery}">
                                            <input type="hidden" name="searchQuery" value="${fn:escapeXml(param.searchQuery)}" />
                                        </c:if>
                                        <button type="submit" class="btn-delete">Edit</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/delete-event" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this event?');">
                                        <input type="hidden" name="id" value="${event.id}">
                                        <button type="submit" class="btn-delete">Delete</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="d-flex justify-content-center mt-4">
                        <a href="${pageContext.request.contextPath}/view_events.jsp" class="btn btn-outline-secondary btn-sm px-4 py-2 rounded-2 shadow-sm d-flex align-items-center gap-2">
                            <span style="font-weight: bold;">View All Events</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:set>

<c:set var="additionalScripts" scope="request">
    <script src="${pageContext.request.contextPath}/assets/vendors/select2/select2.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/typeahead.js/typeahead.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/file-upload.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/typeahead.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/select2.js"></script>
    
    <script>
        // Trigger file input click when the "Upload" button is clicked
        document.getElementById('browseButton').addEventListener('click', function () {
            document.getElementById('fileInput').click();
        });

        // Handle file selection and validation
        document.getElementById('fileInput').addEventListener('change', function () {
            const files = this.files;
            const fileInfoInput = document.querySelector('.file-upload-info');
            let isValid = true;
            let fileNames = [];
            
            if (files.length > 0) {
                const file = files[0];
                if (file.size > 4 * 1024 * 1024) {
                    alert("File size exceeds 4MB. Please upload a smaller file.");
                    isValid = false;
                }
                const validFormats = ['image/jpeg', 'image/png', 'image/svg+xml'];
                if (!validFormats.includes(file.type)) {
                    alert("Invalid file format. Only JPG, PNG, SVG are allowed.");
                    isValid = false;
                }
                fileNames.push(file.name);
            }
            
            if (isValid) {
                fileInfoInput.value = fileNames.join(', ') + " selected";
            } else {
                this.value = '';
                fileInfoInput.value = '';
            }
        });
    </script>
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
</c:set>

<!-- Include the base template -->
<jsp:include page="Base.jsp" />