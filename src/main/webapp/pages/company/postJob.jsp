<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Post a Job – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<div class="dash-layout">
  <aside class="dash-sidebar">
    <div class="dash-sidebar-brand">
      <h3>Company Panel</h3>
    </div>
    <a href="${pageContext.request.contextPath}/company/dashboard" class="sidebar-nav-item">&#8592; Back to Dashboard</a>
    <a href="${pageContext.request.contextPath}/company/postJob"   class="sidebar-nav-item active">+ Post a Job</a>
  </aside>

  <main class="dash-main">
    <div class="dash-header">
      <h1>Post a New Job</h1>
      <p>Fill in the details below to publish a new internship or job listing.</p>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-error" data-auto-dismiss>&#9888; ${error}</div>
    </c:if>

    <div class="card" style="max-width:700px;">
      <div class="card-body" style="padding:32px;">
        <form action="${pageContext.request.contextPath}/company/postJob" method="post">

          <div class="form-group">
            <label class="form-label">Job Title *</label>
            <input type="text" name="title" class="form-control" placeholder="e.g. Frontend Developer Intern" required/>
          </div>

          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">Job Type *</label>
              <select name="jobType" class="form-control" required>
                <option value="INTERNSHIP">Internship</option>
                <option value="FULL_TIME">Full Time</option>
                <option value="PART_TIME">Part Time</option>
                <option value="REMOTE">Remote</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Experience Required *</label>
              <select name="experienceRequired" class="form-control" required>
                <option value="ANY">Open to All</option>
                <option value="FRESHER">Freshers Only</option>
                <option value="INTERN">Intern Level</option>
                <option value="EXPERIENCED">Experienced</option>
              </select>
            </div>
          </div>

          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">Minimum CGPA</label>
              <input type="number" name="minCgpa" class="form-control" placeholder="2.50" step="0.01" min="0" max="4"/>
              <p class="form-hint">Leave 0 for no CGPA requirement</p>
            </div>
            <div class="form-group">
              <label class="form-label">Location</label>
              <input type="text" name="location" class="form-control" placeholder="Kathmandu / Remote"/>
            </div>
          </div>

          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">Salary Range</label>
              <input type="text" name="salaryRange" class="form-control" placeholder="NPR 10,000 – 15,000/month"/>
            </div>
            <div class="form-group">
              <label class="form-label">Application Deadline *</label>
              <input type="date" name="deadline" class="form-control" required/>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label">Required Skills (comma-separated) *</label>
            <input type="text" name="skillsRequired" class="form-control" placeholder="Java, MySQL, JSP, HTML, CSS" required/>
          </div>

          <div class="form-group">
            <label class="form-label">Job Description *</label>
            <textarea name="description" class="form-control" rows="5"
              placeholder="Describe the role, responsibilities, and what the intern/employee will work on…" required></textarea>
          </div>

          <div class="form-group">
            <label class="form-label">Requirements / Qualifications</label>
            <textarea name="requirements" class="form-control" rows="4"
              placeholder="List candidate requirements, preferred qualifications, etc."></textarea>
          </div>

          <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:8px;">
            <a href="${pageContext.request.contextPath}/company/dashboard" class="btn btn-ghost">Cancel</a>
            <button type="submit" class="btn btn-primary">Publish Job Post</button>
          </div>
        </form>
      </div>
    </div>
  </main>
</div>

<jsp:include page="/components/footer.jsp"/>
