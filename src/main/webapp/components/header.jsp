<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${not empty pageTitle ? pageTitle : 'InternLink Nepal'}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css"/>
  <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg" type="image/svg+xml"/>
</head>
<body>

<%
  Integer _uid = (Integer) session.getAttribute("userId");
  int _unread = 0;
  java.util.List<com.internlink.model.Notification> _recentNotes = java.util.Collections.emptyList();
  try {
      if (_uid != null) {
          com.internlink.dao.NotificationDAO notificationDAO = new com.internlink.dao.NotificationDAO();
          _unread = notificationDAO.countUnread(_uid);
          _recentNotes = notificationDAO.findUnreadRecent(_uid, 5);
      }
  } catch (Exception ignored) {}
%>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/" class="navbar-brand">
    <span class="brand-icon">&#9670;</span>
    InternLink Nepal
  </a>

  <div class="navbar-links">
    <a href="${pageContext.request.contextPath}/">Home</a>
    <a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
    <a href="${pageContext.request.contextPath}/companies">Companies</a>
    <a href="${pageContext.request.contextPath}/#about">About</a>
  </div>

  <div class="navbar-actions">
    <c:choose>
      <c:when test="${not empty sessionScope.loggedInUser}">
        <div style="position:relative;margin-right:8px;">
          <button id="notifBtn" class="btn btn-ghost btn-sm" style="position:relative;">&#128276;
            <% if (_unread != 0) { %>
              <span style="position:absolute;top:-6px;right:-8px;background:var(--danger);color:#fff;border-radius:12px;padding:2px 6px;font-size:11px;"><%= _unread %></span>
            <% } %>
          </button>

          <div id="notifPopup" style="display:none;position:absolute;right:0;top:36px;width:320px;max-height:360px;overflow:auto;border:1px solid var(--border);background:#fff;box-shadow:0 8px 24px rgba(0,0,0,0.12);border-radius:8px;padding:8px;z-index:999;">
            <div style="display:flex;align-items:center;justify-content:space-between;padding:6px 8px;border-bottom:1px solid var(--border);">
              <strong>Notifications</strong>
              <form method="post" action="${pageContext.request.contextPath}/notifications" style="margin:0;">
                <input type="hidden" name="action" value="markAllRead"/>
                <button class="btn btn-ghost btn-sm" type="submit">Mark all read</button>
              </form>
            </div>
            <div style="display:grid;gap:8px;padding:8px;">
              <% if (_recentNotes != null && !_recentNotes.isEmpty()) { 
                   for (com.internlink.model.Notification n : _recentNotes) { %>
                     <a href="<%= request.getContextPath() %>/notifications/open?id=<%= n.getId() %>" style="padding:8px;border-radius:8px;border:1px solid var(--border);background:#fff;text-decoration:none;color:inherit;display:block;">
                       <div style="font-weight:700;font-size:13px;"><%= n.getTitle() %></div>
                       <div style="font-size:13px;color:var(--text-secondary);"><%= n.getMessage() %></div>
                       <div style="font-size:11px;color:var(--text-secondary);text-align:right;"> <%= n.getCreatedAt() != null ? n.getCreatedAt().toString().substring(0,19) : "" %></div>
                     </a>
              <%   }
                 } else { %>
                   <div style="padding:12px;color:var(--text-secondary);text-align:center;">No unread notifications</div>
              <% } %>
            </div>
            <div style="padding:6px 8px;border-top:1px solid var(--border);text-align:right;">
              <a href="${pageContext.request.contextPath}/notifications" style="font-size:12px;color:var(--primary);font-weight:600;text-decoration:none;">View all notifications</a>
            </div>
          </div>
        </div>
        <c:choose>
          <c:when test="${sessionScope.userRole == 'STUDENT'}">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline btn-sm">Dashboard</a>
          </c:when>
          <c:when test="${sessionScope.userRole == 'COMPANY'}">
            <a href="${pageContext.request.contextPath}/company/dashboard" class="btn btn-outline btn-sm">Dashboard</a>
          </c:when>
          <c:when test="${sessionScope.userRole == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline btn-sm">Admin</a>
          </c:when>
        </c:choose>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign Out</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/login"    class="btn btn-ghost btn-sm">Sign In</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Get Started</a>
      </c:otherwise>
    </c:choose>
  </div>
</nav>
<script>
(function(){
  var btn = document.getElementById('notifBtn');
  var popup = document.getElementById('notifPopup');
  if (!btn || !popup) return;
  btn.addEventListener('click', function(e){
    e.stopPropagation();
    popup.style.display = popup.style.display === 'block' ? 'none' : 'block';
  });
  popup.addEventListener('click', function(e){ e.stopPropagation(); });
  document.addEventListener('click', function(){ popup.style.display = 'none'; });
})();
</script>
