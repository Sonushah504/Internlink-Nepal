<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Company Profile - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<style>
.company-profile-page { max-width: 1100px; margin: 0 auto; padding: 32px 24px; }
.company-hero-banner {
  background: linear-gradient(135deg, #0d2645 0%, #16528d 60%, #2875c8 100%);
  border-radius: 20px;
  padding: 32px;
  color: #fff;
  display: flex;
  gap: 22px;
  align-items: center;
  flex-wrap: wrap;
  margin-bottom: 24px;
  position: relative;
  overflow: hidden;
}
.company-hero-banner::before {
  content: '';
  position: absolute;
  top: -80px; right: -80px;
  width: 260px; height: 260px;
  border-radius: 50%;
  background: rgba(255,255,255,0.05);
}
.company-logo-circle {
  width: 90px; height: 90px;
  border-radius: 22px;
  background: rgba(255,255,255,0.18);
  display: flex; align-items: center; justify-content: center;
  font-size: 36px; font-weight: 800; color: #fff;
  border: 3px solid rgba(255,255,255,0.3);
  flex-shrink: 0;
}
.company-hero-text { flex: 1; min-width: 240px; }
.company-hero-name { font-size: 26px; font-weight: 800; line-height: 1.2; margin-bottom: 6px; }
.company-hero-sub { opacity: 0.85; font-size: 14px; margin-bottom: 12px; }
.company-hero-badges { display: flex; gap: 8px; flex-wrap: wrap; }
.company-hero-badge {
  background: rgba(255,255,255,0.18);
  color: #fff;
  font-size: 11px; font-weight: 600;
  padding: 4px 12px; border-radius: 20px;
  border: 1px solid rgba(255,255,255,0.25);
}
.section-card { background: #fff; border: 1px solid var(--border); border-radius: 16px; margin-bottom: 20px; overflow: hidden; }
.section-card-header {
  padding: 18px 24px;
  border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
}
.section-card-header h3 { font-size: 15px; font-weight: 700; }
.section-card-body { padding: 24px; }
.field-label { font-size: 11px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.07em; margin-bottom: 6px; }
.profile-input {
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
.profile-input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(24,95,165,0.1); }

/* Video upload area */
.video-upload-area {
  border: 2px dashed var(--border);
  border-radius: 16px;
  padding: 32px;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s;
  position: relative;
}
.video-upload-area:hover { border-color: var(--primary); background: var(--primary-light); }
.video-upload-area.has-video { border-style: solid; border-color: #c3dfa5; background: #fafff7; }
.video-upload-icon { font-size: 40px; margin-bottom: 12px; }
.video-upload-title { font-size: 15px; font-weight: 700; color: var(--text-primary); margin-bottom: 6px; }
.video-upload-sub { font-size: 13px; color: var(--text-secondary); }
.video-current-preview { width: 100%; border-radius: 12px; background: #000; max-height: 240px; }
</style>

<div class="company-profile-page">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:20px;flex-wrap:wrap;gap:12px;">
    <div>
      <h1 style="font-size:22px;font-weight:800;">Company Profile</h1>
      <p style="font-size:13px;color:var(--text-secondary);">Keep your organization details up to date for students and admin review.</p>
    </div>
    <div style="display:flex;gap:10px;">
      <a href="${pageContext.request.contextPath}/company/dashboard" class="btn btn-ghost btn-sm">Back to Dashboard</a>
      <c:if test="${not empty company and not empty company.companyName}">
        <a href="${pageContext.request.contextPath}/profiles/company?id=${company.id}" class="btn btn-outline btn-sm" target="_blank">View Public Profile</a>
      </c:if>
    </div>
  </div>

  <c:if test="${param.success == '1'}">
    <div class="alert alert-success" data-auto-dismiss style="margin-bottom:16px;">Company profile saved successfully.</div>
  </c:if>

  <!-- Hero Banner Preview -->
  <div class="company-hero-banner">
    <div class="company-logo-circle" id="heroLogoCircle">
      ${empty company.companyName ? 'C' : company.companyName.substring(0,1)}
    </div>
    <div class="company-hero-text">
      <div class="company-hero-name" id="heroCompanyName">${empty company.companyName ? 'Company Name' : company.companyName}</div>
      <div class="company-hero-sub" id="heroCompanySub">${empty company.industry ? 'Industry' : company.industry} &bull; ${empty company.city ? 'City' : company.city}</div>
      <div class="company-hero-badges">
        <span class="company-hero-badge ${company.verified ? 'badge-verified' : ''}">${company.verified ? 'Verified' : 'Pending Verification'}</span>
        <span class="company-hero-badge" id="heroBadgeEmp">${empty company.employeeCount ? 'Employee Count' : company.employeeCount} employees</span>
        <span class="company-hero-badge" id="heroBadgeYear">Founded ${empty company.foundedYear or company.foundedYear == 0 ? 'Year' : company.foundedYear}</span>
      </div>
    </div>
  </div>

  <form action="${pageContext.request.contextPath}/company/profile" method="post" enctype="multipart/form-data" id="companyProfileForm">

    <!-- Basic Info -->
    <div class="section-card">
      <div class="section-card-header">
        <h3>Basic Information</h3>
        <span class="badge ${company.verified ? 'badge-verified' : 'badge-pending-co'}">${company.verified ? 'Verified Company' : 'Pending Verification'}</span>
      </div>
      <div class="section-card-body" style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
        <div>
          <div class="field-label">Company Name *</div>
          <input name="companyName" id="inputCompanyName" value="${company.companyName}" placeholder="Company name" class="profile-input" required/>
        </div>
        <div>
          <div class="field-label">Industry *</div>
          <input name="industry" id="inputIndustry" value="${company.industry}" placeholder="e.g. IT, Finance, Healthcare" class="profile-input" required/>
        </div>
        <div>
          <div class="field-label">Website</div>
          <input name="website" value="${company.website}" placeholder="https://yourcompany.com" class="profile-input"/>
        </div>
        <div>
          <div class="field-label">Phone</div>
          <input name="phone" value="${company.phone}" placeholder="Phone number" class="profile-input"/>
        </div>
        <div>
          <div class="field-label">City</div>
          <input name="city" id="inputCity" value="${company.city}" placeholder="City" class="profile-input"/>
        </div>
        <div>
          <div class="field-label">Employee Count</div>
          <input name="employeeCount" id="inputEmpCount" value="${company.employeeCount}" placeholder="e.g. 50-200" class="profile-input"/>
        </div>
        <div>
          <div class="field-label">Founded Year</div>
          <input name="foundedYear" id="inputFoundedYear" type="number" min="1900" max="2030" value="${company.foundedYear > 0 ? company.foundedYear : ''}" placeholder="e.g. 2015" class="profile-input"/>
        </div>
        <div>
          <div class="field-label">Address</div>
          <input name="address" value="${company.address}" placeholder="Full address" class="profile-input"/>
        </div>
        <div>
          <div class="field-label">Latitude</div>
          <input name="latitude" id="latitude" value="${company.latitude != 0 ? company.latitude : ''}" placeholder="27.7172" class="profile-input"/>
        </div>
        <div>
          <div class="field-label">Longitude</div>
          <input name="longitude" id="longitude" value="${company.longitude != 0 ? company.longitude : ''}" placeholder="85.3240" class="profile-input"/>
        </div>
        <div style="grid-column:1/-1;">
          <div class="field-label">Description *</div>
          <textarea name="description" placeholder="Tell students about your company, what you do, and what makes you a great place to work or intern..." class="profile-input" style="min-height:140px;resize:vertical;">${company.description}</textarea>
        </div>
      </div>
    </div>

    <!-- Culture Video Upload -->
    <div class="section-card">
      <div class="section-card-header">
        <div>
          <h3>Company Culture Video</h3>
          <p style="font-size:12px;color:var(--text-secondary);margin-top:2px;">Upload a video showing your workplace, internship environment, and company culture</p>
        </div>
        <c:if test="${not empty cultureVideoPath}">
          <span class="badge badge-verified">Video Uploaded</span>
        </c:if>
      </div>
      <div class="section-card-body">
        <c:if test="${not empty cultureVideoPath}">
          <div style="margin-bottom:20px;">
            <div style="font-size:13px;font-weight:600;margin-bottom:10px;color:var(--text-secondary);">Current Video</div>
            <video controls class="video-current-preview">
              <source src="${pageContext.request.contextPath}/${cultureVideoPath}" type="video/mp4"/>
              <source src="${pageContext.request.contextPath}/${cultureVideoPath}" type="video/webm"/>
            </video>
            <div style="font-size:12px;color:var(--text-secondary);margin-top:8px;">Upload a new video below to replace the current one.</div>
          </div>
        </c:if>

        <div class="video-upload-area ${not empty cultureVideoPath ? 'has-video' : ''}" id="videoDropZone" onclick="document.getElementById('cultureVideoInput').click()">
          <input type="file" id="cultureVideoInput" name="cultureVideo" accept="video/mp4,video/webm,video/ogg,video/*" style="display:none;"/>
          <div id="videoUploadContent">
            <div class="video-upload-icon">
              <c:choose>
                <c:when test="${not empty cultureVideoPath}">&#128260;</c:when>
                <c:otherwise>&#127916;</c:otherwise>
              </c:choose>
            </div>
            <div class="video-upload-title">
              <c:choose>
                <c:when test="${not empty cultureVideoPath}">Replace Culture Video</c:when>
                <c:otherwise>Upload Culture Video</c:otherwise>
              </c:choose>
            </div>
            <div class="video-upload-sub">Click to select or drag &amp; drop a video file (MP4, WebM, OGG) &bull; Max 50 MB</div>
          </div>
          <div id="videoSelectedInfo" style="display:none;">
            <div style="font-size:32px;margin-bottom:10px;">&#10003;</div>
            <div id="videoFileName" style="font-size:14px;font-weight:700;color:var(--success);"></div>
            <div id="videoFileSize" style="font-size:12px;color:var(--text-secondary);margin-top:4px;"></div>
          </div>
        </div>

        <div style="margin-top:14px;padding:14px;background:var(--primary-light);border-radius:12px;font-size:12px;color:var(--primary);">
          <strong>Tips for a great culture video:</strong> Show your office, introduce team members, explain your internship program, show a day in the life of an intern or employee. Keep it under 3-5 minutes.
        </div>
      </div>
    </div>

    <!-- Save Action -->
    <div style="display:flex;align-items:center;justify-content:space-between;padding:18px 0;flex-wrap:wrap;gap:12px;">
      <div style="font-size:13px;color:var(--text-secondary);">All changes are saved immediately when you click Save.</div>
      <button type="submit" class="btn btn-primary">Save Company Profile</button>
    </div>
  </form>
</div>

<script>
// Live preview of company name/industry/city in hero
(function() {
  function bind(inputId, updateFn) {
    var el = document.getElementById(inputId);
    if (el) {
      el.addEventListener('input', updateFn);
      el.addEventListener('change', updateFn);
    }
  }
  bind('inputCompanyName', function() {
    var v = this.value;
    var heroName = document.getElementById('heroCompanyName');
    var heroLogo = document.getElementById('heroLogoCircle');
    if (heroName) heroName.textContent = v || 'Company Name';
    if (heroLogo) heroLogo.textContent = v ? v[0].toUpperCase() : 'C';
  });
  bind('inputIndustry', function() {
    updateSub();
  });
  bind('inputCity', function() {
    updateSub();
  });
  bind('inputEmpCount', function() {
    var badge = document.getElementById('heroBadgeEmp');
    if (badge) badge.textContent = (this.value || 'Employee Count') + ' employees';
  });
  bind('inputFoundedYear', function() {
    var badge = document.getElementById('heroBadgeYear');
    if (badge) badge.textContent = 'Founded ' + (this.value || 'Year');
  });
  function updateSub() {
    var ind = document.getElementById('inputIndustry');
    var city = document.getElementById('inputCity');
    var heroSub = document.getElementById('heroCompanySub');
    if (heroSub) {
      heroSub.textContent = (ind && ind.value ? ind.value : 'Industry') + ' \u2022 ' + (city && city.value ? city.value : 'City');
    }
  }
})();

// Video file input handler
(function() {
  var input = document.getElementById('cultureVideoInput');
  var dropZone = document.getElementById('videoDropZone');
  var uploadContent = document.getElementById('videoUploadContent');
  var selectedInfo = document.getElementById('videoSelectedInfo');
  var fileName = document.getElementById('videoFileName');
  var fileSize = document.getElementById('videoFileSize');

  if (!input) return;

  input.addEventListener('change', function() {
    var file = this.files && this.files[0];
    if (!file) return;

    var sizeMB = (file.size / (1024 * 1024)).toFixed(1);
    uploadContent.style.display = 'none';
    selectedInfo.style.display = 'block';
    fileName.textContent = file.name;
    fileSize.textContent = sizeMB + ' MB \u2022 Click to change';
    dropZone.classList.add('has-video');
    dropZone.style.borderColor = '#3B6D11';
    dropZone.style.background = '#fafff7';
  });

  // Drag and drop
  dropZone.addEventListener('dragover', function(e) {
    e.preventDefault();
    dropZone.style.borderColor = 'var(--primary)';
    dropZone.style.background = 'var(--primary-light)';
  });
  dropZone.addEventListener('dragleave', function() {
    dropZone.style.borderColor = '';
    dropZone.style.background = '';
  });
  dropZone.addEventListener('drop', function(e) {
    e.preventDefault();
    var files = e.dataTransfer.files;
    if (files.length > 0) {
      input.files = files; // Note: may not work in all browsers
      var event = new Event('change');
      input.dispatchEvent(event);
    }
    dropZone.style.borderColor = '';
    dropZone.style.background = '';
  });
})();
</script>

<jsp:include page="/components/footer.jsp"/>
