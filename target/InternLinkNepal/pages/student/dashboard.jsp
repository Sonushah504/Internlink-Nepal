<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<c:set var="pageTitle" value="Student Dashboard – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<style>
/* Post creation card */
.post-create-card {
  background: #fff;
  border: 1px solid var(--border);
  border-radius: 16px;
  padding: 18px 20px;
  margin-bottom: 16px;
}
.post-create-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 14px;
}
.post-create-avatar {
  width: 44px; height: 44px;
  border-radius: 50%;
  object-fit: cover;
  flex-shrink: 0;
  border: 2px solid var(--border);
}
.post-create-avatar-fb {
  width: 44px; height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, #185FA5, #2d7dd2);
  display: flex; align-items: center; justify-content: center;
  font-size: 18px; font-weight: 800; color: #fff;
  flex-shrink: 0;
}
.post-text-area {
  flex: 1;
  padding: 11px 16px;
  border: 1.5px solid var(--border);
  border-radius: 24px;
  font-size: 14px;
  resize: none;
  font-family: inherit;
  outline: none;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--text-secondary);
  background: var(--gray-50);
  height: 46px;
  overflow: hidden;
}
.post-text-area:focus, .post-text-area.expanded {
  border-color: var(--primary);
  background: #fff;
  box-shadow: 0 0 0 3px rgba(24,95,165,0.1);
  height: 120px;
  overflow: auto;
  resize: vertical;
  cursor: text;
  color: var(--text-primary);
}
.post-media-preview { display: none; margin-top: 12px; }
.post-media-preview.active { display: block; }
.post-media-preview img, .post-media-preview video {
  max-height: 200px;
  border-radius: 12px;
  border: 1px solid var(--border);
}
.post-action-btns {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  flex-wrap: wrap;
  padding-top: 12px;
  border-top: 1px solid var(--gray-100);
  margin-top: 12px;
}
.post-type-btn {
  display: flex; align-items: center; gap: 6px;
  padding: 7px 14px; border-radius: 20px;
  font-size: 12px; font-weight: 600;
  cursor: pointer; border: 1.5px solid var(--border);
  background: transparent; color: var(--text-secondary);
  transition: all 0.2s;
}
.post-type-btn:hover { border-color: var(--primary); color: var(--primary); background: var(--primary-light); }
.post-type-btn.active { border-color: var(--primary); color: var(--primary); background: var(--primary-light); }

/* Post feed */
.post-card {
  background: #fff;
  border: 1px solid var(--border);
  border-radius: 16px;
  overflow: hidden;
  margin-bottom: 14px;
  transition: all 0.2s;
}
.post-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
.post-header {
  padding: 16px 18px 12px;
  display: flex;
  align-items: center;
  gap: 12px;
}
.post-author-photo {
  width: 44px; height: 44px;
  border-radius: 50%; object-fit: cover;
  border: 2px solid var(--border); flex-shrink: 0;
}
.post-author-fb {
  width: 44px; height: 44px; border-radius: 50%;
  background: linear-gradient(135deg,#185FA5,#2d7dd2);
  display: flex; align-items: center; justify-content: center;
  font-size: 18px; font-weight: 800; color: #fff; flex-shrink: 0;
}
.post-author-name { font-size: 14px; font-weight: 700; color: var(--text-primary); }
.post-author-meta { font-size: 12px; color: var(--text-secondary); }
.post-time { font-size: 11px; color: var(--gray-400); margin-left: auto; flex-shrink: 0; }
.post-content { padding: 0 18px 14px; font-size: 14px; line-height: 1.65; color: var(--text-primary); }
.post-media { width: 100%; display: block; }
.post-media img { width: 100%; height: auto; object-fit: contain; }
.post-media-video { width: 100%; max-height: 420px; display: block; background: #000; }
.post-type-badge {
  display: inline-flex; align-items: center; gap: 4px;
  font-size: 10px; font-weight: 700; padding: 2px 8px;
  border-radius: 10px; margin-left: 8px;
}
</style>

<div class="dash-layout">
  <!-- Sidebar -->
  <aside class="dash-sidebar">
    <div class="dash-sidebar-brand">
      <div style="display:flex;align-items:center;gap:10px;margin-bottom:10px;">
        <img src="${pageContext.request.contextPath}/${profile.profilePhotoUrl}" alt="${profile.fullName}" style="width:42px;height:42px;border-radius:50%;object-fit:cover;border:2px solid var(--border);"/>
        <div>
          <h3>${profile.fullName}</h3>
          <p>${profile.university}</p>
        </div>
      </div>
    </div>
    <div class="sidebar-section-label">Main</div>
    <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-nav-item active">
      <i class="fa-solid fa-table-cells-large nav-icon"></i>
      Overview
    </a>
    <a href="${pageContext.request.contextPath}/jobs" class="sidebar-nav-item">
      <i class="fa-solid fa-briefcase nav-icon"></i>
      Browse Jobs
    </a>
    <a href="${pageContext.request.contextPath}/student/applications" class="sidebar-nav-item">
      <i class="fa-solid fa-file-lines nav-icon"></i>
      My Applications
    </a>
    <div class="sidebar-section-label">Profile</div>
    <a href="${pageContext.request.contextPath}/student/profile" class="sidebar-nav-item">
      <i class="fa-solid fa-user nav-icon"></i>
      My Profile
    </a>
    <a href="${pageContext.request.contextPath}/student/portfolio" class="sidebar-nav-item">
      <i class="fa-solid fa-star nav-icon"></i>
      Portfolio
    </a>
    <c:if test="${not empty profile}">
      <a href="${pageContext.request.contextPath}/profiles/student?id=${profile.id}" class="sidebar-nav-item">
        <i class="fa-solid fa-id-card nav-icon"></i>
        Public Profile
      </a>
    </c:if>
    <div style="padding:20px;margin-top:auto;">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm btn-block">Sign Out</a>
    </div>
  </aside>

  <!-- Main content -->
  <main class="dash-main">
    <div class="dash-header">
      <h1>Welcome back, ${profile.fullName.split(' ')[0]}</h1>
      <p>Here's what's happening with your job search today.</p>
    </div>

    <c:if test="${param.profileSaved == '1'}">
      <div class="alert alert-success" data-auto-dismiss style="margin-bottom:16px;">Profile details updated. Changes appear everywhere on the site.</div>
    </c:if>

    <!-- Metric cards -->
    <div class="metric-cards">
      <div class="metric-card mc-blue">
        <div class="mc-icon"><i class="fa-solid fa-file-lines"></i></div>
        <div class="mc-label">Total Applications</div>
        <div class="mc-value">${fn:length(applications)}</div>
      </div>
      <div class="metric-card mc-orange">
        <div class="mc-icon"><i class="fa-solid fa-hourglass-half"></i></div>
        <div class="mc-label">Pending</div>
        <div class="mc-value">${pending}</div>
      </div>
      <div class="metric-card mc-green">
        <div class="mc-icon"><i class="fa-solid fa-award"></i></div>
        <div class="mc-label">Shortlisted</div>
        <div class="mc-value">${shortlisted}</div>
      </div>
      <div class="metric-card mc-green">
        <div class="mc-icon"><i class="fa-solid fa-circle-check"></i></div>
        <div class="mc-label">Selected</div>
        <div class="mc-value">${selected}</div>
      </div>
    </div>

    <!-- Profile completeness -->
    <div class="card mb-3">
      <div class="card-body">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;">
          <div>
            <div style="font-size:15px;font-weight:600;">Profile Completeness</div>
            <div style="font-size:13px;color:var(--text-secondary);">Complete your profile to get better job matches</div>
          </div>
          <div style="font-size:24px;font-weight:800;color:var(--primary);">${profile.profileScore}%</div>
        </div>
        <div class="progress profile-completeness-bar" data-score="${profile.profileScore}">
          <div class="progress-bar" style="width:${profile.profileScore}%"></div>
        </div>
        <c:if test="${profile.profileScore < 100}">
          <div style="margin-top:10px;font-size:13px;color:var(--text-secondary);">
            <i class="fa-solid fa-lightbulb" style="color:var(--warning);margin-right:4px;"></i><a href="${pageContext.request.contextPath}/student/profile" style="color:var(--primary);">Complete your profile</a> to improve visibility to companies.
          </div>
        </c:if>
      </div>
    </div>

    <!-- ── Main Grid: Feed + Sidebar ──────────────────────────── -->
    <div style="display:grid;grid-template-columns:1fr 320px;gap:20px;align-items:start;">

      <!-- Left: Post + Feed -->
      <div>

        <!-- Create Post Card -->
        <div class="post-create-card">
          <div class="post-create-header">
            <img src="${pageContext.request.contextPath}/${profile.profilePhotoUrl}" alt="${profile.fullName}" class="post-create-avatar"/>
            <textarea id="postTextArea" class="post-text-area" placeholder="Share work updates, projects, learnings, or achievements..." rows="1" onclick="expandPost()"></textarea>
          </div>

          <div id="postExpandedArea" style="display:none;">
            <div class="post-media-preview" id="mediaPreview">
              <img id="mediaPreviewImg" src="" alt="" style="display:none;"/>
              <video id="mediaPreviewVideo" controls style="display:none;"></video>
              <div style="display:flex;justify-content:flex-end;margin-top:6px;">
                <button type="button" onclick="clearMedia()" class="btn btn-ghost btn-sm" style="font-size:11px;">Remove</button>
              </div>
            </div>
            <div class="post-action-btns">
              <div style="display:flex;gap:8px;flex-wrap:wrap;">
                <button type="button" class="post-type-btn" id="btnPhoto" onclick="triggerMediaUpload('image/*')">
                  <i class="fa-solid fa-image"></i>
                  Photo
                </button>
                <button type="button" class="post-type-btn" id="btnVideo" onclick="triggerMediaUpload('video/*')">
                  <i class="fa-solid fa-video"></i>
                  Video
                </button>
                <button type="button" class="post-type-btn" id="btnText" onclick="setTextOnly()">
                  <i class="fa-solid fa-align-left"></i>
                  Text Only
                </button>
              </div>
              <form action="${pageContext.request.contextPath}/student/posts/create" method="post" enctype="multipart/form-data" id="postCreateForm">
                <input type="hidden" name="content" id="postContentInput"/>
                <input type="file" id="mediaFileInput" name="media" style="display:none;" accept="image/*,video/*" onchange="previewMedia(this)"/>
                <button type="button" onclick="submitPost()" class="btn btn-primary btn-sm">Post</button>
              </form>
            </div>
          </div>
        </div>

        <!-- Recent Applications table (collapsible) -->
        <div class="table-card" style="margin-bottom:16px;">
          <div class="table-card-header">
            <h3>Recent Applications</h3>
            <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-ghost btn-sm">View All</a>
          </div>
          <table class="data-table">
            <thead>
              <tr>
                <th>Job Title</th>
                <th>Company</th>
                <th>Applied</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty applications}">
                  <c:forEach var="app" items="${applications}" end="4">
                    <tr>
                      <td style="font-weight:500;">${app.jobTitle}</td>
                      <td style="color:var(--text-secondary);">${app.companyName}</td>
                      <td style="color:var(--text-secondary);font-size:13px;">${fn:substring(app.appliedAt,0,10)}</td>
                      <td><span class="badge badge-${fn:toLowerCase(app.status)}">${app.status}</span></td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="4" style="text-align:center;padding:32px;color:var(--text-secondary);">
                    No applications yet. <a href="${pageContext.request.contextPath}/jobs" style="color:var(--primary);">Browse jobs</a>
                  </td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <!-- Work Posts Feed -->
        <div style="font-size:15px;font-weight:700;margin-bottom:12px;display:flex;align-items:center;gap:8px;">
          Community Feed
          <span style="font-size:12px;color:var(--text-secondary);font-weight:400;">${fn:length(posts)} posts</span>
        </div>

        <c:choose>
          <c:when test="${not empty posts}">
            <c:forEach var="post" items="${posts}">
              <div class="post-card">
                <div class="post-header">
                  <img src="${pageContext.request.contextPath}/${post.studentProfilePhotoUrl}" alt="${post.studentName}" class="post-author-photo"/>
                  <div style="min-width:0;">
                    <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap;">
                      <a href="${pageContext.request.contextPath}/profiles/student?id=${post.studentId}" class="post-author-name" style="color:var(--primary);">${post.studentName}</a>
                      <c:choose>
                        <c:when test="${post.mediaType == 'PHOTO'}">
                          <span class="post-type-badge" style="background:var(--primary-light);color:var(--primary);"><i class="fa-solid fa-image"></i> Photo</span>
                        </c:when>
                        <c:when test="${post.mediaType == 'VIDEO'}">
                          <span class="post-type-badge" style="background:var(--warning-light);color:var(--warning);"><i class="fa-solid fa-video"></i> Video</span>
                        </c:when>
                        <c:otherwise>
                          <span class="post-type-badge" style="background:var(--gray-100);color:var(--gray-600);"><i class="fa-solid fa-align-left"></i> Text</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div class="post-author-meta">${post.studentProgram} &bull; ${post.studentUniversity}</div>
                  </div>
                  <span class="post-time" title="${post.createdAt}">
                    <c:if test="${not empty post.createdAt}">${fn:substring(post.createdAt,0,10)}</c:if>
                  </span>
                </div>

                <c:if test="${not empty post.content}">
                  <div class="post-content">${post.content}</div>
                </c:if>

                <c:if test="${not empty post.mediaPath}">
                  <c:choose>
                    <c:when test="${post.mediaType == 'PHOTO'}">
                      <img src="${pageContext.request.contextPath}/${post.mediaPath}" alt="Post image" class="post-media" loading="lazy"/>
                    </c:when>
                    <c:when test="${post.mediaType == 'VIDEO'}">
                      <video controls class="post-media-video">
                        <source src="${pageContext.request.contextPath}/${post.mediaPath}"/>
                      </video>
                    </c:when>
                  </c:choose>
                </c:if>

              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div style="text-align:center;padding:40px 20px;background:#fff;border:1px dashed var(--border);border-radius:16px;color:var(--text-secondary);">
              <div style="font-size:36px;margin-bottom:12px;"><i class="fa-regular fa-comments"></i></div>
              <div style="font-size:15px;font-weight:600;margin-bottom:6px;">No posts yet</div>
              <div style="font-size:13px;">Be the first to share your work, project, or achievement!</div>
            </div>
          </c:otherwise>
        </c:choose>

      </div><!-- /left col -->

      <!-- Right Sidebar -->
      <div style="display:grid;gap:16px;">

        <!-- Recommended Jobs -->
        <div>
          <div style="font-size:15px;font-weight:700;margin-bottom:12px;">Recommended for You</div>
          <c:choose>
            <c:when test="${not empty recommended}">
              <c:forEach var="job" items="${recommended}">
                <div class="card job-card" style="margin-bottom:10px;" onclick="location.href='${pageContext.request.contextPath}/jobs?id=${job.id}'">
                  <div class="card-body" style="padding:14px;">
                    <div style="display:flex;align-items:center;gap:10px;margin-bottom:8px;">
                      <div class="company-logo-wrap" style="width:34px;height:34px;font-size:12px;">${fn:substring(job.companyName,0,2)}</div>
                      <div>
                        <div style="font-size:13px;font-weight:600;">${job.title}</div>
                        <div style="font-size:12px;color:var(--text-secondary);">${job.companyName}</div>
                      </div>
                    </div>
                    <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;">
                      <span style="font-size:12px;color:var(--text-secondary);"><i class="fa-solid fa-location-dot"></i> ${job.companyCity}</span>
                      <span class="badge badge-fresher" style="font-size:10px;">${job.jobType}</span>
                      <div style="margin-left:auto;">
                        <c:choose>
                          <c:when test="${sessionScope.userRole == 'STUDENT'}">
                            <form id="applyFormRec-${job.id}" action="${pageContext.request.contextPath}/student/apply" method="post" style="display:inline;">
                              <input type="hidden" name="jobId" value="${job.id}"/>
                              <button type="button" class="btn btn-primary btn-sm" onclick="event.stopPropagation();document.getElementById('applyFormRec-${job.id}').submit();">Apply</button>
                            </form>
                          </c:when>
                          <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm" onclick="event.stopPropagation();">Login</a>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div style="text-align:center;padding:20px;color:var(--text-secondary);font-size:13px;background:#fff;border:1px solid var(--border);border-radius:12px;">
                <a href="${pageContext.request.contextPath}/student/profile" style="color:var(--primary);">Add skills to your profile</a> to get recommendations.
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <!-- Profile Summary (view until Edit details, then save updates globally) -->
        <div class="card" id="dashProfileCard">
          <div class="card-body">
            <div style="display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:14px;">
              <h3 style="font-size:15px;font-weight:700;">Profile Summary</h3>
              <div style="display:flex;gap:8px;">
                <button type="button" id="dashProfileEditBtn" class="btn btn-outline btn-sm" onclick="dashProfileEnterEdit()">Edit details</button>
                <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-ghost btn-sm">Full profile</a>
              </div>
            </div>

            <div id="dashProfileView" style="display:grid;gap:10px;font-size:13px;">
              <div><span style="color:var(--text-secondary);">University: </span><strong id="pvUni">${profile.university}</strong></div>
              <div><span style="color:var(--text-secondary);">Program: </span><strong id="pvProg">${profile.program}</strong></div>
              <div><span style="color:var(--text-secondary);">Semester: </span><strong id="pvSem">${profile.semester}</strong></div>
              <div><span style="color:var(--text-secondary);">CGPA: </span><strong id="pvCgpa">${profile.cgpa}</strong></div>
              <div><span style="color:var(--text-secondary);">Level: </span><span id="pvExpBadge" class="badge badge-${fn:toLowerCase(profile.experienceType)}">${profile.experienceType}</span></div>
            </div>

            <form id="dashProfileForm" action="${pageContext.request.contextPath}/student/profile" method="post" style="display:none;margin-top:12px;">
              <input type="hidden" name="dashboardProfile" value="1"/>
              <div style="display:grid;gap:10px;">
                <label class="form-label" style="margin:0;font-size:12px;">University</label>
                <input type="text" name="university" class="form-control form-control-sm" value="${profile.university}" required/>
                <label class="form-label" style="margin:0;font-size:12px;">Program</label>
                <input type="text" name="program" class="form-control form-control-sm" value="${profile.program}" required/>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
                  <div>
                    <label class="form-label" style="margin:0;font-size:12px;">Semester</label>
                    <input type="number" name="semester" min="1" max="12" class="form-control form-control-sm" value="${profile.semester > 0 ? profile.semester : ''}" required/>
                  </div>
                  <div>
                    <label class="form-label" style="margin:0;font-size:12px;">CGPA</label>
                    <input type="number" name="cgpa" step="0.01" min="0" max="4" class="form-control form-control-sm" value="${profile.cgpa > 0 ? profile.cgpa : ''}" required/>
                  </div>
                </div>
                <label class="form-label" style="margin:0;font-size:12px;">Experience level</label>
                <select name="experienceType" class="form-control form-control-sm" required>
                  <option value="FRESHER" ${profile.experienceType == 'FRESHER' ? 'selected' : ''}>Fresher</option>
                  <option value="INTERN" ${profile.experienceType == 'INTERN' ? 'selected' : ''}>Intern</option>
                  <option value="EXPERIENCED" ${profile.experienceType == 'EXPERIENCED' ? 'selected' : ''}>Experienced</option>
                </select>
                <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:8px;">
                  <button type="button" class="btn btn-ghost btn-sm" onclick="dashProfileCancelEdit()">Cancel</button>
                  <button type="submit" class="btn btn-primary btn-sm">Save details</button>
                </div>
              </div>
            </form>
          </div>
        </div>

        <!-- Related Profiles -->
        <c:if test="${not empty relatedProfiles}">
          <div class="card">
            <div class="card-body">
              <h3 style="font-size:15px;font-weight:700;margin-bottom:14px;">People in Similar Fields</h3>
              <div style="display:grid;gap:10px;">
                <c:forEach var="person" items="${relatedProfiles}" end="4">
                  <a href="${pageContext.request.contextPath}/profiles/student?id=${person.id}" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border:1px solid var(--border);border-radius:12px;transition:all 0.2s;text-decoration:none;color:inherit;" onmouseover="this.style.borderColor='var(--primary)';this.style.background='var(--primary-light)'" onmouseout="this.style.borderColor='var(--border)';this.style.background='transparent'">
                    <img src="${pageContext.request.contextPath}/${person.profilePhotoUrl}" alt="${person.fullName}" style="width:40px;height:40px;border-radius:50%;object-fit:cover;flex-shrink:0;border:2px solid var(--border);"/>
                    <div style="min-width:0;">
                      <div style="font-size:13px;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${person.fullName}</div>
                      <div style="font-size:11px;color:var(--text-secondary);">${person.program}</div>
                    </div>
                  </a>
                </c:forEach>
              </div>
            </div>
          </div>
        </c:if>

      </div><!-- /right sidebar -->
    </div><!-- /main grid -->

  </main>
</div>

<script>
// ── Post creation ───────────────────────────────────────────────
var mediaFileSelected = null;
var postExpanded = false;

function expandPost() {
  if (postExpanded) return;
  postExpanded = true;
  var ta = document.getElementById('postTextArea');
  var extra = document.getElementById('postExpandedArea');
  ta.classList.add('expanded');
  extra.style.display = 'block';
}

function triggerMediaUpload(accept) {
  var input = document.getElementById('mediaFileInput');
  input.accept = accept;
  input.click();
}

function setTextOnly() {
  clearMedia();
  document.getElementById('btnText').classList.add('active');
  document.getElementById('btnPhoto').classList.remove('active');
  document.getElementById('btnVideo').classList.remove('active');
}

function previewMedia(input) {
  var file = input.files && input.files[0];
  if (!file) return;
  mediaFileSelected = file;

  var preview = document.getElementById('mediaPreview');
  var imgEl = document.getElementById('mediaPreviewImg');
  var vidEl = document.getElementById('mediaPreviewVideo');
  preview.classList.add('active');

  if (file.type.startsWith('image/')) {
    var reader = new FileReader();
    reader.onload = function(e) {
      imgEl.src = e.target.result;
      imgEl.style.display = 'block';
      vidEl.style.display = 'none';
    };
    reader.readAsDataURL(file);
    document.getElementById('btnPhoto').classList.add('active');
    document.getElementById('btnVideo').classList.remove('active');
  } else if (file.type.startsWith('video/')) {
    var url = URL.createObjectURL(file);
    vidEl.src = url;
    vidEl.style.display = 'block';
    imgEl.style.display = 'none';
    document.getElementById('btnVideo').classList.add('active');
    document.getElementById('btnPhoto').classList.remove('active');
  }
}

function clearMedia() {
  mediaFileSelected = null;
  var input = document.getElementById('mediaFileInput');
  input.value = '';
  var preview = document.getElementById('mediaPreview');
  preview.classList.remove('active');
  document.getElementById('mediaPreviewImg').style.display = 'none';
  document.getElementById('mediaPreviewVideo').style.display = 'none';
  document.getElementById('btnPhoto').classList.remove('active');
  document.getElementById('btnVideo').classList.remove('active');
  document.getElementById('btnText').classList.remove('active');
}

function submitPost() {
  var content = document.getElementById('postTextArea').value.trim();
  var hasMedia = document.getElementById('mediaFileInput').files && document.getElementById('mediaFileInput').files.length > 0;

  if (!content && !hasMedia) {
    alert('Please write something or attach a photo/video before posting.');
    return;
  }

  document.getElementById('postContentInput').value = content;
  document.getElementById('postCreateForm').submit();
}

// Collapse post area if clicking outside
document.addEventListener('click', function(e) {
  if (!postExpanded) return;
  var createCard = document.querySelector('.post-create-card');
  if (createCard && !createCard.contains(e.target)) {
    var ta = document.getElementById('postTextArea');
    var extra = document.getElementById('postExpandedArea');
    var hasContent = ta.value.trim().length > 0;
    var hasMedia = document.getElementById('mediaFileInput').files && document.getElementById('mediaFileInput').files.length > 0;
    if (!hasContent && !hasMedia) {
      ta.classList.remove('expanded');
      extra.style.display = 'none';
      postExpanded = false;
    }
  }
});

function dashProfileEnterEdit() {
  var v = document.getElementById('dashProfileView');
  var f = document.getElementById('dashProfileForm');
  var b = document.getElementById('dashProfileEditBtn');
  if (v) v.style.display = 'none';
  if (f) f.style.display = 'block';
  if (b) b.style.display = 'none';
}

function dashProfileCancelEdit() {
  var v = document.getElementById('dashProfileView');
  var f = document.getElementById('dashProfileForm');
  var b = document.getElementById('dashProfileEditBtn');
  if (v) v.style.display = 'grid';
  if (f) f.style.display = 'none';
  if (b) b.style.display = 'inline-flex';
}
</script>

<jsp:include page="/components/footer.jsp"/>
