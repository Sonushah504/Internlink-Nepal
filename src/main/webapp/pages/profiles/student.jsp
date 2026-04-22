<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${profile.fullName} - Student Profile"/>
<jsp:include page="/components/header.jsp"/>

<style>
.pub-profile-wrap { max-width: 1200px; margin: 0 auto; padding: 28px 24px; }

/* Cover + Avatar hero */
.pub-cover {
  height: 180px;
  background: linear-gradient(120deg, #0f2544 0%, #185FA5 55%, #2d7dd2 100%);
  border-radius: 20px 20px 0 0;
  position: relative;
}
.pub-avatar-wrap {
  position: absolute;
  bottom: -56px;
  left: 40px;
  transform: translateY(0);
}
.pub-avatar-img { border-radius: 50%; width:110px; height:110px; }
.pub-avatar-img {
  width: 110px; height: 110px;
  border-radius: 50%;
  object-fit: cover;
  border: 5px solid #fff;
  box-shadow: 0 4px 16px rgba(0,0,0,0.18);
  display: block;
  background: var(--primary-light);
}
.pub-avatar-fallback {
  width: 110px; height: 110px;
  border-radius: 50%;
  border: 5px solid #fff;
  box-shadow: 0 4px 16px rgba(0,0,0,0.18);
  background: linear-gradient(135deg, #185FA5, #2d7dd2);
  display: flex; align-items: center; justify-content: center;
  font-size: 40px; font-weight: 800; color: #fff;
}
.pub-profile-card {
  background: #fff;
  border: 1px solid var(--border);
  border-radius: 0 0 20px 20px;
  border-top: none;
  padding: 68px 28px 24px;
}
.pub-profile-name { font-size: 26px; font-weight: 800; color: var(--text-primary); line-height: 1.2; }
.pub-profile-title { font-size: 15px; color: var(--text-secondary); margin-top: 4px; }
.pub-profile-location { font-size: 13px; color: var(--text-secondary); margin-top: 6px; display: flex; align-items: center; gap: 6px; }
.pub-badges { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 12px; }
.pub-score-bar { margin-top: 16px; }
.pub-score-label { font-size: 12px; color: var(--text-secondary); margin-bottom: 6px; display: flex; align-items: center; justify-content: space-between; }
.pub-score-wrap { height: 6px; background: var(--gray-200); border-radius: 3px; overflow: hidden; }
.pub-score-fill { height: 6px; border-radius: 3px; background: linear-gradient(90deg, #185FA5, #2d7dd2); transition: width 0.8s ease; }

/* Action buttons under avatar */
.pub-actions { margin-top: 14px; display: flex; gap: 10px; flex-wrap: wrap; }

/* Sections */
.pub-section { background: #fff; border: 1px solid var(--border); border-radius: 16px; padding: 22px; margin-bottom: 16px; }
.pub-section-title { font-size: 16px; font-weight: 700; color: var(--text-primary); margin-bottom: 14px; display: flex; align-items: center; gap: 10px; }
.pub-section-title::after { content: ''; flex: 1; height: 1px; background: var(--gray-100); }
.pub-bio { font-size: 14px; color: var(--text-secondary); line-height: 1.7; }

/* Skills */
.pub-skills-grid { display: flex; flex-wrap: wrap; gap: 8px; }
.pub-skill-tag {
  background: var(--primary-light);
  color: var(--primary);
  font-size: 12px; font-weight: 600;
  padding: 5px 14px; border-radius: 20px;
  border: 1px solid rgba(24,95,165,0.18);
  transition: all 0.2s;
}
.pub-skill-tag:hover { background: var(--primary); color: #fff; }

/* Academic card */
.pub-academic-grid { display: grid; grid-template-columns: repeat(2,1fr); gap: 14px; }
.pub-stat-item { padding: 14px 16px; background: var(--gray-50); border-radius: 12px; border: 1px solid var(--border); }
.pub-stat-label { font-size: 11px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 4px; }
.pub-stat-value { font-size: 15px; font-weight: 700; color: var(--text-primary); }

/* Links */
.pub-link { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border: 1px solid var(--border); border-radius: 10px; font-size: 13px; font-weight: 600; color: var(--primary); transition: all 0.2s; margin-bottom: 8px; }
.pub-link:hover { background: var(--primary-light); border-color: var(--primary); }
.pub-link svg { flex-shrink: 0; }

/* Sidebar related profiles */
.related-card {
  display: flex; align-items: center; gap: 12px;
  padding: 12px 14px; border: 1px solid var(--border);
  border-radius: 14px; text-decoration: none; color: inherit;
  transition: all 0.2s; margin-bottom: 10px;
}
.related-card:hover { border-color: var(--primary); background: var(--primary-light); box-shadow: 0 2px 8px rgba(24,95,165,0.12); }
.related-avatar { width: 46px; height: 46px; border-radius: 50%; object-fit: cover; flex-shrink: 0; border: 2px solid var(--border); }
.related-avatar-fb { width: 46px; height: 46px; border-radius: 50%; background: linear-gradient(135deg,#185FA5,#2d7dd2); display: flex; align-items: center; justify-content: center; font-size: 18px; font-weight: 800; color: #fff; flex-shrink: 0; }
.related-name { font-size: 13px; font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.related-sub { font-size: 11px; color: var(--text-secondary); }

/* Application history */
.app-row { padding: 12px 14px; border: 1px solid var(--border); border-radius: 12px; display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 8px; }
.app-row:last-child { margin-bottom: 0; }
</style>

<div class="pub-profile-wrap">
  <div style="display:grid;grid-template-columns:minmax(0,1fr) 320px;gap:20px;align-items:start;">

    <!-- ── Main Column ──────────────────────────────────────────── -->
    <div>

      <!-- Profile Hero Card -->
      <div style="position:relative;margin-bottom:16px;">
        <div class="pub-cover"></div>
        <div class="pub-avatar-wrap">
          <c:choose>
            <c:when test="${not empty profile.profilePhoto}">
              <img src="${pageContext.request.contextPath}/${profile.profilePhoto}" alt="${profile.fullName}" class="pub-avatar-img"/>
            </c:when>
            <c:otherwise>
              <div class="pub-avatar-fallback">${fn:substring(profile.fullName,0,1)}</div>
            </c:otherwise>
          </c:choose>
        </div>
        <div class="pub-profile-card">
          <div class="pub-profile-name">${profile.fullName}</div>
          <div class="pub-profile-title">${profile.program}
            <c:if test="${not empty profile.university}"> at ${profile.university}</c:if>
          </div>
          <div class="pub-profile-location">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            ${empty profile.address ? 'Nepal' : profile.address}
          </div>
          <div class="pub-badges">
            <span class="badge badge-${fn:toLowerCase(profile.experienceType)}">${profile.experienceType}</span>
            <c:if test="${profile.cgpa > 0}"><span class="badge badge-intern">CGPA ${profile.cgpa}</span></c:if>
            <c:if test="${profile.semester > 0}"><span class="badge badge-fresher">Semester ${profile.semester}</span></c:if>
            <c:if test="${not empty profile.university}"><span class="badge badge-pending">${profile.university}</span></c:if>
          </div>
          <div class="pub-score-bar">
            <div class="pub-score-label">
              <span>Profile Strength</span>
              <span style="font-weight:700;color:var(--primary);">${profile.profileScore}%</span>
            </div>
            <div class="pub-score-wrap">
              <div class="pub-score-fill" style="width:${profile.profileScore}%"></div>
            </div>
          </div>
          <div class="pub-actions">
            <c:if test="${not empty profile.githubUrl}">
              <a href="https://${profile.githubUrl}" target="_blank" rel="noopener" class="btn btn-outline btn-sm">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg>
                GitHub
              </a>
            </c:if>
            <c:if test="${not empty profile.linkedinUrl}">
              <a href="https://${profile.linkedinUrl}" target="_blank" rel="noopener" class="btn btn-outline btn-sm">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>
                LinkedIn
              </a>
            </c:if>
            <c:if test="${not empty profile.email}">
              <a href="mailto:${profile.email}" class="btn btn-ghost btn-sm">Email</a>
            </c:if>
          </div>
        </div>
      </div>

      <!-- About / Bio -->
      <c:if test="${not empty profile.bio}">
        <div class="pub-section">
          <div class="pub-section-title">About</div>
          <p class="pub-bio">${profile.bio}</p>
        </div>
      </c:if>

      <!-- Academic Details -->
      <div class="pub-section">
        <div class="pub-section-title">Academic Background</div>
        <div class="pub-academic-grid">
          <div class="pub-stat-item">
            <div class="pub-stat-label">University</div>
            <div class="pub-stat-value">${empty profile.university ? '—' : profile.university}</div>
          </div>
          <div class="pub-stat-item">
            <div class="pub-stat-label">Program</div>
            <div class="pub-stat-value">${empty profile.program ? '—' : profile.program}</div>
          </div>
          <div class="pub-stat-item">
            <div class="pub-stat-label">Semester</div>
            <div class="pub-stat-value">${profile.semester > 0 ? profile.semester : '—'}</div>
          </div>
          <div class="pub-stat-item">
            <div class="pub-stat-label">CGPA</div>
            <div class="pub-stat-value">${profile.cgpa > 0 ? profile.cgpa : '—'}</div>
          </div>
          <div class="pub-stat-item">
            <div class="pub-stat-label">Experience Level</div>
            <div><span class="badge badge-${fn:toLowerCase(profile.experienceType)}">${profile.experienceType}</span></div>
          </div>
          <div class="pub-stat-item">
            <div class="pub-stat-label">Profile Score</div>
            <div class="pub-stat-value" style="color:var(--primary);">${profile.profileScore}%</div>
          </div>
        </div>
      </div>

      <!-- Skills -->
      <c:if test="${not empty profile.skills}">
        <div class="pub-section">
          <div class="pub-section-title">Skills</div>
          <div class="pub-skills-grid">
            <c:forTokens var="skill" items="${profile.skills}" delims=",">
              <span class="pub-skill-tag">${fn:trim(skill)}</span>
            </c:forTokens>
          </div>
        </div>
      </c:if>

      <!-- Application Activity -->
      <c:if test="${not empty applications}">
        <div class="pub-section">
          <div class="pub-section-title">Recent Activity</div>
          <c:forEach var="app" items="${applications}" end="4">
            <div class="app-row">
              <div>
                <div style="font-weight:700;font-size:14px;">${app.jobTitle}</div>
                <div style="font-size:12px;color:var(--text-secondary);">${app.companyName}</div>
              </div>
              <span class="badge badge-${fn:toLowerCase(app.status)}">${app.status}</span>
            </div>
          </c:forEach>
        </div>
      </c:if>

    </div><!-- /main col -->

    <!-- ── Sidebar ────────────────────────────────────────────── -->
    <aside style="display:grid;gap:16px;position:sticky;top:80px;">

      <!-- Contact Card -->
      <div class="pub-section" style="margin-bottom:0;">
        <div class="pub-section-title">Contact Info</div>
        <div style="display:grid;gap:8px;font-size:13px;">
          <c:if test="${not empty profile.email}">
            <div style="display:flex;gap:8px;align-items:flex-start;">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--text-secondary)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-top:2px;flex-shrink:0;"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
              <span>${profile.email}</span>
            </div>
          </c:if>
          <c:if test="${not empty profile.phone}">
            <div style="display:flex;gap:8px;align-items:flex-start;">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--text-secondary)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-top:2px;flex-shrink:0;"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.6 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
              <span>${profile.phone}</span>
            </div>
          </c:if>
          <c:if test="${not empty profile.address}">
            <div style="display:flex;gap:8px;align-items:flex-start;">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--text-secondary)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-top:2px;flex-shrink:0;"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
              <span>${profile.address}</span>
            </div>
          </c:if>
          <c:if test="${not empty profile.githubUrl}">
            <div style="display:flex;gap:8px;align-items:flex-start;">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="var(--text-secondary)" style="margin-top:2px;flex-shrink:0;"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg>
              <a href="https://${profile.githubUrl}" target="_blank" style="color:var(--primary);word-break:break-all;">${profile.githubUrl}</a>
            </div>
          </c:if>
          <c:if test="${not empty profile.linkedinUrl}">
            <div style="display:flex;gap:8px;align-items:flex-start;">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="var(--text-secondary)" style="margin-top:2px;flex-shrink:0;"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>
              <a href="https://${profile.linkedinUrl}" target="_blank" style="color:var(--primary);word-break:break-all;">${profile.linkedinUrl}</a>
            </div>
          </c:if>
        </div>
      </div>

      <!-- People in Similar Fields -->
      <div class="pub-section" style="margin-bottom:0;">
        <div class="pub-section-title">People in Similar Fields</div>
        <c:forEach var="person" items="${relatedProfiles}">
          <a href="${pageContext.request.contextPath}/profiles/student?id=${person.id}" class="related-card">
            <c:choose>
              <c:when test="${not empty person.profilePhoto}">
                <img src="${pageContext.request.contextPath}/${person.profilePhoto}" alt="${person.fullName}" class="related-avatar"/>
              </c:when>
              <c:otherwise>
                <div class="related-avatar-fb">${fn:substring(person.fullName,0,1)}</div>
              </c:otherwise>
            </c:choose>
            <div style="min-width:0;">
              <div class="related-name">${person.fullName}</div>
              <div class="related-sub">${person.program}</div>
              <div class="related-sub">${person.university}</div>
              <span class="badge badge-${fn:toLowerCase(person.experienceType)}" style="font-size:10px;margin-top:4px;">${person.experienceType}</span>
            </div>
          </a>
        </c:forEach>
        <c:if test="${empty relatedProfiles}">
          <div style="text-align:center;padding:20px;color:var(--text-secondary);font-size:13px;border:1px dashed var(--border);border-radius:12px;">
            No related profiles found yet.
          </div>
        </c:if>
      </div>

    </aside>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>
