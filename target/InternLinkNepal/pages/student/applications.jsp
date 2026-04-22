<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="My Applications - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">My Applications</h1>
      <p class="section-subtitle">Track every internship and job you have applied for.</p>
    </div>
    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">Browse Jobs</a>
  </div>

  <div class="table-card">
    <div class="table-card-header">
      <h3>Application History</h3>
      <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-ghost btn-sm">Back to Dashboard</a>
    </div>
    <table class="data-table">
      <thead>
        <tr>
          <th>Role</th>
          <th>Company</th>
          <th>Applied On</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${not empty applications}">
            <c:forEach var="app" items="${applications}">
              <tr>
                <td>${app.jobTitle}</td>
                <td>${app.companyName}</td>
                <td>${fn:substring(app.appliedAt,0,10)}</td>
                <td><span class="badge badge-${fn:toLowerCase(app.status)}">${app.status}</span></td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr><td colspan="4" style="text-align:center;padding:32px;">No applications yet.</td></tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
