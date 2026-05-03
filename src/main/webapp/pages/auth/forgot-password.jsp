<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Forgot password – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<div class="auth-split-wrap">
  <div class="auth-split-brand">
    <div class="auth-split-brand-inner">
      <div class="auth-brand-logo"><span class="brand-icon">&#9670;</span> InternLink Nepal</div>
      <h2>Reset your password securely</h2>
      <p>We will email a one-time verification code. For accounts created with the registration form, use the Gmail address you signed up with.</p>
      <ul class="auth-split-list">
        <li><i class="fa-solid fa-shield-halved"></i> Same inbox as Google or Facebook sign-in</li>
        <li><i class="fa-solid fa-envelope-open-text"></i> Sent from our professional noreply address</li>
      </ul>
    </div>
  </div>
  <div class="auth-split-panel">
    <div class="auth-panel-card">
      <h1 class="auth-panel-title">Forgot password</h1>
      <p class="auth-panel-sub">Enter your email to receive a verification code.</p>

      <c:if test="${not empty error}">
        <div class="alert alert-error" style="margin-bottom:16px;">${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="alert alert-success" style="margin-bottom:16px;">${success}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <input type="hidden" name="action" value="send"/>
        <div class="form-group">
          <label class="form-label">Email</label>
          <input type="email" name="email" class="form-control" placeholder="your.account@gmail.com" value="${enteredEmail}" required autocomplete="email"/>
        </div>
        <button type="submit" class="btn btn-primary btn-block btn-lg">Send verification code</button>
      </form>

      <p class="auth-panel-footer">
        <a href="${pageContext.request.contextPath}/login">Back to sign in</a>
      </p>
    </div>
  </div>
</div>

<style>
.auth-split-wrap { min-height:calc(100vh - 56px); display:flex; flex-wrap:wrap; }
.auth-split-brand {
  flex:1 1 420px;
  background:linear-gradient(155deg,#0a2544 0%,#185FA5 48%,#1D9E75 100%);
  color:#fff;
  display:flex;
  align-items:center;
  justify-content:center;
  padding:48px 40px;
}
.auth-split-brand-inner { max-width:420px; }
.auth-brand-logo { font-weight:800; font-size:18px; margin-bottom:24px; opacity:.95; }
.auth-split-brand h2 { font-size:28px; font-weight:800; line-height:1.2; margin:0 0 16px; }
.auth-split-brand p { opacity:.9; font-size:15px; line-height:1.65; margin:0 0 20px; }
.auth-split-list { list-style:none; padding:0; margin:0; font-size:14px; opacity:.92; }
.auth-split-list li { display:flex; gap:10px; align-items:flex-start; margin-bottom:12px; }
.auth-split-list i { margin-top:3px; opacity:.85; }
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
.auth-panel-footer a:hover { text-decoration:underline; }
</style>

<jsp:include page="/components/footer.jsp"/>
