<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Company Dashboard – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<div class="dash-layout">

  <!-- ── Sidebar ──────────────────────────────────────────────── -->
  <aside class="dash-sidebar">
    <div class="dash-sidebar-brand">
      <h3>${company.companyName}</h3>
      <p style="display:flex;align-items:center;gap:4px;">
        <c:choose>
          <c:when test="${company.verified}"><span class="badge badge-verified" style="font-size:10px;">&#10003; Verified</span></c:when>
          <c:otherwise><span class="badge badge-pending-co" style="font-size:10px;">Pending Verification</span></c:otherwise>
        </c:choose>
      </p>
    </div>

    <div class="sidebar-section-label">Dashboard</div>
    <a href="${pageContext.request.contextPath}/company/dashboard" class="sidebar-nav-item active">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><rect x="1" y="1" width="7" height="7" rx="1.5" fill="currentColor" opacity=".8"/><rect x="10" y="1" width="7" height="7" rx="1.5" fill="currentColor" opacity=".4"/><rect x="1" y="10" width="7" height="7" rx="1.5" fill="currentColor" opacity=".4"/><rect x="10" y="10" width="7" height="7" rx="1.5" fill="currentColor" opacity=".4"/></svg>
      Overview
    </a>
    <a href="${pageContext.request.contextPath}/company/postJob" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="9" r="7" stroke="currentColor" stroke-width="1.5"/><path d="M9 6v6M6 9h6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
      Post a Job
    </a>
    <a href="${pageContext.request.contextPath}/company/jobs" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><rect x="2" y="5" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M6 5V4a3 3 0 016 0v1" stroke="currentColor" stroke-width="1.5"/></svg>
      My Job Posts
    </a>

    <div class="sidebar-section-label">Applicants</div>
    <a href="${pageContext.request.contextPath}/company/dashboard?expFilter=FRESHER" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="6" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M3 16c0-3.31 2.69-6 6-6s6 2.69 6 6" stroke="currentColor" stroke-width="1.5"/></svg>
      Freshers
      <span style="margin-left:auto;background:var(--success-light);color:var(--success);font-size:11px;font-weight:700;padding:1px 7px;border-radius:10px;">${fresherCount}</span>
    </a>
    <a href="${pageContext.request.contextPath}/company/dashboard?expFilter=INTERN" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="6" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M3 16c0-3.31 2.69-6 6-6s6 2.69 6 6" stroke="currentColor" stroke-width="1.5"/></svg>
      Interns
      <span style="margin-left:auto;background:var(--primary-light);color:var(--primary);font-size:11px;font-weight:700;padding:1px 7px;border-radius:10px;">${internCount}</span>
    </a>
    <a href="${pageContext.request.contextPath}/company/dashboard?expFilter=EXPERIENCED" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="6" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M3 16c0-3.31 2.69-6 6-6s6 2.69 6 6" stroke="currentColor" stroke-width="1.5"/></svg>
      Experienced
      <span style="margin-left:auto;background:var(--warning-light);color:var(--warning);font-size:11px;font-weight:700;padding:1px 7px;border-radius:10px;">${experiencedCount}</span>
    </a>

    <div class="sidebar-section-label">Company</div>
    <a href="${pageContext.request.contextPath}/company/profile" class="sidebar-nav-item">
      <svg class="nav-icon" viewBox="0 0 18 18" fill="none"><rect x="2" y="2" width="14" height="14" rx="3" stroke="currentColor" stroke-width="1.5"/><path d="M6 9h6M6 12h4" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/></svg>
      Company Profile
    </a>
    <div style="padding:20px;margin-top:auto;">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm btn-block">Sign Out</a>
    </div>
  </aside>

  <!-- ── Main ──────────────────────────────────────────────────── -->
  <main class="dash-main">

    <!-- Header -->
    <div class="dash-header" style="display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:12px;">
      <div>
        <h1>${company.companyName} Dashboard</h1>
        <p>${company.city} &bull; ${company.industry} &bull; ${company.employeeCount} employees</p>
      </div>
      <a href="${pageContext.request.contextPath}/company/postJob" class="btn btn-primary">+ Post New Job</a>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty param.success}">
      <div class="alert alert-success" data-auto-dismiss>&#10003; ${param.success}</div>
    </c:if>
    <c:if test="${not company.verified}">
      <div class="alert alert-info">&#8505; Your company is pending admin verification. Job posts will be visible after approval.</div>
    </c:if>

    <!-- ── Metric Cards ──────────────────────────────────────── -->
    <div class="metric-cards">
      <div class="metric-card mc-blue">
        <div class="mc-icon">&#128196;</div>
        <div class="mc-label">Active Job Posts</div>
        <div class="mc-value">${totalJobs}</div>
      </div>
      <div class="metric-card mc-orange">
        <div class="mc-icon">&#128101;</div>
        <div class="mc-label">Total Applicants</div>
        <div class="mc-value">${totalApplicants}</div>
      </div>
      <div class="metric-card mc-green">
        <div class="mc-icon">&#127942;</div>
        <div class="mc-label">Shortlisted</div>
        <div class="mc-value">${shortlisted}</div>
      </div>
      <div class="metric-card mc-green">
        <div class="mc-icon">&#127881;</div>
        <div class="mc-label">Selected</div>
        <div class="mc-value">${selected}</div>
      </div>
    </div>

    <!-- ── Workforce Stats Row ───────────────────────────────── -->
    <div class="card mb-3" style="margin-bottom:20px;">
      <div class="card-body" style="padding:0;">
        <div style="padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;">
          <div>
            <h3 style="font-size:15px;font-weight:600;">Applicant &amp; Job Breakdown</h3>
            <p style="font-size:12px;color:var(--text-secondary);margin-top:2px;">Who is applying and what type of roles are posted</p>
          </div>
          <a href="${pageContext.request.contextPath}/profiles/company?id=${company.id}" class="btn btn-outline btn-sm" target="_blank">View Public Profile</a>
        </div>
        <div style="display:grid;grid-template-columns:repeat(3,1fr) 1px repeat(4,1fr);gap:0;">
          <!-- Applicant types -->
          <div style="padding:20px 18px;text-align:center;border-right:1px solid var(--border);">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--success);margin-bottom:6px;">Freshers</div>
            <div style="font-size:30px;font-weight:800;color:var(--text-primary);">${fresherCount}</div>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:4px;">applicants</div>
            <div style="margin-top:10px;height:4px;border-radius:2px;background:var(--gray-200);">
              <div style="height:4px;border-radius:2px;background:var(--success);width:${totalApplicants > 0 ? (fresherCount * 100 / totalApplicants) : 0}%;transition:width 0.6s;"></div>
            </div>
          </div>
          <div style="padding:20px 18px;text-align:center;border-right:1px solid var(--border);">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--primary);margin-bottom:6px;">Interns</div>
            <div style="font-size:30px;font-weight:800;color:var(--text-primary);">${internCount}</div>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:4px;">applicants</div>
            <div style="margin-top:10px;height:4px;border-radius:2px;background:var(--gray-200);">
              <div style="height:4px;border-radius:2px;background:var(--primary);width:${totalApplicants > 0 ? (internCount * 100 / totalApplicants) : 0}%;transition:width 0.6s;"></div>
            </div>
          </div>
          <div style="padding:20px 18px;text-align:center;border-right:2px solid var(--border);">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--warning);margin-bottom:6px;">Experienced</div>
            <div style="font-size:30px;font-weight:800;color:var(--text-primary);">${experiencedCount}</div>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:4px;">applicants</div>
            <div style="margin-top:10px;height:4px;border-radius:2px;background:var(--gray-200);">
              <div style="height:4px;border-radius:2px;background:var(--warning);width:${totalApplicants > 0 ? (experiencedCount * 100 / totalApplicants) : 0}%;transition:width 0.6s;"></div>
            </div>
          </div>
          <!-- divider column -->
          <div style="background:var(--border);"></div>
          <!-- Job types -->
          <div style="padding:20px 18px;text-align:center;border-right:1px solid var(--border);">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:#185FA5;margin-bottom:6px;">Internship</div>
            <div style="font-size:30px;font-weight:800;color:var(--text-primary);">${internshipJobs}</div>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:4px;">job posts</div>
          </div>
          <div style="padding:20px 18px;text-align:center;border-right:1px solid var(--border);">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:#3B6D11;margin-bottom:6px;">Full Time</div>
            <div style="font-size:30px;font-weight:800;color:var(--text-primary);">${fullTimeJobs}</div>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:4px;">job posts</div>
          </div>
          <div style="padding:20px 18px;text-align:center;border-right:1px solid var(--border);">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:#854F0B;margin-bottom:6px;">Part Time</div>
            <div style="font-size:30px;font-weight:800;color:var(--text-primary);">${partTimeJobs}</div>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:4px;">job posts</div>
          </div>
          <div style="padding:20px 18px;text-align:center;">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:#6C757D;margin-bottom:6px;">Remote</div>
            <div style="font-size:30px;font-weight:800;color:var(--text-primary);">${remoteJobs}</div>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:4px;">job posts</div>
          </div>
        </div>
      </div>
    </div>

    <!-- ── Charts + Map row ──────────────────────────────────── -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px;">

      <!-- Donut: Applicant types -->
      <div class="card">
        <div class="card-body">
          <h3 style="font-size:15px;font-weight:600;margin-bottom:4px;">Applicants by Experience</h3>
          <p style="font-size:13px;color:var(--text-secondary);margin-bottom:16px;">Breakdown of who is applying to your jobs</p>
          <div class="donut-wrap">
            <canvas id="donutChart" width="160" height="160"></canvas>
            <div class="donut-legend">
              <div class="legend-item"><span class="legend-dot" style="background:#3B6D11;"></span>Freshers &nbsp;<strong>${fresherCount}</strong></div>
              <div class="legend-item"><span class="legend-dot" style="background:#185FA5;"></span>Interns &nbsp;<strong>${internCount}</strong></div>
              <div class="legend-item"><span class="legend-dot" style="background:#854F0B;"></span>Experienced &nbsp;<strong>${experiencedCount}</strong></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Bar: Application status -->
      <div class="card">
        <div class="card-body">
          <h3 style="font-size:15px;font-weight:600;margin-bottom:4px;">Application Pipeline</h3>
          <p style="font-size:13px;color:var(--text-secondary);margin-bottom:16px;">Current status of all received applications</p>
          <canvas id="barChart" width="100%" height="160"></canvas>
        </div>
      </div>

    </div>

    <!-- ── Company Location Map ──────────────────────────────── -->
    <div class="card mb-3">
      <div class="card-body">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;">
          <div>
            <h3 style="font-size:15px;font-weight:600;">Company Location</h3>
            <p style="font-size:13px;color:var(--text-secondary);">${company.address}, ${company.city}</p>
          </div>
          <a href="${pageContext.request.contextPath}/company/profile" class="btn btn-ghost btn-sm">Edit Location</a>
        </div>
        <div id="map"></div>
      </div>
    </div>

    <!-- ── Applicant Table ───────────────────────────────────── -->
    <div class="table-card">
      <div class="table-card-header">
        <h3>All Applicants</h3>
        <span style="font-size:13px;color:var(--text-secondary);">${fn:length(applications)} records</span>
      </div>

      <!-- Filter bar -->
      <form action="${pageContext.request.contextPath}/company/dashboard" method="get" style="padding:14px 20px;border-bottom:1px solid var(--border);display:flex;gap:10px;flex-wrap:wrap;align-items:center;">
        <select name="expFilter" class="form-control" style="width:auto;" data-auto-submit>
          <option value="">All Experience Levels</option>
          <option value="FRESHER"    ${filterExp == 'FRESHER'    ? 'selected' : ''}>Freshers Only</option>
          <option value="INTERN"     ${filterExp == 'INTERN'     ? 'selected' : ''}>Interns Only</option>
          <option value="EXPERIENCED" ${filterExp == 'EXPERIENCED' ? 'selected' : ''}>Experienced Only</option>
        </select>
        <select name="statusFilter" class="form-control" style="width:auto;" data-auto-submit>
          <option value="">All Statuses</option>
          <option value="PENDING"     ${filterStatus == 'PENDING'     ? 'selected' : ''}>Pending</option>
          <option value="REVIEWING"   ${filterStatus == 'REVIEWING'   ? 'selected' : ''}>Reviewing</option>
          <option value="SHORTLISTED" ${filterStatus == 'SHORTLISTED' ? 'selected' : ''}>Shortlisted</option>
          <option value="SELECTED"    ${filterStatus == 'SELECTED'    ? 'selected' : ''}>Selected</option>
          <option value="REJECTED"    ${filterStatus == 'REJECTED'    ? 'selected' : ''}>Rejected</option>
        </select>
        <c:if test="${not empty filterExp or not empty filterStatus}">
          <a href="${pageContext.request.contextPath}/company/dashboard" class="btn btn-ghost btn-sm">Clear Filters</a>
        </c:if>
      </form>

      <table class="data-table">
        <thead>
          <tr>
            <th>Applicant</th>
            <th>Job Applied For</th>
            <th>CGPA</th>
            <th>Experience</th>
            <th>Skills</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty applications}">
              <c:forEach var="app" items="${applications}">
                <tr>
                   <!-- Applicant info -->
                  <td>
                    <div style="display:flex;align-items:center;gap:10px;">
                      <c:choose>
                        <c:when test="${not empty app.studentProfilePhoto}">
                          <img src="${pageContext.request.contextPath}/${app.studentProfilePhoto}" alt="${app.studentName}" style="width:38px;height:38px;border-radius:50%;object-fit:cover;flex-shrink:0;border:2px solid var(--border);"/>
                        </c:when>
                        <c:otherwise>
                          <div class="avatar">${fn:substring(app.studentName,0,1)}${fn:substring(app.studentName,fn:indexOf(app.studentName,' ')+1,fn:indexOf(app.studentName,' ')+2)}</div>
                        </c:otherwise>
                      </c:choose>
                      <div>
                        <a href="${pageContext.request.contextPath}/profiles/student?id=${app.studentId}" style="font-size:14px;font-weight:600;color:var(--primary);">${app.studentName}</a>
                        <div style="font-size:12px;color:var(--text-secondary);">${app.studentEmail}</div>
                      </div>
                    </div>
                  </td>

                  <!-- Job -->
                  <td style="font-size:13px;font-weight:500;">${app.jobTitle}</td>

                  <!-- CGPA -->
                  <td style="font-size:14px;font-weight:600;color:var(--primary);">${app.studentCgpa}</td>

                  <!-- Experience badge -->
                  <td>
                    <span class="badge badge-${fn:toLowerCase(app.studentExperienceType)}">
                      ${app.studentExperienceType}
                    </span>
                  </td>

                  <!-- Skills -->
                  <td>
                    <div style="display:flex;flex-wrap:wrap;gap:4px;max-width:200px;">
                      <c:forTokens var="sk" items="${app.studentSkills}" delims="," end="2">
                        <span class="tag" style="font-size:10px;">${fn:trim(sk)}</span>
                      </c:forTokens>
                    </div>
                  </td>

                  <!-- Current status -->
                  <td><span class="badge badge-${fn:toLowerCase(app.status)}">${app.status}</span></td>

                  <!-- Actions: update status form + CV link -->
                  <td>
                    <div style="display:flex;gap:6px;flex-wrap:wrap;align-items:center;">
                      <button onclick="openStatusModal(${app.id}, '${app.studentName}', '${app.status}')"
                              class="btn btn-outline btn-sm">Update</button>
                      <c:if test="${not empty app.studentCvPath}">
                        <a href="${pageContext.request.contextPath}/${app.studentCvPath}"
                           target="_blank" class="btn btn-ghost btn-sm">CV</a>
                      </c:if>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr><td colspan="7" style="text-align:center;padding:40px;color:var(--text-secondary);">
                <div style="font-size:32px;margin-bottom:12px;">&#128101;</div>
                No applicants yet. <a href="${pageContext.request.contextPath}/company/postJob" style="color:var(--primary);">Post a job</a> to start receiving applications.
              </td></tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div><!-- /table-card -->

  </main>
</div>

<!-- ── Update Status Modal ────────────────────────────────────── -->
<div id="statusModal" class="modal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:9999;align-items:center;justify-content:center;">
  <div style="background:#fff;border-radius:var(--radius-lg);padding:28px;width:100%;max-width:420px;box-shadow:var(--shadow-lg);">
    <h3 style="font-size:17px;font-weight:700;margin-bottom:4px;">Update Application Status</h3>
    <p id="modalApplicantName" style="font-size:13px;color:var(--text-secondary);margin-bottom:20px;"></p>
    <form action="${pageContext.request.contextPath}/company/updateStatus" method="post">
      <input type="hidden" name="appId" id="modalAppId"/>
      <div class="form-group">
        <label class="form-label">New Status</label>
        <select name="status" id="modalStatus" class="form-control">
          <option value="PENDING">Pending</option>
          <option value="REVIEWING">Reviewing</option>
          <option value="SHORTLISTED">Shortlisted</option>
          <option value="SELECTED">Selected</option>
          <option value="REJECTED">Rejected</option>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Internal Notes (optional)</label>
        <textarea name="notes" class="form-control" rows="3" placeholder="Add notes about this candidate…"></textarea>
      </div>
      <div style="display:flex;gap:10px;justify-content:flex-end;">
        <button type="button" onclick="closeModal('statusModal')" class="btn btn-ghost">Cancel</button>
        <button type="submit" class="btn btn-primary">Save Status</button>
      </div>
    </form>
  </div>
</div>

<!-- Leaflet map + Charts init -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
// ── Leaflet map ──────────────────────────────────────────────────
(function() {
  var lat = ${company.latitude != 0 ? company.latitude : 27.7172};
  var lng = ${company.longitude != 0 ? company.longitude : 85.3240};
  var map = L.map('map').setView([lat, lng], 15);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://openstreetmap.org/">OpenStreetMap</a> contributors'
  }).addTo(map);
  L.marker([lat, lng]).addTo(map)
    .bindPopup('<strong>${company.companyName}</strong><br>${company.address}')
    .openPopup();
})();

// ── Donut chart ─────────────────────────────────────────────────
drawDonut('donutChart', [
  { value: ${fresherCount},     color: '#3B6D11' },
  { value: ${internCount},      color: '#185FA5' },
  { value: ${experiencedCount}, color: '#854F0B' }
]);

// ── Bar chart - pipeline ─────────────────────────────────────────
(function() {
  var canvas = document.getElementById('barChart');
  if (!canvas) return;
  canvas.width = canvas.parentElement.offsetWidth - 40 || 320;
  drawBar('barChart',
    ['Pending', 'Reviewing', 'Shortlisted', 'Selected', 'Rejected'],
    [
      ${totalApplicants - shortlisted - selected},
      ${shortlisted > 0 ? shortlisted - selected : 0},
      ${shortlisted},
      ${selected},
      0
    ],
    '#185FA5'
  );
})();

// ── Status modal ─────────────────────────────────────────────────
function openStatusModal(appId, name, currentStatus) {
  document.getElementById('modalAppId').value    = appId;
  document.getElementById('modalApplicantName').textContent = 'Applicant: ' + name;
  document.getElementById('modalStatus').value   = currentStatus;
  openModal('statusModal');
}
</script>

<jsp:include page="/components/footer.jsp"/>
