<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Student Profile - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<style>
.profile-edit-page { max-width:1280px;margin:0 auto;padding:28px 24px; }
.profile-hero-card {
  background: linear-gradient(135deg, #0f2544 0%, #185FA5 60%, #2d7dd2 100%);
  border-radius: 20px;
  padding: 32px;
  color: #fff;
  display: flex;
  gap: 24px;
  align-items: flex-start;
  flex-wrap: wrap;
  margin-bottom: 0;
  position: relative;
  overflow: hidden;
}
.profile-hero-card::before {
  content: '';
  position: absolute;
  top: -60px;
  right: -60px;
  width: 220px;
  height: 220px;
  border-radius: 50%;
  background: rgba(255,255,255,0.06);
}
.profile-photo-wrap {
  position: relative;
  flex-shrink: 0;
}
.profile-photo-img {
  width: 120px;
  height: 120px;
  border-radius: 24px;
  object-fit: cover;
  border: 4px solid rgba(255,255,255,0.8);
  box-shadow: 0 8px 24px rgba(0,0,0,0.2);
  display: block;
}
.profile-photo-fallback {
  width: 120px;
  height: 120px;
  border-radius: 24px;
  background: rgba(255,255,255,0.18);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 44px;
  font-weight: 800;
  color: #fff;
  border: 4px solid rgba(255,255,255,0.4);
  flex-shrink: 0;
}
.profile-photo-upload-btn {
  position: absolute;
  bottom: -8px;
  right: -8px;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #fff;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
  transition: all 0.2s;
  color: var(--primary);
}
.profile-photo-upload-btn:hover { transform: scale(1.1); }
.profile-hero-info { flex: 1; min-width: 240px; }
.profile-hero-name { font-size: 28px; font-weight: 800; line-height: 1.2; margin-bottom: 6px; }
.profile-hero-sub  { font-size: 14px; opacity: 0.85; margin-bottom: 12px; }
.profile-hero-badges { display: flex; gap: 8px; flex-wrap: wrap; }
.profile-hero-badge {
  background: rgba(255,255,255,0.18);
  color: #fff;
  font-size: 11px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 20px;
  border: 1px solid rgba(255,255,255,0.25);
}

.score-section { padding: 20px 28px 16px; border-bottom: 1px solid var(--border); }
.score-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
.score-label { font-size: 14px; font-weight: 700; }
.score-number { font-size: 22px; font-weight: 800; color: var(--primary); transition: all 0.3s; }
.score-bar-wrap { background: var(--gray-200); border-radius: 8px; height: 10px; overflow: hidden; }
.score-bar-fill {
  height: 100%;
  border-radius: 8px;
  background: linear-gradient(90deg, #185FA5, #2d7dd2);
  transition: width 0.6s cubic-bezier(.4,0,.2,1);
  position: relative;
}
.score-bar-fill::after {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.3) 50%, transparent 100%);
  animation: shimmer 1.5s infinite;
}
@keyframes shimmer {
  0%   { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}
.score-tips { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 10px; }
.score-tip {
  font-size: 11px;
  padding: 3px 10px;
  border-radius: 12px;
  font-weight: 600;
}
.score-tip.done { background: var(--success-light); color: var(--success); }
.score-tip.todo { background: var(--gray-100); color: var(--gray-600); }

.profile-form-fields { padding: 24px 28px 0; }
.form-section-label {
  font-size: 11px;
  font-weight: 700;
  color: var(--text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 12px;
  margin-top: 20px;
  display: flex;
  align-items: center;
  gap: 8px;
}
.form-section-label:first-child { margin-top: 0; }
.form-section-label::after { content: ''; flex: 1; height: 1px; background: var(--border); }
.profile-field {
  width: 100%;
  padding: 11px 14px;
  border: 1.5px solid var(--border);
  border-radius: 10px;
  font-size: 14px;
  color: var(--text-primary);
  transition: all 0.2s;
  background: #fff;
  outline: none;
}
.profile-field:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(24,95,165,0.1); }
.profile-field.filled { border-color: #c3dfa5; background: #fafff7; }

.profile-actions-bar {
  padding: 20px 28px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  flex-wrap: wrap;
  border-top: 1px solid var(--border);
  margin-top: 20px;
}
.profile-actions-hint { font-size: 13px; color: var(--text-secondary); }

.edit-mode-off { display: none; }
.edit-mode-on  { display: flex; }

/* Sidebar related profiles */
.related-person-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  border: 1px solid var(--border);
  border-radius: 14px;
  transition: all 0.2s;
  text-decoration: none;
  color: inherit;
}
.related-person-card:hover {
  border-color: var(--primary);
  box-shadow: 0 2px 8px rgba(24,95,165,0.12);
  background: var(--primary-light);
}
.related-person-avatar {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  flex-shrink: 0;
  object-fit: cover;
}
.related-person-avatar-fallback {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  background: var(--primary-light);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--primary);
  font-weight: 800;
  font-size: 18px;
  flex-shrink: 0;
}
</style>

<div class="profile-edit-page">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:20px;flex-wrap:wrap;gap:12px;">
    <div>
      <h1 style="font-size:22px;font-weight:800;">My Profile</h1>
      <p style="font-size:13px;color:var(--text-secondary);">Build a strong profile so companies can identify and shortlist you with confidence.</p>
    </div>
    <div style="display:flex;gap:10px;align-items:center;">
      <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-ghost btn-sm">Back to Dashboard</a>
      <c:if test="${not empty profile and not empty profile.fullName}">
        <a href="${pageContext.request.contextPath}/profiles/student?id=${profile.id}" class="btn btn-outline btn-sm" target="_blank">View Public Profile</a>
      </c:if>
    </div>
  </div>

  <c:if test="${param.success == '1'}">
    <div class="alert alert-success" data-auto-dismiss style="margin-bottom:16px;">Profile saved successfully. Your profile score has been updated.</div>
  </c:if>

  <div style="display:grid;grid-template-columns:minmax(0,1.65fr) 340px;gap:20px;align-items:start;">

    <!-- Main form card -->
    <form id="studentProfileForm" action="${pageContext.request.contextPath}/student/profile" method="post" enctype="multipart/form-data" class="card" style="overflow:visible;">
      <input type="file" id="profilePhotoInput" name="profilePhoto" accept="image/*" style="display:none;"/>

      <!-- Hero section with photo -->
      <div class="profile-hero-card">
        <div class="profile-photo-wrap">
          <c:choose>
            <c:when test="${not empty profile.profilePhoto}">
              <img id="profileImagePreview" src="${pageContext.request.contextPath}/${profile.profilePhoto}" alt="Profile photo" class="profile-photo-img"/>
            </c:when>
            <c:otherwise>
              <div id="profileImagePreviewFallback" class="profile-photo-fallback">
                ${empty profile.fullName ? 'S' : fn:substring(profile.fullName,0,1)}
              </div>
              <img id="profileImagePreview" alt="Profile photo preview" class="profile-photo-img" style="display:none;"/>
            </c:otherwise>
          </c:choose>
          <button type="button" class="profile-photo-upload-btn" id="photoUploadTrigger" title="Change photo">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
          </button>
        </div>
        <div class="profile-hero-info">
          <div class="profile-hero-name" id="heroName">${empty profile.fullName ? 'Your Name' : profile.fullName}</div>
          <div class="profile-hero-sub" id="heroSub">
            ${empty profile.program ? 'Program' : profile.program}
            <c:if test="${not empty profile.university}"> &bull; ${profile.university}</c:if>
          </div>
          <div class="profile-hero-badges">
            <span class="profile-hero-badge" id="heroBadgeExp">${empty profile.experienceType ? 'Experience Level' : profile.experienceType}</span>
            <c:if test="${not empty profile.university}">
              <span class="profile-hero-badge">${profile.university}</span>
            </c:if>
          </div>
          <div style="margin-top:14px;font-size:12px;opacity:0.75;" id="photoHint">
            <c:choose>
              <c:when test="${empty profile.profilePhoto}">Click the camera icon to add your profile photo</c:when>
              <c:otherwise>Photo uploaded &bull; Click camera to change</c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- Profile Score Bar -->
      <div class="score-section">
        <div class="score-header">
          <div>
            <div class="score-label">Profile Strength</div>
            <div style="font-size:12px;color:var(--text-secondary);">Fill all sections to reach 100% and get more visibility</div>
          </div>
          <div class="score-number" id="profileScoreLabel">${empty profile ? 0 : profile.profileScore}%</div>
        </div>
        <div class="score-bar-wrap">
          <div class="score-bar-fill" id="profileScoreBar" style="width:${empty profile ? 0 : profile.profileScore}%"></div>
        </div>
        <div class="score-tips" id="scoreTips"></div>
      </div>

      <!-- Form Fields -->
      <div class="profile-form-fields" style="display:grid;grid-template-columns:1fr 1fr;gap:14px;">
        <div class="form-section-label" style="grid-column:1/-1;">Basic Info</div>
        <input data-profile-field data-score-key="fullName" required name="fullName" value="${profile.fullName}" placeholder="Full name" class="profile-field ${not empty profile.fullName ? 'filled' : ''}"/>
        <input data-profile-field data-score-key="phone" required name="phone" value="${profile.phone}" placeholder="Phone number" class="profile-field ${not empty profile.phone ? 'filled' : ''}"/>
        <input data-profile-field data-score-key="address" required name="address" value="${profile.address}" placeholder="Address / City" class="profile-field ${not empty profile.address ? 'filled' : ''}" style="grid-column:1/-1;"/>

        <div class="form-section-label" style="grid-column:1/-1;">Academic Details</div>
        <input data-profile-field data-score-key="university" required name="university" value="${profile.university}" placeholder="University / College" class="profile-field ${not empty profile.university ? 'filled' : ''}"/>
        <input data-profile-field data-score-key="program" required name="program" value="${profile.program}" placeholder="Program / Degree" class="profile-field ${not empty profile.program ? 'filled' : ''}"/>
        <input data-profile-field data-score-key="semester" required type="number" min="1" max="12" name="semester" value="${profile.semester > 0 ? profile.semester : ''}" placeholder="Current Semester" class="profile-field ${profile.semester > 0 ? 'filled' : ''}"/>
        <input data-profile-field data-score-key="cgpa" required type="number" step="0.01" min="0" max="4" name="cgpa" value="${profile.cgpa > 0 ? profile.cgpa : ''}" placeholder="CGPA / GPA" class="profile-field ${profile.cgpa > 0 ? 'filled' : ''}"/>
        <select data-profile-field data-score-key="experienceType" required name="experienceType" class="profile-field ${not empty profile.experienceType ? 'filled' : ''}">
          <option value="">Select experience level</option>
          <option value="FRESHER"    ${profile.experienceType == 'FRESHER'    ? 'selected' : ''}>Fresher</option>
          <option value="INTERN"     ${profile.experienceType == 'INTERN'     ? 'selected' : ''}>Intern / Currently Interning</option>
          <option value="EXPERIENCED" ${profile.experienceType == 'EXPERIENCED' ? 'selected' : ''}>Experienced</option>
        </select>
        <input data-profile-field data-score-key="githubUrl" required name="githubUrl" value="${profile.githubUrl}" placeholder="GitHub profile URL" class="profile-field ${not empty profile.githubUrl ? 'filled' : ''}"/>
        <input data-profile-field data-score-key="linkedinUrl" name="linkedinUrl" value="${profile.linkedinUrl}" placeholder="LinkedIn URL (optional)" class="profile-field ${not empty profile.linkedinUrl ? 'filled' : ''}" style="grid-column:1/-1;"/>

        <div class="form-section-label" style="grid-column:1/-1;">Professional Identity</div>
        <textarea data-profile-field data-score-key="skills" required name="skills" placeholder="Skills, comma separated (e.g. Java, React, SQL)" class="profile-field ${not empty profile.skills ? 'filled' : ''}" style="min-height:100px;grid-column:1/-1;resize:vertical;">${profile.skills}</textarea>
        <textarea data-profile-field data-score-key="bio" required name="bio" placeholder="Short bio — tell companies who you are, what you're passionate about" class="profile-field ${not empty profile.bio ? 'filled' : ''}" style="min-height:120px;grid-column:1/-1;resize:vertical;">${profile.bio}</textarea>
      </div>

      <!-- Actions Bar -->
      <div class="profile-actions-bar">
        <div class="profile-actions-hint" id="actionsHint">
          <c:choose>
            <c:when test="${empty profile or empty profile.fullName}">Fill in all required fields to save your profile.</c:when>
            <c:otherwise>Make changes above to unlock the Save button.</c:otherwise>
          </c:choose>
        </div>
        <div style="display:flex;gap:10px;align-items:center;">
          <c:if test="${not empty profile and not empty profile.fullName}">
            <button type="button" id="editProfileBtn" class="btn btn-outline" onclick="enableEditMode()">Edit Details</button>
          </c:if>
          <button id="studentProfileSubmit" type="submit" class="btn btn-primary" ${(empty profile or empty profile.fullName) ? '' : 'disabled'}>
            <c:choose>
              <c:when test="${empty profile or empty profile.fullName}">Save Profile</c:when>
              <c:otherwise>Save Changes</c:otherwise>
            </c:choose>
          </button>
        </div>
      </div>
    </form>

    <!-- Sidebar -->
    <aside style="display:grid;gap:16px;">
      <!-- Quick Stats -->

    </aside>
  </div>
</div>

<script>
(function() {
  const form = document.getElementById('studentProfileForm');
  if (!form) return;

  const fields = Array.from(form.querySelectorAll('[data-profile-field]'));
  const submit = document.getElementById('studentProfileSubmit');
  const scoreLabel = document.getElementById('profileScoreLabel');
  const scoreBar = document.getElementById('profileScoreBar');
  const photoInput = document.getElementById('profilePhotoInput');
  const photoTrigger = document.getElementById('photoUploadTrigger');
  const editBtn = document.getElementById('editProfileBtn');
  const actionsHint = document.getElementById('actionsHint');
  const scoreTipsEl = document.getElementById('scoreTips');

  // Snapshot of initial state to detect changes
  const initialState = fields.map(f => f.value).join('||');
  let photoChanged = false;
  let editModeActive = ${empty profile or empty profile.fullName ? 'true' : 'false'};

  // Score weights per field key
  const scoreMap = {
    fullName: 15, phone: 10, address: 10,
    university: 10, program: 10, semester: 5, cgpa: 10,
    experienceType: 5, githubUrl: 10, linkedinUrl: 5,
    skills: 10, bio: 10
  };
  const scoreLabels = {
    fullName: 'Name', phone: 'Phone', address: 'Address',
    university: 'University', program: 'Program', semester: 'Semester', cgpa: 'CGPA',
    experienceType: 'Experience', githubUrl: 'GitHub', linkedinUrl: 'LinkedIn',
    skills: 'Skills', bio: 'Bio'
  };

  // Photo upload trigger
  if (photoTrigger && photoInput) {
    photoTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      photoInput.click();
    });
  }

  // Photo preview
  if (photoInput) {
    photoInput.addEventListener('change', function() {
      const file = this.files && this.files[0];
      if (!file) return;

      const reader = new FileReader();
      reader.onload = function(e) {
        // Show image preview
        const imgEl = document.getElementById('profileImagePreview');
        const fallback = document.getElementById('profileImagePreviewFallback');

        imgEl.src = e.target.result;
        imgEl.style.display = 'block';
        if (fallback) fallback.style.display = 'none';

        // Update hint
        const hint = document.getElementById('photoHint');
        if (hint) hint.textContent = 'New photo selected \u2022 Click camera to change';
      };
      reader.readAsDataURL(file);

      photoChanged = true;
      updateFormState();
    });
  }

  function getFieldScore(field) {
    const key = field.dataset.scoreKey;
    if (!key) return 0;
    const val = field.value && field.value.trim();
    if (!val) return 0;
    return scoreMap[key] || 0;
  }

  function computeScore() {
    return Math.min(100, fields.reduce((sum, f) => sum + getFieldScore(f), 0));
  }

  function hasChanged() {
    const currentState = fields.map(f => f.value).join('||');
    return currentState !== initialState || photoChanged;
  }

  function allRequiredFilled() {
    return fields.every(f => !f.required || (f.value && f.value.trim()));
  }

  function updateFormState() {
    const score = computeScore();
    // Animate score bar and number
    scoreLabel.textContent = score + '%';
    scoreBar.style.width = score + '%';

    // Color the score number
    if (score >= 80) scoreLabel.style.color = '#3B6D11';
    else if (score >= 50) scoreLabel.style.color = '#185FA5';
    else scoreLabel.style.color = '#854F0B';

    // Update score bar color
    if (score >= 80) scoreBar.style.background = 'linear-gradient(90deg,#3B6D11,#5a9e1b)';
    else if (score >= 50) scoreBar.style.background = 'linear-gradient(90deg,#185FA5,#2d7dd2)';
    else scoreBar.style.background = 'linear-gradient(90deg,#854F0B,#c07018)';

    // Score tips
    if (scoreTipsEl) {
      scoreTipsEl.innerHTML = '';
      fields.forEach(f => {
        const key = f.dataset.scoreKey;
        if (!key) return;
        const done = f.value && f.value.trim();
        const tip = document.createElement('span');
        tip.className = 'score-tip ' + (done ? 'done' : 'todo');
        tip.textContent = (done ? '\u2713 ' : '+ ') + scoreLabels[key] + ' (' + (scoreMap[key] || 0) + 'pt)';
        scoreTipsEl.appendChild(tip);
      });
    }

    // Update field fill states
    fields.forEach(f => {
      if (f.value && f.value.trim()) f.classList.add('filled');
      else f.classList.remove('filled');
    });

    // Live update hero name
    const nameField = form.querySelector('[name="fullName"]');
    const heroName = document.getElementById('heroName');
    if (nameField && heroName) heroName.textContent = nameField.value || 'Your Name';

    // Live update hero sub
    const progField = form.querySelector('[name="program"]');
    const univField = form.querySelector('[name="university"]');
    const heroSub = document.getElementById('heroSub');
    if (heroSub) {
      let subParts = [];
      if (progField && progField.value) subParts.push(progField.value);
      if (univField && univField.value) subParts.push(univField.value);
      heroSub.textContent = subParts.join(' \u2022 ') || 'Program \u2022 University';
    }

    // Live update hero badge
    const expField = form.querySelector('[name="experienceType"]');
    const heroBadge = document.getElementById('heroBadgeExp');
    if (expField && heroBadge) heroBadge.textContent = expField.value || 'Experience Level';

    // Enable / disable submit
    const canSave = allRequiredFilled() && (editModeActive || hasChanged());
    submit.disabled = !canSave;

    if (canSave) {
      if (actionsHint) actionsHint.textContent = 'Ready to save! Click "Save Changes" to update your profile.';
    } else if (!allRequiredFilled()) {
      if (actionsHint) actionsHint.textContent = 'Fill all required fields (marked with *) to save.';
    } else {
      if (actionsHint) actionsHint.textContent = 'Make changes above to unlock the Save button.';
    }
  }

  // Bind input listeners
  fields.forEach(f => {
    f.addEventListener('input', updateFormState);
    f.addEventListener('change', updateFormState);
  });

  // Initial state
  updateFormState();

  // If existing profile, fields are read-only-ish until "Edit Details" is clicked
  // (they remain enabled so user can tab through, but save is only unlocked on change)
  // We highlight that by calling updateFormState
})();

function enableEditMode() {
  var btn = document.getElementById('editProfileBtn');
  var hint = document.getElementById('actionsHint');
  if (btn) btn.style.display = 'none';
  if (hint) hint.textContent = 'Edit the fields above and click "Save Changes" when done.';
  var form = document.getElementById('studentProfileForm');
  if (form) {
    var fields = form.querySelectorAll('[data-profile-field]');
    fields.forEach(function(f){ f.readOnly = false; f.classList.remove('readonly'); });
    var photoTrigger = document.getElementById('photoUploadTrigger');
    if (photoTrigger) photoTrigger.disabled = false;
    // ensure submit enabled after edits
    fields[0].focus();
  }
}
</script>

<jsp:include page="/components/footer.jsp"/>
