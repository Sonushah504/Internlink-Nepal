<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Jobs - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">Active Jobs</h1>
      <p class="section-subtitle">See the roles that are currently visible to students.</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">Back to Dashboard</a>
  </div>

  <div class="table-card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Role</th>
          <th>Company</th>
          <th>Type</th>
          <th>Experience</th>
          <th>Deadline</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="job" items="${jobs}">
          <tr>
            <td>${job.title}</td>
            <td>${job.companyName}</td>
            <td>${job.jobType}</td>
            <td>${job.experienceRequired}</td>
            <td>${job.deadline}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
