<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<c:set var="pageTitle" value="Browse Jobs - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">Browse Opportunities</h1>
      <p class="section-subtitle">Internships, fresher roles, and entry-level jobs from companies on InternLink Nepal.</p>
    </div>
  </div>

  <form action="${pageContext.request.contextPath}/jobs" method="get" class="card" style="padding:18px;display:grid;grid-template-columns:2fr 1fr 1fr auto;gap:12px;margin-bottom:24px;">
    <input type="text" name="q" value="${q}" placeholder="Search by title, skill, or company" style="padding:12px 14px;border:1px solid var(--border);border-radius:10px;"/>
    <select name="type" style="padding:12px 14px;border:1px solid var(--border);border-radius:10px;">
      <option value="">All types</option>
      <option value="INTERNSHIP" ${type == 'INTERNSHIP' ? 'selected' : ''}>Internship</option>
      <option value="FULL_TIME" ${type == 'FULL_TIME' ? 'selected' : ''}>Full time</option>
      <option value="PART_TIME" ${type == 'PART_TIME' ? 'selected' : ''}>Part time</option>
      <option value="REMOTE" ${type == 'REMOTE' ? 'selected' : ''}>Remote</option>
    </select>
    <select name="exp" style="padding:12px 14px;border:1px solid var(--border);border-radius:10px;">
      <option value="">Any experience</option>
      <option value="FRESHER" ${exp == 'FRESHER' ? 'selected' : ''}>Fresher</option>
      <option value="INTERN" ${exp == 'INTERN' ? 'selected' : ''}>Intern</option>
      <option value="EXPERIENCED" ${exp == 'EXPERIENCED' ? 'selected' : ''}>Experienced</option>
    </select>
    <button class="btn btn-primary" type="submit">Search</button>
  </form>

  <div style="display:grid;grid-template-columns:1.4fr .9fr;gap:24px;align-items:start;">
    <div class="grid-auto">
      <c:choose>
        <c:when test="${not empty jobs}">
          <c:forEach var="job" items="${jobs}">
            <div class="card job-card" onclick="location.href='${pageContext.request.contextPath}/jobs?id=${job.id}'">
              <div class="card-body">
                <div class="job-card-header">
                  <div class="company-logo-wrap"><img src="${pageContext.request.contextPath}/${job.companyLogoUrl}" alt="${job.companyName}" class="company-logo-img"/></div>
                  <span class="badge badge-intern">${job.jobType}</span>
                </div>
                <div class="job-title">${job.title}</div>
                <div class="job-company">${job.companyName}</div>
                <div class="job-tags">
                  <c:forTokens var="skill" items="${job.skillsRequired}" delims=",">
                    <span class="tag">${skill}</span>
                  </c:forTokens>
                </div>
                <div class="job-footer">
                  <span class="job-location"><i class="fa-solid fa-location-dot"></i> ${job.companyCity}</span>
                  <span class="badge badge-${fn:toLowerCase(job.experienceRequired == 'ANY' ? 'fresher' : job.experienceRequired)}">
                    ${job.experienceRequired == 'ANY' ? 'Open to All' : job.experienceRequired}
                  </span>
                  <div style="margin-top:8px;">
                    <c:choose>
                      <c:when test="${sessionScope.userRole == 'STUDENT'}">
                        <form id="applyForm-${job.id}" action="${pageContext.request.contextPath}/student/apply" method="post" style="display:inline;">
                          <input type="hidden" name="jobId" value="${job.id}"/>
                          <button type="button" class="btn btn-primary btn-sm" onclick="event.stopPropagation();document.getElementById('applyForm-${job.id}').submit();">Apply</button>
                        </form>
                      </c:when>
                      <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm" onclick="event.stopPropagation();">Login to Apply</a>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="card"><div class="card-body">No live jobs matched your filters. Try removing filters or post fresh jobs from the company dashboard.</div></div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="card">
      <div class="card-body">
        <h3 style="margin-bottom:12px;">Job Details</h3>
        <c:choose>
          <c:when test="${not empty selectedJob}">
            <div style="font-size:22px;font-weight:700;margin-bottom:4px;">${selectedJob.title}</div>
            <div style="color:var(--text-secondary);margin-bottom:12px;">${selectedJob.companyName} • ${selectedJob.companyCity}</div>
            <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px;">
              <span class="badge badge-intern">${selectedJob.jobType}</span>
              <span class="badge badge-fresher">${selectedJob.experienceRequired}</span>
            </div>
            <p style="margin-bottom:12px;">${selectedJob.description}</p>
            <p style="margin-bottom:12px;"><strong>Requirements:</strong> ${selectedJob.requirements}</p>
            <p style="margin-bottom:12px;"><strong>Skills:</strong> ${selectedJob.skillsRequired}</p>
            <p style="margin-bottom:12px;"><strong>Location:</strong> ${selectedJob.location}</p>
            <p style="margin-bottom:12px;"><strong>Salary:</strong> ${selectedJob.salaryRange}</p>
            <p style="margin-bottom:16px;"><strong>Deadline:</strong> ${selectedJob.deadline}</p>
            <c:choose>
              <c:when test="${sessionScope.userRole == 'STUDENT'}">
                <form action="${pageContext.request.contextPath}/student/apply" method="post" style="display:inline;margin:0;padding:0;">
                    <input type="hidden" name="jobId" value="${selectedJob.id}"/>
                    <button class="btn btn-primary" type="submit">Apply from Dashboard</button>
                  </form>
              </c:when>
              <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Login to Continue</a>
              </c:otherwise>
            </c:choose>
          </c:when>
          <c:otherwise>
            <p style="color:var(--text-secondary);">Select any job card to view the full description, required skills, and company details.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
