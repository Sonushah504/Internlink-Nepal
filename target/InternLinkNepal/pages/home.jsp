<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="InternLink Nepal – Find Internships & Jobs in Nepal"/>
<jsp:include page="/components/header.jsp"/>

<!-- ── Hero ─────────────────────────────────────────────────── -->
<section class="hero">
  <div class="hero-badge"><span class="dot"></span> Nepal's #1 Internship Platform</div>
  <h1>Find your first <span>internship</span> or fresher job in Nepal</h1>
  <p>A single, verified platform connecting bachelor students with trusted companies — no more scattered Facebook groups or missed opportunities.</p>
  <div class="hero-actions">
    <a href="${pageContext.request.contextPath}/register?role=STUDENT" class="btn btn-primary btn-lg">I am a Student</a>
    <a href="${pageContext.request.contextPath}/register?role=COMPANY" class="btn btn-outline btn-lg">I am a Company</a>
  </div>
  <!-- Search -->
  <form action="${pageContext.request.contextPath}/jobs" method="get" class="search-bar" style="max-width:600px;margin:36px auto 0;">
    <input type="text" name="q" placeholder="Search internships, skills, or companies…"/>
    <div class="search-divider"></div>
    <select name="type" style="border:none;padding:14px 16px;font-size:14px;outline:none;background:transparent;">
      <option value="">All Types</option>
      <option value="INTERNSHIP">Internship</option>
      <option value="FULL_TIME">Full Time</option>
      <option value="PART_TIME">Part Time</option>
      <option value="REMOTE">Remote</option>
    </select>
    <button type="submit">Search</button>
  </form>
</section>

<!-- ── Carousel ──────────────────────────────────────────────── -->
<section class="carousel-section">
  <div class="carousel-wrapper">
    <div class="carousel-track">

      <!-- Slide 1 -->
      <div class="carousel-slide">
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="400" viewBox="0 0 1200 400">
          <defs>
            <linearGradient id="g1" x1="0" x2="1" y1="0" y2="1">
              <stop offset="0%" stop-color="#0C447C"/>
              <stop offset="100%" stop-color="#185FA5"/>
            </linearGradient>
          </defs>
          <rect width="1200" height="400" fill="url(#g1)"/>
          <!-- Decorative circles -->
          <circle cx="900" cy="80"  r="180" fill="rgba(255,255,255,.05)"/>
          <circle cx="1100" cy="300" r="120" fill="rgba(255,255,255,.04)"/>
          <!-- Desk illustration -->
          <rect x="700" y="180" width="340" height="180" rx="12" fill="rgba(255,255,255,.1)"/>
          <rect x="720" y="200" width="300" height="140" rx="8" fill="rgba(255,255,255,.15)"/>
          <rect x="740" y="215" width="260" height="110" rx="4" fill="rgba(24,95,165,.6)"/>
          <!-- Screen content lines -->
          <rect x="755" y="230" width="100" height="8" rx="4" fill="rgba(255,255,255,.7)"/>
          <rect x="755" y="246" width="150" height="6" rx="3" fill="rgba(255,255,255,.4)"/>
          <rect x="755" y="260" width="120" height="6" rx="3" fill="rgba(255,255,255,.4)"/>
          <rect x="755" y="278" width="80"  height="24" rx="6" fill="#E6F1FB"/>
          <!-- Person silhouette -->
          <circle cx="820" cy="350" r="22" fill="rgba(255,255,255,.2)"/>
          <rect   x="800" y="372" width="40" height="50" rx="8" fill="rgba(255,255,255,.15)"/>
          <!-- Stars -->
          <text x="660" y="250" font-size="28" fill="rgba(255,255,255,.3)">★</text>
          <text x="990" y="160" font-size="20" fill="rgba(255,255,255,.2)">★</text>
        </svg>
        <div class="carousel-overlay">
          <div class="carousel-caption">
            <h2>Launch your career from your campus</h2>
            <p>Thousands of students from TU, KU, PU and more have found their first job through InternLink Nepal.</p>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">Browse Opportunities</a>
          </div>
        </div>
      </div>

      <!-- Slide 2 -->
      <div class="carousel-slide">
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="400" viewBox="0 0 1200 400">
          <defs>
            <linearGradient id="g2" x1="0" x2="1" y1="0" y2="0">
              <stop offset="0%" stop-color="#085041"/>
              <stop offset="100%" stop-color="#1D9E75"/>
            </linearGradient>
          </defs>
          <rect width="1200" height="400" fill="url(#g2)"/>
          <circle cx="950" cy="100" r="200" fill="rgba(255,255,255,.05)"/>
          <!-- Team collaboration illustration -->
          <rect x="680" y="140" width="380" height="230" rx="16" fill="rgba(255,255,255,.1)"/>
          <!-- People circles -->
          <circle cx="760" cy="220" r="30" fill="rgba(255,255,255,.25)"/>
          <circle cx="840" cy="200" r="30" fill="rgba(255,255,255,.2)"/>
          <circle cx="920" cy="220" r="30" fill="rgba(255,255,255,.25)"/>
          <circle cx="1000" cy="200" r="30" fill="rgba(255,255,255,.2)"/>
          <!-- Connection lines -->
          <line x1="790" y1="220" x2="810" y2="210" stroke="rgba(255,255,255,.3)" stroke-width="2"/>
          <line x1="870" y1="210" x2="890" y2="220" stroke="rgba(255,255,255,.3)" stroke-width="2"/>
          <line x1="950" y1="220" x2="970" y2="210" stroke="rgba(255,255,255,.3)" stroke-width="2"/>
          <!-- Chart bars -->
          <rect x="720" y="290" width="30" height="50" rx="4" fill="rgba(255,255,255,.3)"/>
          <rect x="760" y="270" width="30" height="70" rx="4" fill="rgba(255,255,255,.4)"/>
          <rect x="800" y="280" width="30" height="60" rx="4" fill="rgba(255,255,255,.3)"/>
          <rect x="840" y="260" width="30" height="80" rx="4" fill="rgba(255,255,255,.5)"/>
          <rect x="880" y="275" width="30" height="65" rx="4" fill="rgba(255,255,255,.35)"/>
        </svg>
        <div class="carousel-overlay">
          <div class="carousel-caption">
            <h2>Learn by doing in real companies</h2>
            <p>Interns at our partner companies work on live projects, get mentored by senior engineers, and build real-world skills.</p>
            <a href="${pageContext.request.contextPath}/companies" class="btn btn-primary">Meet Companies</a>
          </div>
        </div>
      </div>

      <!-- Slide 3 -->
      <div class="carousel-slide">
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="400" viewBox="0 0 1200 400">
          <defs>
            <linearGradient id="g3" x1="0" x2="1" y1="0" y2="1">
              <stop offset="0%" stop-color="#533AB7"/>
              <stop offset="100%" stop-color="#7F77DD"/>
            </linearGradient>
          </defs>
          <rect width="1200" height="400" fill="url(#g3)"/>
          <circle cx="1000" cy="50"  r="220" fill="rgba(255,255,255,.05)"/>
          <!-- Portfolio cards illustration -->
          <rect x="680" y="120" width="180" height="120" rx="12" fill="rgba(255,255,255,.15)"/>
          <rect x="700" y="140" width="80"  height="8"   rx="4" fill="rgba(255,255,255,.6)"/>
          <rect x="700" y="156" width="130" height="6"   rx="3" fill="rgba(255,255,255,.3)"/>
          <rect x="700" y="168" width="100" height="6"   rx="3" fill="rgba(255,255,255,.3)"/>
          <rect x="700" y="188" width="60"  height="20"  rx="6" fill="#EEEDFE"/>

          <rect x="880" y="100" width="180" height="120" rx="12" fill="rgba(255,255,255,.2)"/>
          <rect x="900" y="120" width="80"  height="8"   rx="4" fill="rgba(255,255,255,.7)"/>
          <rect x="900" y="136" width="130" height="6"   rx="3" fill="rgba(255,255,255,.4)"/>
          <rect x="900" y="148" width="100" height="6"   rx="3" fill="rgba(255,255,255,.4)"/>
          <rect x="900" y="168" width="60"  height="20"  rx="6" fill="#EEEDFE"/>

          <rect x="780" y="260" width="220" height="90"  rx="12" fill="rgba(255,255,255,.12)"/>
          <rect x="800" y="278" width="100" height="8"   rx="4" fill="rgba(255,255,255,.6)"/>
          <rect x="800" y="294" width="160" height="6"   rx="3" fill="rgba(255,255,255,.3)"/>

          <!-- Trophy icon -->
          <text x="1060" y="310" font-size="64" fill="rgba(255,255,255,.15)">🏆</text>
        </svg>
        <div class="carousel-overlay">
          <div class="carousel-caption">
            <h2>Showcase your projects, stand out</h2>
            <p>Build a portfolio on InternLink Nepal, attach GitHub links and certificates, and let companies discover your talent directly.</p>
            <a href="${pageContext.request.contextPath}/register?role=STUDENT" class="btn btn-primary">Build Your Profile</a>
          </div>
        </div>
      </div>

    </div><!-- /.carousel-track -->

    <button class="carousel-btn-prev" aria-label="Previous">&#8592;</button>
    <button class="carousel-btn-next" aria-label="Next">&#8594;</button>
  </div>
  <div class="carousel-dots">
    <button class="carousel-dot active" aria-label="Slide 1"></button>
    <button class="carousel-dot"        aria-label="Slide 2"></button>
    <button class="carousel-dot"        aria-label="Slide 3"></button>
  </div>
</section>

<!-- ── Stats ─────────────────────────────────────────────────── -->
<div class="stats-strip">
  <div class="stat-item"><div class="stat-num">1,200+</div><div class="stat-label">Active Students</div></div>
  <div class="stat-item"><div class="stat-num">340+</div><div class="stat-label">Verified Companies</div></div>
  <div class="stat-item"><div class="stat-num">890+</div><div class="stat-label">Successful Placements</div></div>
  <div class="stat-item"><div class="stat-num">85%</div><div class="stat-label">Placement Rate</div></div>
</div>

<!-- ── Latest Jobs ────────────────────────────────────────────── -->
<section class="section">
  <div class="section-header">
    <div>
      <h2 class="section-title">Latest Openings</h2>
      <p class="section-subtitle">Fresh internship and fresher job listings from verified companies</p>
    </div>
    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline">View All Jobs</a>
  </div>

  <div class="grid-auto">
    <c:choose>
      <c:when test="${not empty latestJobs}">
        <c:forEach var="job" items="${latestJobs}">
          <div class="card job-card" onclick="location.href='${pageContext.request.contextPath}/jobs?id=${job.id}'">
            <div class="card-body">
              <div class="job-card-header">
                <div class="company-logo-wrap">${fn:substring(job.companyName,0,2)}</div>
                <span class="badge badge-${fn:toLowerCase(job.experienceRequired == 'ANY' ? 'fresher' : fn:toLowerCase(job.experienceRequired))}">
                  ${job.experienceRequired == 'ANY' ? 'Open to All' : job.experienceRequired}
                </span>
              </div>
              <div class="job-title">${job.title}</div>
              <div class="job-company">${job.companyName}</div>
              <div class="job-tags">
                <c:forTokens var="skill" items="${job.skillsRequired}" delims=",">
                  <span class="tag">${skill}</span>
                </c:forTokens>
              </div>
              <div class="job-footer">
                <span class="job-location">&#128205; ${job.companyCity}</span>
                <span class="badge badge-intern">${job.jobType}</span>
              </div>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <!-- Demo cards when DB is empty -->
        <c:forEach begin="1" end="3">
          <div class="card job-card">
            <div class="card-body">
              <div class="job-card-header">
                <div class="company-logo-wrap">LC</div>
                <span class="badge badge-fresher">Fresher OK</span>
              </div>
              <div class="job-title">Frontend Developer Intern</div>
              <div class="job-company">Leapfrog Technology</div>
              <div class="job-tags"><span class="tag">React</span><span class="tag">CSS</span></div>
              <div class="job-footer"><span class="job-location">&#128205; Lalitpur</span><span class="badge badge-intern">INTERNSHIP</span></div>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<!-- ── Companies Map ──────────────────────────────────────────── -->
<section class="section" style="background:var(--gray-50);padding-top:48px;padding-bottom:48px;" id="about">
  <div class="section-header">
    <div>
      <h2 class="section-title">Verified Companies Near You</h2>
      <p class="section-subtitle">All companies are manually reviewed and verified by our admin team</p>
    </div>
  </div>

  <div style="display:grid;grid-template-columns:1fr 360px;gap:24px;align-items:start;">
    <!-- Map -->
    <div id="map"></div>

    <!-- Company list -->
    <div style="display:flex;flex-direction:column;gap:12px;max-height:340px;overflow-y:auto;">
      <c:choose>
        <c:when test="${not empty companies}">
          <c:forEach var="co" items="${companies}">
            <div class="card" style="cursor:pointer;" onclick="panMap(${co.latitude},${co.longitude},'${co.companyName}')">
              <div class="card-body" style="padding:14px;">
                <div style="display:flex;align-items:center;gap:10px;">
                  <div class="company-logo-wrap" style="width:38px;height:38px;font-size:13px;">${fn:substring(co.companyName,0,2)}</div>
                  <div>
                    <div style="font-size:14px;font-weight:600;">${co.companyName}</div>
                    <div style="font-size:12px;color:var(--text-secondary);">${co.city} &bull; ${co.industry}</div>
                  </div>
                  <c:if test="${co.verified}"><span class="badge badge-verified" style="margin-left:auto;">✓</span></c:if>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <c:forEach begin="1" end="3">
            <div class="card"><div class="card-body" style="padding:14px;">
              <div style="display:flex;align-items:center;gap:10px;">
                <div class="company-logo-wrap" style="width:38px;height:38px;font-size:13px;">LC</div>
                <div><div style="font-size:14px;font-weight:600;">Leapfrog Technology</div>
                <div style="font-size:12px;color:var(--text-secondary);">Lalitpur &bull; Software</div></div>
              </div>
            </div></div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</section>

<!-- ── Role Cards ─────────────────────────────────────────────── -->
<section class="section">
  <div class="section-header">
    <div>
      <h2 class="section-title">Built for everyone in the journey</h2>
    </div>
  </div>
  <div class="grid-3">
    <div class="card" style="text-align:center;padding:32px 24px;">
      <div style="width:56px;height:56px;background:var(--primary-light);border-radius:14px;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:26px;">&#127891;</div>
      <h3 style="font-size:18px;font-weight:700;margin-bottom:10px;">Students</h3>
      <p style="font-size:14px;color:var(--text-secondary);margin-bottom:20px;">Build your profile, upload your CV, showcase projects, and apply to verified opportunities in one click.</p>
      <ul style="text-align:left;display:flex;flex-direction:column;gap:8px;margin-bottom:20px;">
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Smart job recommendations</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Portfolio &amp; project showcase</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Real-time application tracking</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Fresher-only job filter</li>
      </ul>
      <a href="${pageContext.request.contextPath}/register?role=STUDENT" class="btn btn-primary btn-block">Join as Student</a>
    </div>

    <div class="card" style="text-align:center;padding:32px 24px;border-color:var(--primary);box-shadow:0 0 0 3px rgba(24,95,165,.1);">
      <div style="background:var(--primary-light);color:var(--primary);font-size:11px;font-weight:700;padding:4px 14px;border-radius:20px;display:inline-block;margin-bottom:12px;">MOST POPULAR</div>
      <div style="width:56px;height:56px;background:#E6F1FB;border-radius:14px;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:26px;">&#127970;</div>
      <h3 style="font-size:18px;font-weight:700;margin-bottom:10px;">Companies</h3>
      <p style="font-size:14px;color:var(--text-secondary);margin-bottom:20px;">Post openings, receive pre-screened CVs, filter by CGPA or skill, and shortlist the best candidates.</p>
      <ul style="text-align:left;display:flex;flex-direction:column;gap:8px;margin-bottom:20px;">
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Verified company badge</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Automatic eligibility filter</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Bulk CV download</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Application status management</li>
      </ul>
      <a href="${pageContext.request.contextPath}/register?role=COMPANY" class="btn btn-primary btn-block">Register Company</a>
    </div>

    <div class="card" style="text-align:center;padding:32px 24px;">
      <div style="width:56px;height:56px;background:var(--warning-light);border-radius:14px;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:26px;">&#9733;</div>
      <h3 style="font-size:18px;font-weight:700;margin-bottom:10px;">Admin</h3>
      <p style="font-size:14px;color:var(--text-secondary);margin-bottom:20px;">Verify companies and job posts, manage all users, and track platform-wide placement analytics.</p>
      <ul style="text-align:left;display:flex;flex-direction:column;gap:8px;margin-bottom:20px;">
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Full CRUD control</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Company verification workflow</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Analytics and reports</li>
        <li style="font-size:13px;color:var(--text-secondary);display:flex;align-items:center;gap:8px;"><span style="color:var(--success);">&#10003;</span> Broadcast notifications</li>
      </ul>
      <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-block">Admin Login</a>
    </div>
  </div>
</section>

<!-- Map script (OpenStreetMap via Leaflet — free, no API key required) -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
  var map = L.map('map').setView([27.7172, 85.3240], 12);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors',
    maxZoom: 18
  }).addTo(map);

  var markers = [];
  <c:forEach var="co" items="${companies}">
    <c:if test="${co.latitude != 0 && co.longitude != 0}">
      (function(){
        var m = L.marker([${co.latitude}, ${co.longitude}])
          .addTo(map)
          .bindPopup('<strong>${co.companyName}</strong><br>${co.address}<br><em>${co.industry}</em>');
        markers.push(m);
      })();
    </c:if>
  </c:forEach>

  // Fallback demo markers when no DB data
  <c:if test="${empty companies}">
    L.marker([27.6602, 85.3220]).addTo(map).bindPopup('<strong>Leapfrog Technology</strong><br>Hattiban, Lalitpur');
    L.marker([27.6710, 85.3143]).addTo(map).bindPopup('<strong>CloudFactory Nepal</strong><br>Jawalakhel, Lalitpur');
    L.marker([27.6938, 85.3413]).addTo(map).bindPopup('<strong>Yomari Info Solutions</strong><br>New Baneshwor, Kathmandu');
  </c:if>

  function panMap(lat, lng, name) {
    map.setView([lat, lng], 15);
    markers.forEach(function(m) {
      if (Math.abs(m.getLatLng().lat - lat) < 0.0001) m.openPopup();
    });
  }
</script>

<jsp:include page="/components/footer.jsp"/>
