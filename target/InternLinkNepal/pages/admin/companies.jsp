<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Companies - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">Company Verification</h1>
      <p class="section-subtitle">Review registered companies and update their verification status.</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">Back to Dashboard</a>
  </div>

  <div class="table-card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Company</th>
          <th>Industry</th>
          <th>City</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="co" items="${companies}">
          <tr>
            <td>${co.companyName}</td>
            <td>${co.industry}</td>
            <td>${co.city}</td>
            <td><span class="badge ${co.verified ? 'badge-verified' : 'badge-fresher'}">${co.verified ? 'Verified' : 'Pending'}</span></td>
            <td>
              <form action="${pageContext.request.contextPath}/admin/verifyCompany" method="post">
                <input type="hidden" name="companyId" value="${co.id}"/>
                <input type="hidden" name="action" value="${co.verified ? 'unverify' : 'verify'}"/>
                <button type="submit" class="btn btn-sm ${co.verified ? 'btn-ghost' : 'btn-primary'}">${co.verified ? 'Unverify' : 'Verify'}</button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
