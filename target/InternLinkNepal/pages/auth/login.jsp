<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign In – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<div style="min-height:calc(100vh - 60px);display:flex;align-items:center;justify-content:center;background:var(--gray-50);padding:32px 16px;">
  <div style="width:100%;max-width:420px;">

    <div style="text-align:center;margin-bottom:28px;">
      <div style="font-size:32px;margin-bottom:8px;">&#9670;</div>
      <h1 style="font-size:24px;font-weight:700;">Welcome back</h1>
      <p style="color:var(--text-secondary);font-size:14px;margin-top:4px;">Sign in to your InternLink Nepal account</p>
    </div>

    <div class="card">
      <div class="card-body" style="padding:32px;">
        <c:if test="${not empty error}">
          <div class="alert alert-error" data-auto-dismiss>&#9888; ${error}</div>
        </c:if>
        <c:if test="${not empty success}">
          <div class="alert alert-success" data-auto-dismiss>&#10003; ${success}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
          <div class="form-group">
            <label class="form-label">Login As</label>
            <select name="role" class="form-control" required>
              <option value="">Select role</option>
              <option value="STUDENT" ${selectedRole == 'STUDENT' ? 'selected' : ''}>Student</option>
              <option value="COMPANY" ${selectedRole == 'COMPANY' ? 'selected' : ''}>Company</option>
              <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Admin</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Email Address</label>
            <input type="email" name="email" class="form-control" placeholder="you@example.com" value="${enteredEmail}" required/>
          </div>
          <div class="form-group">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter your password" required/>
          </div>
          <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:8px;">Sign In</button>
        </form>

        <div style="text-align:center;margin-top:20px;font-size:13px;color:var(--text-secondary);">
          Don't have an account?
          <a href="${pageContext.request.contextPath}/register" style="color:var(--primary);font-weight:600;">Create one</a>
        </div>

        <!-- Demo credentials hint -->
        <div style="margin-top:20px;padding:14px;background:var(--gray-100);border-radius:var(--radius-md);font-size:12px;color:var(--text-secondary);">
          <strong style="display:block;margin-bottom:6px;">Demo accounts (password: Admin@123)</strong>
          Student: ram@demo.com &nbsp;|&nbsp; Company: leapfrog@demo.com &nbsp;|&nbsp; Admin: admin@internlink.com.np
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>
