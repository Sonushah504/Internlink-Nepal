<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign in – InternLink Nepal"/>
<jsp:include page="/components/auth-head.jsp"/>

<div class="auth-single-wrap">
  <div class="auth-panel-card">
    <div style="text-align:center;margin-bottom:20px;">
      <div style="font-size:18px;font-weight:800;color:var(--primary);"><span class="brand-icon">&#9670;</span> InternLink Nepal</div>
    </div>

    <h1 class="auth-panel-title">Welcome back</h1>
    <p class="auth-panel-sub">Sign in to your account</p>

    <c:if test="${not empty error}">
      <div class="alert alert-error" style="margin-bottom:16px;">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success" style="margin-bottom:16px;">${success}</div>
    </c:if>

    <c:choose>
      <c:when test="${param.error == 'oauth_denied'}">
        <div class="alert alert-error" style="margin-bottom:16px;">Sign-in was cancelled.</div>
      </c:when>
      <c:when test="${param.error == 'oauth_state'}">
        <div class="alert alert-error" style="margin-bottom:16px;">Session expired. Please try signing in again.</div>
      </c:when>
      <c:when test="${param.error == 'oauth_existing_other'}">
        <div class="alert alert-error" style="margin-bottom:16px;">This email is already registered another way. Use your password, or the matching social sign-in button.</div>
      </c:when>
      <c:when test="${param.error == 'oauth_student_only'}">
        <div class="alert alert-error" style="margin-bottom:16px;">Social sign-in is available for student accounts.</div>
      </c:when>
      <c:when test="${param.error == 'oauth_email' || param.error == 'oauth_fb_email'}">
        <div class="alert alert-error" style="margin-bottom:16px;">We could not read your email from the provider. Allow email access and try again.</div>
      </c:when>
    </c:choose>

    <form action="${pageContext.request.contextPath}/login" method="post">
      <div class="form-group">
        <label class="form-label">Sign in as</label>
        <select name="role" id="loginRole" class="form-control" required>
          <option value="">Select role</option>
          <option value="STUDENT" ${selectedRole == 'STUDENT' ? 'selected' : ''}>Student</option>
          <option value="COMPANY" ${selectedRole == 'COMPANY' ? 'selected' : ''}>Company</option>
          <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Admin</option>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="form-control" placeholder="you@example.com" value="${enteredEmail}" required autocomplete="username"/>
      </div>
      <div class="form-group">
        <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;">
          <label class="form-label" style="margin:0;">Password</label>
          <a href="${pageContext.request.contextPath}/forgot-password" style="font-size:13px;font-weight:600;color:var(--primary);">Forgot password?</a>
        </div>
        <input type="password" name="password" class="form-control" placeholder="Enter password" required autocomplete="current-password"/>
      </div>
      <div class="form-group auth-remember-row">
        <label class="auth-remember-label">
          <input type="checkbox" name="rememberMe" value="on" ${rememberMe ? 'checked' : ''}/>
          <span>Remember me</span>
        </label>
        <span class="auth-remember-hint">Saves your role for next time</span>
      </div>
      <button type="submit" class="btn btn-primary btn-block btn-lg">Sign in</button>
    </form>

    <div class="auth-divider"><span>Or continue with</span></div>

    <div class="auth-social-row">
      <a class="auth-social-btn auth-social-google" href="${pageContext.request.contextPath}/oauth/google?role=STUDENT">
        <i class="fa-brands fa-google"></i> Google
      </a>
      <a class="auth-social-btn auth-social-fb" href="${pageContext.request.contextPath}/oauth/facebook?role=STUDENT">
        <i class="fa-brands fa-facebook-f"></i> Facebook
      </a>
    </div>

    <p class="auth-panel-footer">
      No account? <a href="${pageContext.request.contextPath}/register">Create one</a>
    </p>
  </div>
</div>

<style>
.auth-standalone { margin:0; min-height:100vh; background:var(--gray-50); }
.auth-single-wrap {
  min-height:100vh;
  display:flex;
  align-items:center;
  justify-content:center;
  padding:40px 20px;
}
.auth-panel-card {
  width:100%;
  max-width:420px;
  background:#fff;
  border:1px solid var(--border);
  border-radius:18px;
  padding:40px 36px;
  box-shadow:0 8px 32px rgba(10,26,51,.08);
}
.auth-panel-title { font-size:24px; font-weight:800; margin:0 0 6px; letter-spacing:-0.02em; text-align:center; }
.auth-panel-sub { color:var(--text-secondary); font-size:14px; margin:0 0 22px; text-align:center; }
.auth-remember-row {
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:12px;
  flex-wrap:wrap;
  margin-bottom:4px;
}
.auth-remember-label {
  display:flex;
  align-items:center;
  gap:8px;
  font-size:14px;
  font-weight:500;
  cursor:pointer;
  user-select:none;
}
.auth-remember-label input { width:16px; height:16px; accent-color:var(--primary); }
.auth-remember-hint { font-size:12px; color:var(--text-secondary); }
.auth-social-row { display:flex; gap:10px; margin-top:4px; }
.auth-social-btn {
  flex:1;
  display:flex;
  align-items:center;
  justify-content:center;
  gap:8px;
  padding:10px 12px;
  border-radius:10px;
  font-size:13px;
  font-weight:600;
  text-decoration:none;
  border:1.5px solid var(--border);
  color:var(--text-primary);
  transition:all .2s;
}
.auth-social-btn:hover { border-color:var(--primary); color:var(--primary); background:var(--primary-light); }
.auth-social-google i { color:#EA4335; }
.auth-social-fb i { color:#1877F2; }
.auth-divider {
  display:flex;
  align-items:center;
  gap:12px;
  margin:22px 0 18px;
  font-size:12px;
  font-weight:600;
  color:var(--text-secondary);
  text-transform:uppercase;
  letter-spacing:.06em;
}
.auth-divider::before,
.auth-divider::after {
  content:'';
  flex:1;
  height:1px;
  background:var(--border);
}
.auth-panel-footer { text-align:center; margin-top:22px; font-size:14px; color:var(--text-secondary); }
.auth-panel-footer a { color:var(--primary); font-weight:700; text-decoration:none; }
.auth-panel-footer a:hover { text-decoration:underline; }
</style>

<jsp:include page="/components/auth-tail.jsp"/>
