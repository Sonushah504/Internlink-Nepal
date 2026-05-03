<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Companies - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">Verified Companies</h1>
      <p class="section-subtitle">Explore companies that actively hire students and fresh graduates.</p>
    </div>
  </div>

  <div class="grid-3">
    <c:forEach var="co" items="${companies}">
      <div class="card">
        <div class="card-body">
          <div style="display:flex;align-items:center;gap:12px;margin-bottom:14px;">
            <div class="company-logo-wrap"><img src="${pageContext.request.contextPath}/${co.logoUrl}" alt="${co.companyName}" class="company-logo-img"/></div>
            <div>
              <div style="font-size:17px;font-weight:700;">${co.companyName}</div>
              <div style="color:var(--text-secondary);font-size:13px;">${co.industry} • ${co.city}</div>
            </div>
            <c:if test="${co.verified}">
              <span class="badge badge-verified" style="margin-left:auto;">Verified</span>
            </c:if>
          </div>
          <p style="margin-bottom:12px;">${co.description}</p>
          <div style="display:grid;gap:8px;font-size:13px;color:var(--text-secondary);">
            <div><strong>Email:</strong> ${co.email}</div>
            <div><strong>Phone:</strong> ${co.phone}</div>
            <div><strong>Address:</strong> ${co.address}</div>
            <div><strong>Founded:</strong> ${co.foundedYear}</div>
            <div><strong>Team size:</strong> ${co.employeeCount}</div>
          </div>
          <a href="${pageContext.request.contextPath}/profiles/company?id=${co.id}" class="btn btn-outline" style="margin-top:16px;">View Profile</a>
        </div>
      </div>
    </c:forEach>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
