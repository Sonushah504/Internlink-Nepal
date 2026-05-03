<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Enter code – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<div class="auth-split-wrap">
  <div class="auth-split-brand">
    <div class="auth-split-brand-inner">
      <div class="auth-brand-logo"><span class="brand-icon">&#9670;</span> InternLink Nepal</div>
      <h2>Check your inbox</h2>
      <p>Open the message from InternLink Nepal and enter the 6-digit code below. Then choose a new password.</p>
    </div>
  </div>
  <div class="auth-split-panel">
    <div class="auth-panel-card">
      <h1 class="auth-panel-title">Verify &amp; reset</h1>
      <p class="auth-panel-sub">Code sent to <strong>${sessionScope.forgotPwdEmail}</strong></p>

      <c:if test="${not empty error}">
        <div class="alert alert-error" style="margin-bottom:16px;">${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <input type="hidden" name="action" value="reset"/>
        <div class="form-group">
          <label class="form-label">Verification code</label>
          <input type="text" name="otp" class="form-control" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" placeholder="000000" required autocomplete="one-time-code"/>
        </div>
        <div class="form-group">
          <label class="form-label">New password</label>
          <input type="password" name="newPassword" class="form-control" minlength="6" required autocomplete="new-password"/>
        </div>
        <div class="form-group">
          <label class="form-label">Confirm password</label>
          <input type="password" name="confirmPassword" class="form-control" minlength="6" required autocomplete="new-password"/>
        </div>
        <button type="submit" class="btn btn-primary btn-block btn-lg">Update password</button>
      </form>

      <p class="auth-panel-footer">
        <a href="${pageContext.request.contextPath}/forgot-password">Request a new code</a>
        &nbsp;·&nbsp;
        <a href="${pageContext.request.contextPath}/login">Sign in</a>
      </p>
    </div>
  </div>
</div>

<style>
.auth-split-wrap { min-height:calc(100vh - 56px); display:flex; flex-wrap:wrap; }
.auth-split-brand {
  flex:1 1 420px;
  background:linear-gradient(155deg,#0a2544 0%,#185FA5 48%,#533AB7 100%);
  color:#fff;
  display:flex;
  align-items:center;
  justify-content:center;
  padding:48px 40px;
}
.auth-split-brand-inner { max-width:420px; }
.auth-brand-logo { font-weight:800; font-size:18px; margin-bottom:24px; opacity:.95; }
.auth-split-brand h2 { font-size:28px; font-weight:800; line-height:1.2; margin:0 0 16px; }
.auth-split-brand p { opacity:.9; font-size:15px; line-height:1.65; margin:0; }
.auth-split-panel {
  flex:1 1 400px;
  display:flex;
  align-items:center;
  justify-content:center;
  padding:40px 24px;
  background:var(--gray-50);
}
.auth-panel-card {
  width:100%;
  max-width:400px;
  background:#fff;
  border:1px solid var(--border);
  border-radius:16px;
  padding:36px 32px;
  box-shadow:0 4px 24px rgba(15,37,68,.06);
}
.auth-panel-title { font-size:22px; font-weight:800; margin:0 0 8px; }
.auth-panel-sub { color:var(--text-secondary); font-size:14px; margin:0 0 24px; }
.auth-panel-footer { text-align:center; margin-top:20px; font-size:14px; }
.auth-panel-footer a { color:var(--primary); font-weight:600; text-decoration:none; }
</style>

<jsp:include page="/components/footer.jsp"/>
