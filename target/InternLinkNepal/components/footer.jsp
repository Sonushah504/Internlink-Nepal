<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer">
  <div class="footer-grid">
    <div>
      <div class="footer-brand">&#9670; InternLink Nepal</div>
      <p class="footer-desc">Nepal's trusted centralized platform connecting bachelor students with verified companies for internships and entry-level jobs.</p>
    </div>
    <div>
      <h4>Students</h4>
      <ul>
        <li><a href="${pageContext.request.contextPath}/register?role=STUDENT">Create Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/jobs">Browse Internships</a></li>
        <li><a href="${pageContext.request.contextPath}/student/dashboard">My Dashboard</a></li>
      </ul>
    </div>
    <div>
      <h4>Companies</h4>
      <ul>
        <li><a href="${pageContext.request.contextPath}/register?role=COMPANY">Post a Job</a></li>
        <li><a href="${pageContext.request.contextPath}/companies">Browse Companies</a></li>
        <li><a href="${pageContext.request.contextPath}/company/dashboard">Company Dashboard</a></li>
      </ul>
    </div>
    <div>
      <h4>Contact</h4>
      <ul>
        <li><a href="#">Biratnagar, Nepal</a></li>
        <li><a href="shahsonu335@gmail.com">shahsonu335@gmail.com</a></li>
        <li><a href="#">+977-9814311949</a></li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <p>&copy; 2026 InternLink Nepal. All rights reserved.</p>
    <p>Build by Team Interlink</p>
  </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
