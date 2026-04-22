<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Page Not Found – InternLink Nepal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css"/>
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(--gray-50);">
  <div style="text-align:center;padding:40px;">
    <div style="font-size:80px;font-weight:800;color:var(--primary);line-height:1;">404</div>
    <h1 style="font-size:24px;font-weight:700;margin:16px 0 8px;">Page not found</h1>
    <p style="color:var(--text-secondary);margin-bottom:28px;">The page you're looking for doesn't exist or has been moved.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to Homepage</a>
  </div>
</body>
</html>
