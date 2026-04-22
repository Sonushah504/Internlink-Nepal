<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Portfolio - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<section class="section" style="padding-top:32px;">
  <div class="section-header">
    <div>
      <h1 class="section-title">Portfolio</h1>
      <p class="section-subtitle">A simple showcase page for your public links and technical focus.</p>
    </div>
    <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-outline">Edit Profile</a>
  </div>

  <div class="grid-3">
    <div class="card"><div class="card-body">
      <h3 style="margin-bottom:8px;">About</h3>
      <p>${profile.bio}</p>
    </div></div>
    <div class="card"><div class="card-body">
      <h3 style="margin-bottom:8px;">Skills</h3>
      <p>${profile.skills}</p>
    </div></div>
    <div class="card"><div class="card-body">
      <h3 style="margin-bottom:8px;">Links</h3>
      <div style="display:grid;gap:10px;">
        <a href="https://${profile.githubUrl}" target="_blank" rel="noopener" style="color:var(--primary);">${profile.githubUrl}</a>
        <a href="https://${profile.linkedinUrl}" target="_blank" rel="noopener" style="color:var(--primary);">${profile.linkedinUrl}</a>
      </div>
    </div></div>
  </div>
</section>

<jsp:include page="/components/footer.jsp"/>
