<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Company Jobs - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">${company.companyName} Jobs</h1>
      <p class="section-subtitle">Manage your open roles and review what candidates see.</p>
    </div>
    <a href="${pageContext.request.contextPath}/company/postJob" class="btn btn-primary">Post a Job</a>
  </div>

  <div class="grid-auto">
    <c:choose>
      <c:when test="${not empty jobs}">
        <c:forEach var="job" items="${jobs}">
          <div class="card">
            <div class="card-body">
              <div style="display:flex;justify-content:space-between;gap:12px;margin-bottom:8px;">
                <div>
                  <div class="job-title">${job.title}</div>
                  <div class="job-company">${job.location}</div>
                </div>
                <span class="badge badge-intern">${job.jobType}</span>
              </div>
              <p style="margin-bottom:10px;">${job.description}</p>
              <div style="display:flex;gap:10px;flex-wrap:wrap;">
                <span class="badge badge-fresher">${job.experienceRequired}</span>
                <span class="badge badge-verified">${job.deadline}</span>
              </div>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="card"><div class="card-body">No jobs posted yet. Use the button above to publish your first role.</div></div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
