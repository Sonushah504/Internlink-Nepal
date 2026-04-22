<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Server Error – InternLink Nepal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css"/>
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(--gray-50);">
  <div style="text-align:center;padding:40px;">
    <div style="font-size:80px;font-weight:800;color:var(--danger);line-height:1;">500</div>
    <h1 style="font-size:24px;font-weight:700;margin:16px 0 8px;">Something went wrong</h1>
    <p style="color:var(--text-secondary);margin-bottom:28px;">We're working on fixing this. Please try again shortly.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to Homepage</a>
  </div>
</body>
</html>
