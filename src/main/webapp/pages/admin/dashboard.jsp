<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Admin Dashboard – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<div class="dash-layout">

  <!-- Sidebar -->
  <aside class="dash-sidebar">
    <div class="dash-sidebar-brand">
      <h3>Admin Panel</h3>
      <p>InternLink Nepal</p>
    </div>
    <div class="sidebar-section-label">Overview</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-item active">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><rect x="1" y="1" width="7" height="7" rx="1.5" fill="currentColor" opacity=".8"/><rect x="10" y="1" width="7" height="7" rx="1.5" fill="currentColor" opacity=".4"/><rect x="1" y="10" width="7" height="7" rx="1.5" fill="currentColor" opacity=".4"/><rect x="10" y="10" width="7" height="7" rx="1.5" fill="currentColor" opacity=".4"/></svg>
      Dashboard
    </a>
    <div class="sidebar-section-label">Management</div>
    <a href="${pageContext.request.contextPath}/admin/companies" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><rect x="2" y="2" width="14" height="14" rx="3" stroke="currentColor" stroke-width="1.5"/><path d="M6 9h6M6 12h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
      Companies
      <c:if test="${pendingCos > 0}">
        <span style="margin-left:auto;background:var(--danger-light);color:var(--danger);font-size:11px;font-weight:700;padding:1px 7px;border-radius:10px;">${pendingCos}</span>
      </c:if>
    </a>
    <a href="${pageContext.request.contextPath}/admin/students" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="6" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M3 16c0-3.31 2.69-6 6-6s6 2.69 6 6" stroke="currentColor" stroke-width="1.5"/></svg>
      Students
    </a>
    <a href="${pageContext.request.contextPath}/admin/jobs" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><rect x="2" y="5" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M6 5V4a3 3 0 016 0v1" stroke="currentColor" stroke-width="1.5"/></svg>
      Job Posts
    </a>
    <div style="padding:20px;margin-top:auto;">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm btn-block">Sign Out</a>
    </div>
  </aside>

  <!-- Main -->
  <main class="dash-main">
    <div class="dash-header">
      <h1>Platform Overview</h1>
      <p>Real-time metrics and management controls for InternLink Nepal.</p>
    </div>

    <!-- Metric cards -->
    <div class="metric-cards">
      <div class="metric-card mc-blue">
        <div class="mc-icon">&#127891;</div>
        <div class="mc-label">Total Students</div>
        <div class="mc-value">${totalStudents}</div>
      </div>
      <div class="metric-card mc-green">
        <div class="mc-icon">&#127970;</div>
        <div class="mc-label">Total Companies</div>
        <div class="mc-value">${totalCompanies}</div>
      </div>
      <div class="metric-card mc-orange">
        <div class="mc-icon">&#128196;</div>
        <div class="mc-label">Active Jobs</div>
        <div class="mc-value">${totalJobs}</div>
      </div>
      <div class="metric-card mc-red">
        <div class="mc-icon">&#9888;</div>
        <div class="mc-label">Pending Verifications</div>
        <div class="mc-value">${pendingCos}</div>
      </div>
    </div>

    <!-- Student Breakdown + Company Verification row -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px;">

      <!-- Student breakdown donut -->
      <div class="card">
        <div class="card-body">
          <h3 style="font-size:15px;font-weight:600;margin-bottom:4px;">Student Breakdown</h3>
          <p style="font-size:13px;color:var(--text-secondary);margin-bottom:14px;">By experience type</p>
          <div class="donut-wrap">
            <canvas id="studentDonut" width="140" height="140"></canvas>
            <div class="donut-legend">
              <div class="legend-item"><span class="legend-dot" style="background:#3B6D11;"></span>Freshers <strong>${totalFreshers}</strong></div>
              <div class="legend-item"><span class="legend-dot" style="background:#185FA5;"></span>Interns <strong>${totalInterns}</strong></div>
              <div class="legend-item"><span class="legend-dot" style="background:#854F0B;"></span>Experienced <strong>${totalExperienced}</strong></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Company verification status -->
      <div class="card">
        <div class="card-body">
          <h3 style="font-size:15px;font-weight:600;margin-bottom:4px;">Company Verification</h3>
          <p style="font-size:13px;color:var(--text-secondary);margin-bottom:16px;">${verifiedCos} verified &bull; ${pendingCos} pending</p>

          <div style="margin-bottom:12px;">
            <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:6px;">
              <span>Verified</span><span style="font-weight:600;">${verifiedCos}</span>
            </div>
            <div class="progress"><div class="progress-bar" style="width:${totalCompanies > 0 ? (verifiedCos * 100 / totalCompanies) : 0}%;background:var(--success);"></div></div>
          </div>
          <div>
            <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:6px;">
              <span>Pending</span><span style="font-weight:600;">${pendingCos}</span>
            </div>
            <div class="progress"><div class="progress-bar" style="width:${totalCompanies > 0 ? (pendingCos * 100 / totalCompanies) : 0}%;background:var(--warning);"></div></div>
          </div>

          <div style="margin-top:20px;">
            <a href="${pageContext.request.contextPath}/admin/companies?filter=PENDING" class="btn btn-primary btn-sm">
              Review Pending Companies &#8594;
            </a>
          </div>
        </div>
      </div>

    </div>

    <!-- Companies table -->
    <div class="table-card mb-3">
      <div class="table-card-header">
        <h3>All Companies</h3>
        <span style="font-size:13px;color:var(--text-secondary);">${totalCompanies} registered</span>
      </div>
      <table class="data-table">
        <thead>
          <tr>
            <th>Company</th>
            <th>City</th>
            <th>Industry</th>
            <th>Employees</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="co" items="${companies}">
            <tr>
              <td>
                <div style="display:flex;align-items:center;gap:10px;">
                  <div class="company-logo-wrap" style="width:34px;height:34px;font-size:12px;">${fn:substring(co.companyName,0,2)}</div>
                  <div>
                    <div style="font-weight:600;font-size:14px;">${co.companyName}</div>
                    <div style="font-size:12px;color:var(--text-secondary);">${co.email}</div>
                  </div>
                </div>
              </td>
              <td style="font-size:13px;">${co.city}</td>
              <td style="font-size:13px;">${co.industry}</td>
              <td style="font-size:13px;">${co.employeeCount}</td>
              <td>
                <c:choose>
                  <c:when test="${co.verified}"><span class="badge badge-verified">&#10003; Verified</span></c:when>
                  <c:otherwise><span class="badge badge-pending-co">Pending</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <div style="display:flex;gap:6px;">
                  <c:if test="${!co.verified}">
                    <form action="${pageContext.request.contextPath}/admin/verifyCompany" method="post" style="display:inline;">
                      <input type="hidden" name="companyId" value="${co.id}"/>
                      <input type="hidden" name="action"    value="VERIFY"/>
                      <button type="submit" class="btn btn-success btn-sm">Verify</button>
                    </form>
                  </c:if>
                  <c:if test="${co.verified}">
                    <form action="${pageContext.request.contextPath}/admin/verifyCompany" method="post" style="display:inline;">
                      <input type="hidden" name="companyId" value="${co.id}"/>
                      <input type="hidden" name="action"    value="REVOKE"/>
                      <button type="submit" class="btn btn-danger btn-sm">Revoke</button>
                    </form>
                  </c:if>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty companies}">
            <tr><td colspan="6" style="text-align:center;padding:32px;color:var(--text-secondary);">No companies registered yet.</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>

    <!-- Jobs table -->
    <div class="table-card">
      <div class="table-card-header">
        <h3>Active Job Postings</h3>
        <span style="font-size:13px;color:var(--text-secondary);">${totalJobs} active</span>
      </div>
      <table class="data-table">
        <thead>
          <tr>
            <th>Job Title</th>
            <th>Company</th>
            <th>Type</th>
            <th>Experience</th>
            <th>Location</th>
            <th>Deadline</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="job" items="${jobs}">
            <tr>
              <td style="font-weight:500;">${job.title}</td>
              <td style="font-size:13px;color:var(--text-secondary);">${job.companyName}</td>
              <td><span class="badge badge-intern" style="font-size:10px;">${job.jobType}</span></td>
              <td><span class="badge badge-${fn:toLowerCase(job.experienceRequired == 'ANY' ? 'fresher' : fn:toLowerCase(job.experienceRequired))}" style="font-size:10px;">${job.experienceRequired}</span></td>
              <td style="font-size:13px;">${job.location}</td>
              <td style="font-size:13px;color:var(--text-secondary);">${job.deadline}</td>
            </tr>
          </c:forEach>
          <c:if test="${empty jobs}">
            <tr><td colspan="6" style="text-align:center;padding:32px;color:var(--text-secondary);">No active job postings.</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>

  </main>
</div>

<script>
drawDonut('studentDonut', [
  { value: ${totalFreshers},    color: '#3B6D11' },
  { value: ${totalInterns},     color: '#185FA5' },
  { value: ${totalExperienced}, color: '#854F0B' }
]);
</script>

<jsp:include page="/components/footer.jsp"/>
