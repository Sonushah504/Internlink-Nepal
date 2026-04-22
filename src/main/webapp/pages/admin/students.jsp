<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Students - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">Students</h1>
      <p class="section-subtitle">Review student profiles currently visible on the platform.</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">Back to Dashboard</a>
  </div>

  <div class="table-card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>University</th>
          <th>Program</th>
          <th>Experience</th>
          <th>Profile Score</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="student" items="${students}">
          <tr>
            <td>${student.fullName}</td>
            <td>${student.university}</td>
            <td>${student.program}</td>
            <td><span class="badge badge-fresher">${student.experienceType}</span></td>
            <td>${student.profileScore}%</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
