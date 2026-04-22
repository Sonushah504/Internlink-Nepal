<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${company.companyName} - Company Profile"/>
<jsp:include page="/components/header.jsp"/>

<style>
.co-profile-wrap { max-width: 1200px; margin: 0 auto; padding: 28px 24px; }

/* Cover banner */
.co-cover {
  height: 200px;
  background: linear-gradient(120deg, #0d2645 0%, #16528d 55%, #2875c8 100%);
  border-radius: 20px 20px 0 0;
  position: relative;
}
.co-cover::before {
  content: '';
  position: absolute;
  bottom: -70px; left: 28px;
  width: 120px; height: 120px;
  border-radius: 28px;
  background: #fff;
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
  display: flex; align-items: center; justify-content: center;
  overflow: hidden;
}
.co-logo-box {
  position: absolute;
  bottom: -70px; left: 28px;
  width: 120px; height: 120px;
  border-radius: 28px;
  background: linear-gradient(135deg, #0d2645, #185FA5);
  border: 5px solid #fff;
  box-shadow: 0 4px 16px rgba(0,0,0,0.18);
  display: flex; align-items: center; justify-content: center;
  font-size: 46px; font-weight: 800; color: #fff;
}
.co-hero-card {
  background: #fff;
  border: 1px solid var(--border);
  border-radius: 0 0 20px 20px;
  border-top: none;
  padding: 88px 28px 24px;
}
.co-name { font-size: 28px; font-weight: 800; color: var(--text-primary); line-height: 1.2; }
.co-meta { font-size: 14px; color: var(--text-secondary); margin-top: 6px; }
.co-badges { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 12px; }
.co-actions { margin-top: 16px; display: flex; gap: 10px; flex-wrap: wrap; }

/* Stats row */
.co-stats-row {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 0;
  background: #fff;
  border: 1px solid var(--border);
  border-radius: 16px;
  overflow: hidden;
  margin-bottom: 16px;
}
.co-stat-cell {
  padding: 18px 14px;
  text-align: center;
  border-right: 1px solid var(--border);
}
.co-stat-cell:last-child { border-right: none; }
.co-stat-value { font-size: 26px; font-weight: 800; color: var(--text-primary); }
.co-stat-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.07em; margin-top: 4px; }
.co-stat-sub { font-size: 11px; color: var(--text-secondary); margin-top: 3px; }

/* Section cards */
.co-section { background: #fff; border: 1px solid var(--border); border-radius: 16px; padding: 22px; margin-bottom: 16px; }
.co-section-title { font-size: 16px; font-weight: 700; margin-bottom: 14px; display: flex; align-items: center; gap: 10px; }
.co-section-title::after { content: ''; flex: 1; height: 1px; background: var(--gray-100); }

/* Video player */
.co-video { width: 100%; border-radius: 14px; background: #000; display: block; max-height: 360px; }
.co-video-placeholder {
  background: linear-gradient(135deg, #f8f9fa, #e9ecef);
  border: 2px dashed var(--border);
  border-radius: 14px; padding: 48px 28px;
  text-align: center; color: var(--text-secondary);
}

/* Job cards */
.co-job-card {
  display: flex; align-items: center; justify-content: space-between; gap: 12px;
  padding: 14px 16px; border: 1px solid var(--border); border-radius: 12px;
  margin-bottom: 10px; transition: all 0.2s; text-decoration: none; color: inherit;
}
.co-job-card:hover { border-color: var(--primary); background: var(--primary-light); box-shadow: 0 2px 8px rgba(24,95,165,0.1); }
.co-job-card:last-child { margin-bottom: 0; }

/* Sidebar */
.co-info-row { display: flex; align-items: flex-start; gap: 10px; padding: 10px 0; border-bottom: 1px solid var(--gray-100); font-size: 13px; }
.co-info-row:last-child { border-bottom: none; }
.co-info-icon { color: var(--text-secondary); flex-shrink: 0; margin-top: 1px; }
.co-info-label { font-weight: 600; color: var(--text-primary); }
.co-info-value { color: var(--text-secondary); margin-top: 2px; }

/* Expectation list */
.co-expect-item { display: flex; align-items: flex-start; gap: 10px; padding: 10px 0; border-bottom: 1px solid var(--gray-100); font-size: 13px; color: var(--text-secondary); }
.co-expect-item:last-child { border-bottom: none; }
.co-expect-icon { font-size: 18px; flex-shrink: 0; }
</style>

<div class="co-profile-wrap">
  <div style="display:grid;grid-template-columns:minmax(0,1fr) 320px;gap:20px;align-items:start;">

    <!-- ── Main Column ──────────────────────────────────────────── -->
    <div>

      <!-- Hero -->
      <div style="position:relative;margin-bottom:16px;">
        <div class="co-cover"></div>
        <div class="co-logo-box">${fn:substring(company.companyName,0,1)}</div>
        <div class="co-hero-card">
          <div class="co-name">${company.companyName}</div>
          <div class="co-meta">${company.industry} &bull; ${company.city}
            <c:if test="${not empty company.foundedYear and company.foundedYear > 0}"> &bull; Est. ${company.foundedYear}</c:if>
          </div>
          <div class="co-badges">
            <span class="badge ${company.verified ? 'badge-verified' : 'badge-pending-co'}">${company.verified ? 'Verified Company' : 'Pending Verification'}</span>
            <c:if test="${not empty company.employeeCount}"><span class="badge badge-intern">${company.employeeCount} employees</span></c:if>
            <c:if test="${not empty company.industry}"><span class="badge badge-pending">${company.industry}</span></c:if>
          </div>
          <div class="co-actions">
            <c:if test="${not empty company.website}">
              <a href="https://${company.website}" target="_blank" rel="noopener" class="btn btn-outline btn-sm">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
                Website
              </a>
            </c:if>
            <c:if test="${not empty company.email}">
              <a href="mailto:${company.email}" class="btn btn-ghost btn-sm">Contact</a>
            </c:if>
          </div>
        </div>
      </div>

      <!-- Stats Row: Applicants + Jobs -->
      <div class="co-stats-row">
        <div class="co-stat-cell">
          <div class="co-stat-value" style="color:var(--success);">${fresherCount}</div>
          <div class="co-stat-label" style="color:var(--success);">Freshers</div>
          <div class="co-stat-sub">applicants</div>
        </div>
        <div class="co-stat-cell">
          <div class="co-stat-value" style="color:var(--primary);">${internCount}</div>
          <div class="co-stat-label" style="color:var(--primary);">Interns</div>
          <div class="co-stat-sub">applicants</div>
        </div>
        <div class="co-stat-cell">
          <div class="co-stat-value" style="color:var(--warning);">${experiencedCount}</div>
          <div class="co-stat-label" style="color:var(--warning);">Experienced</div>
          <div class="co-stat-sub">applicants</div>
        </div>
        <div class="co-stat-cell" style="border-left:2px solid var(--border);">
          <div class="co-stat-value">${fn:length(jobs)}</div>
          <div class="co-stat-label" style="color:var(--text-secondary);">Open Roles</div>
          <div class="co-stat-sub">active listings</div>
        </div>
        <div class="co-stat-cell">
          <div class="co-stat-value" style="color:var(--primary);">${internshipJobs}</div>
          <div class="co-stat-label" style="color:var(--primary);">Internship</div>
          <div class="co-stat-sub">positions</div>
        </div>
        <div class="co-stat-cell">
          <div class="co-stat-value" style="color:var(--success);">${fullTimeJobs}</div>
          <div class="co-stat-label" style="color:var(--success);">Full Time</div>
          <div class="co-stat-sub">positions</div>
        </div>
      </div>

      <!-- About -->
      <div class="co-section">
        <div class="co-section-title">About the Company</div>
        <p style="font-size:14px;line-height:1.7;color:var(--text-secondary);">${company.description}</p>
      </div>

      <!-- Culture Video -->
      <div class="co-section">
        <div class="co-section-title">Culture &amp; Work Environment</div>
        <c:choose>
          <c:when test="${not empty cultureVideoPath}">
            <video controls class="co-video" preload="metadata">
              <source src="${pageContext.request.contextPath}/${cultureVideoPath}" type="video/mp4"/>
              <source src="${pageContext.request.contextPath}/${cultureVideoPath}" type="video/webm"/>
              Your browser does not support video playback.
            </video>
            <p style="font-size:12px;color:var(--text-secondary);margin-top:10px;">Watch this video to learn about the company culture, internship experience, and work environment.</p>
          </c:when>
          <c:otherwise>
            <div class="co-video-placeholder">
              <div style="font-size:40px;margin-bottom:12px;">&#127916;</div>
              <div style="font-size:15px;font-weight:700;margin-bottom:6px;">No culture video yet</div>
              <div style="font-size:13px;">This company hasn't uploaded a culture video yet. Check back later!</div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Open Roles -->
      <div class="co-section">
        <div class="co-section-title">Open Roles <span style="font-size:13px;font-weight:400;color:var(--text-secondary);">(${fn:length(jobs)} active)</span></div>
        <c:choose>
          <c:when test="${not empty jobs}">
            <c:forEach var="job" items="${jobs}">
              <a href="${pageContext.request.contextPath}/jobs?id=${job.id}" class="co-job-card">
                <div>
                  <div style="font-size:14px;font-weight:700;">${job.title}</div>
                  <div style="font-size:12px;color:var(--text-secondary);margin-top:3px;">${job.location}
                    <c:if test="${not empty job.salaryRange}"> &bull; ${job.salaryRange}</c:if>
                    <c:if test="${not empty job.deadline}"> &bull; Deadline: ${job.deadline}</c:if>
                  </div>
                </div>
                <div style="display:flex;gap:6px;align-items:center;flex-shrink:0;">
                  <span class="badge badge-intern">${job.jobType}</span>
                  <span class="badge badge-${fn:toLowerCase(job.experienceRequired)}">${job.experienceRequired}</span>
                </div>
              </a>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div style="text-align:center;padding:28px;color:var(--text-secondary);font-size:13px;border:1px dashed var(--border);border-radius:12px;">
              No active job listings at the moment. Check back later!
            </div>
          </c:otherwise>
        </c:choose>
      </div>

    </div><!-- /main col -->

    <!-- ── Sidebar ───────────────────────────────────────────── -->
    <aside style="display:grid;gap:16px;position:sticky;top:80px;">

      <!-- Contact Card -->
      <div class="co-section" style="margin-bottom:0;">
        <div class="co-section-title">Company Info</div>
        <c:if test="${not empty company.email}">
          <div class="co-info-row">
            <svg class="co-info-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
            <div><div class="co-info-label">Email</div><div class="co-info-value">${company.email}</div></div>
          </div>
        </c:if>
        <c:if test="${not empty company.phone}">
          <div class="co-info-row">
            <svg class="co-info-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.6 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
            <div><div class="co-info-label">Phone</div><div class="co-info-value">${company.phone}</div></div>
          </div>
        </c:if>
        <c:if test="${not empty company.website}">
          <div class="co-info-row">
            <svg class="co-info-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
            <div><div class="co-info-label">Website</div><div class="co-info-value"><a href="https://${company.website}" target="_blank" style="color:var(--primary);">${company.website}</a></div></div>
          </div>
        </c:if>
        <c:if test="${not empty company.address}">
          <div class="co-info-row">
            <svg class="co-info-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            <div><div class="co-info-label">Address</div><div class="co-info-value">${company.address}</div></div>
          </div>
        </c:if>
        <c:if test="${not empty company.foundedYear and company.foundedYear > 0}">
          <div class="co-info-row">
            <svg class="co-info-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            <div><div class="co-info-label">Founded</div><div class="co-info-value">${company.foundedYear}</div></div>
          </div>
        </c:if>
        <c:if test="${not empty company.employeeCount}">
          <div class="co-info-row">
            <svg class="co-info-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            <div><div class="co-info-label">Team Size</div><div class="co-info-value">${company.employeeCount} employees</div></div>
          </div>
        </c:if>
      </div>

      <!-- Applicant Distribution -->
      <div class="co-section" style="margin-bottom:0;">
        <div class="co-section-title">Applicant Distribution</div>
        <c:set var="totalApp" value="${fresherCount + internCount + experiencedCount}"/>
        <c:if test="${totalApp > 0}">
          <div style="margin-bottom:12px;">
            <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:5px;">
              <span style="color:var(--success);font-weight:700;">Freshers</span>
              <span style="font-weight:700;">${fresherCount}</span>
            </div>
            <div style="height:8px;background:var(--gray-200);border-radius:4px;overflow:hidden;">
              <div style="height:8px;background:var(--success);border-radius:4px;width:${fresherCount * 100 / totalApp}%;transition:width 0.6s;"></div>
            </div>
          </div>
          <div style="margin-bottom:12px;">
            <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:5px;">
              <span style="color:var(--primary);font-weight:700;">Interns</span>
              <span style="font-weight:700;">${internCount}</span>
            </div>
            <div style="height:8px;background:var(--gray-200);border-radius:4px;overflow:hidden;">
              <div style="height:8px;background:var(--primary);border-radius:4px;width:${internCount * 100 / totalApp}%;transition:width 0.6s;"></div>
            </div>
          </div>
          <div>
            <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:5px;">
              <span style="color:var(--warning);font-weight:700;">Experienced</span>
              <span style="font-weight:700;">${experiencedCount}</span>
            </div>
            <div style="height:8px;background:var(--gray-200);border-radius:4px;overflow:hidden;">
              <div style="height:8px;background:var(--warning);border-radius:4px;width:${experiencedCount * 100 / totalApp}%;transition:width 0.6s;"></div>
            </div>
          </div>
        </c:if>
        <c:if test="${totalApp == 0}">
          <div style="text-align:center;padding:16px;color:var(--text-secondary);font-size:13px;">No applicants yet.</div>
        </c:if>
      </div>

      <!-- What Students Can Expect -->
      <div class="co-section" style="margin-bottom:0;">
        <div class="co-section-title">What to Expect</div>
        <div class="co-expect-item">
          <span class="co-expect-icon">&#128197;</span>
          <span>Structured internship program with real project exposure and mentorship.</span>
        </div>
        <div class="co-expect-item">
          <span class="co-expect-icon">&#127881;</span>
          <span>Transparent information about roles, pay, and growth opportunities before applying.</span>
        </div>
        <div class="co-expect-item">
          <span class="co-expect-icon">&#128101;</span>
          <span>Collaborative work environment with experienced professionals.</span>
        </div>
        <div class="co-expect-item">
          <span class="co-expect-icon">&#128188;</span>
          <span>Direct access to current openings for freshers, interns, and experienced candidates.</span>
        </div>
      </div>

    </aside>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>
