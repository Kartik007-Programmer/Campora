<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.*" %>
<%@ page import="mypackage.DAO" %>
<%@ page import="java.sql.SQLException" %>

<% 
    // Session validation
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String adminUsername = (String) session.getAttribute("admin");
    if (adminUsername == null) {
        RequestDispatcher rd = request.getRequestDispatcher("regiseterlogin_page/LoginForm.jsp");
        rd.forward(request, response);
        return;
    }
    
    // Set search query for highlighting
    String searchQuery = request.getParameter("searchQuery");
    boolean hasValidSearchQuery = false;
    
    if (searchQuery != null) {
        // Trim the search query and check if it's not empty
        String trimmedQuery = searchQuery.trim();
        if (!trimmedQuery.isEmpty()) {
            request.setAttribute("searchQuery", trimmedQuery);
            hasValidSearchQuery = true;
        } else {
            // If it's only whitespace, set to null or empty
            request.setAttribute("searchQuery", "");
        }
    }
%>

<!-- Set template variables -->
<c:set var="pageTitle" value="Search Results" scope="request" />

<c:set var="pageContent" scope="request">
    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-12">
                            <form action="${pageContext.request.contextPath}/UniversalSearchServlet" method="post">
                                <div class="form-group d-flex">
                                    <input type="text" class="form-control " name="searchQuery" placeholder="Search Here" value="${searchQuery}">
                                    <button type="submit" class="btn btn-primary ms-3">Search</button>
                                </div>
                            </form>
                        </div>
                        <div class="col-12 mb-5">
                            <h2>Search Result For<u class="ms-2">"${searchQuery}"</u></h2>
                            <c:choose>
                                <c:when test="${not empty searchQuery and not empty totalResults}">
                                    <p class="text-muted">About ${totalResults} results</p>
                                </c:when>
                                <c:when test="${empty searchQuery}">
                                    <p class="text-muted">Enter a search term above</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">Search for anything using the form above</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${not empty searchQuery}">
                            <c:set var="highlightStart" value="<span class='highlight'>" />
                            <c:set var="highlightEnd" value="</span>" />
                            <c:set var="lastType" value="" />
                            
                            <c:if test="${not empty results}">
                                <%-- First display all action items --%>
                                <c:forEach var="result" items="${results}">
                                    <c:if test="${result.type == 'action'}">
                                        <div class="col-12 results">
                                            <div class="pt-4 border-bottom action-card" onclick="window.location='${result.url}'">
                                                <a class="d-block h4 mb-0" href="#">${result.title}</a>
                                                <p class="page-description mt-1 w-75 text-muted">${result.description}</p>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                
                                <%-- Then display regular results --%>
                                <c:forEach var="result" items="${results}">
                                    <c:if test="${result.type != 'action'}">
                                        <!-- Show category header once per type -->
                                        <c:if test="${result.type != lastType}">
                                            <c:set var="lastType" value="${result.type}" />
                                            <div class="col-12">
                                                <h4 class="result-category">
                                                    <c:choose>
                                                        <c:when test="${result.type == 'teacher'}">
                                                            Teacher Results
                                                            <c:if test="${not empty countTeachers}">(${countTeachers})</c:if>
                                                        </c:when>
                                                        <c:when test="${result.type == 'student'}">
                                                            Student Results
                                                            <c:if test="${not empty countStudents}">(${countStudents})</c:if>
                                                        </c:when>
                                                        <c:when test="${result.type == 'course'}">
                                                            Course Results
                                                            <c:if test="${not empty countCourses}">(${countCourses})</c:if>
                                                        </c:when>
                                                        <c:when test="${result.type == 'event'}">
                                                            Event Results
                                                            <c:if test="${not empty countEvents}">(${countEvents})</c:if>
                                                        </c:when>
                                                        <c:when test="${result.type == 'admin'}">
                                                            Administrator Results
                                                            <c:if test="${not empty countAdmins}">(${countAdmins})</c:if>
                                                        </c:when>
                                                    </c:choose>
                                                </h4>
                                            </div>
                                        </c:if>
                                        
                                        <c:set var="sep" value="${fn:contains(result.url,'?') ? '&' : '?'}" />
                                        <div class="col-12 results"
                                             data-id="${result.id}"
                                             data-type="${result.type}">
                                            <div class="pt-4 border-bottom result-card" 
                                                 onclick="window.location='${result.url}${sep}searchQuery=${fn:escapeXml(searchQuery)}'">
                                                <a class="d-block h4 mb-0" href="#">
                                                    <c:choose>
                                                        <c:when test="${fn:containsIgnoreCase(result.title, searchQuery)}">
                                                            <c:out value="${fn:replace(result.title, searchQuery, highlightStart.concat(searchQuery).concat(highlightEnd))}"
                                                                   escapeXml="false"/>
                                                        </c:when>
                                                        <c:otherwise>${result.title}</c:otherwise>
                                                    </c:choose>
                                                </a>
                                                <a class="page-url text-primary" href="#">${result.url}</a>
                                                <p class="page-description mt-1 w-75 text-muted">
                                                    <c:choose>
                                                        <c:when test="${fn:containsIgnoreCase(result.description, searchQuery)}">
                                                            <c:out value="${fn:replace(result.description, searchQuery, highlightStart.concat(searchQuery).concat(highlightEnd))}"
                                                                   escapeXml="false"/>
                                                        </c:when>
                                                        <c:otherwise>${result.description}</c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <div class="text-muted small">
                                                    <span>
                                                        <c:choose>
                                                            <c:when test="${fn:containsIgnoreCase(result.email, searchQuery)}">
                                                                <c:out value="${fn:replace(result.email, searchQuery, highlightStart.concat(searchQuery).concat(highlightEnd))}"
                                                                       escapeXml="false"/>
                                                            </c:when>
                                                            <c:otherwise>${result.email}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span class="ms-2">
                                                        <c:if test="${not empty result.meta1}">${result.meta1}</c:if>
                                                        <c:if test="${not empty result.meta2}"> | ${result.meta2}</c:if>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            
                            <c:if test="${empty results}">
                                <div class="col-12">
                                    <div class="no-results text-center py-5">
                                        <h3>No results found for "${searchQuery}"</h3>
                                        <p>Try different keywords or check your spelling.</p>
                                    </div>
                                </div>
                            </c:if>
                        </c:if>
                        
                        <c:if test="${empty searchQuery}">
                            <div class="col-12">
                                <div class="no-search-query text-center py-5">
                                    <h3>Please enter a search term</h3>
                                    <p>Type something in the search box above to get started.</p>
                                </div>
                            </div>
                        </c:if>
                        
                        <nav class="col-12" aria-label="Page navigation">
                            <ul class="pagination mt-5">
<!--                                <li class="page-item"><a class="page-link" href="#">Previous</a></li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link" href="#">Next</a></li>-->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:set>

<%-- Additional CSS for search results --%>
<c:set var="additionalCSS" scope="request">
    <style>
        .highlight {
            background-color: yellow;
            padding: 0 2px;
            border-radius: 3px;
        }
        .result-card {
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        .result-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .selected-item {
            border: 3px solid #4CAF50;
            box-shadow: 0 0 10px rgba(76,175,80,0.5);
            transform: scale(1.02);
        }
        .action-card {
            border: 2px dashed #4CAF50;
        }
        .action-card:hover {
            background-color: #f8fff8;
            transform: scale(1.02);
        }
        .result-category {
            margin-top: 40px;
            margin-bottom: 15px;
            font-size: 20px;
            font-weight: bold;
            border-bottom: 2px solid #eee;
            padding-bottom: 5px;
            color: #666;
        }
        .no-search-query {
            color: #6c757d;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #444;
            border-radius: 4px;
            background-color: #2a2a2a;
            color: #e0e0e0;
            box-sizing: border-box;
        }

        .form-control:focus {
            outline: none;
            border-color: #81d4fa;
            box-shadow: 0 0 5px rgba(129, 212, 250, 0.3);
            color: white;
        }
                
    </style>
</c:set>

<%-- Additional JavaScript for search results --%>
<c:set var="additionalScripts" scope="request">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const lastId = sessionStorage.getItem('lastSelectedId'),
                  lastType = sessionStorage.getItem('lastSelectedType');

            document.querySelectorAll('.results[data-id]').forEach(item => {
                item.addEventListener('click', () => {
                    sessionStorage.setItem('lastSelectedId', item.dataset.id);
                    sessionStorage.setItem('lastSelectedType', item.dataset.type);
                });

                if (item.dataset.id === lastId && item.dataset.type === lastType) {
                    const resultCard = item.querySelector('.result-card');
                    if (resultCard) {
                        resultCard.classList.add('selected-item');
                        item.scrollIntoView({behavior: 'smooth', block: 'center'});
                    }
                }
            });
        });
    </script>
</c:set>

<%-- Include base template --%>
<%@include file="Base.jsp" %>
