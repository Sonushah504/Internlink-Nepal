<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Notifications - InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<div style="max-width:900px;margin:36px auto;padding:0 16px;">
  <h2>Notifications</h2>
  <form method="post" action="${pageContext.request.contextPath}/notifications" style="margin-bottom:12px;">
    <input type="hidden" name="action" value="markAllRead"/>
    <button class="btn btn-ghost btn-sm">Mark all as read</button>
  </form>
  <c:choose>
    <c:when test="${not empty notifications}">
      <div style="display:grid;gap:8px;">
        <c:forEach var="n" items="${notifications}">
          <c:choose>
            <c:when test="${not empty n.targetPath}">
              <a href="${pageContext.request.contextPath}/notifications/open?id=${n.id}"
                 style="padding:12px;border:1px solid var(--border);border-radius:10px;background:${n.read ? '#f8fafc' : '#fff'};display:flex;justify-content:space-between;align-items:center;text-decoration:none;color:inherit;">
                <div>
                  <div style="font-weight:700;font-size:14px;">${n.title}</div>
                  <div style="font-size:13px;color:var(--text-secondary);">${n.message}</div>
                  <div style="font-size:12px;color:var(--primary);margin-top:6px;">Open related page</div>
                </div>
                <div style="font-size:12px;color:var(--text-secondary);text-align:right;">
                  <div>${fn:substring(n.createdAt,0,19)}</div>
                  <div style="margin-top:4px;color:${n.read ? 'var(--text-secondary)' : 'var(--primary)'};">${n.read ? 'Read' : 'Unread'}</div>
                </div>
              </a>
            </c:when>
            <c:otherwise>
              <div style="padding:12px;border:1px solid var(--border);border-radius:10px;background:${n.read ? '#f8fafc' : '#fff'};display:flex;justify-content:space-between;align-items:center;">
                <div>
                  <div style="font-weight:700;font-size:14px;">${n.title}</div>
                  <div style="font-size:13px;color:var(--text-secondary);">${n.message}</div>
                </div>
                <div style="font-size:12px;color:var(--text-secondary);text-align:right;">
                  <div>${fn:substring(n.createdAt,0,19)}</div>
                  <div style="margin-top:4px;color:${n.read ? 'var(--text-secondary)' : 'var(--primary)'};">${n.read ? 'Read' : 'Unread'}</div>
                </div>
              </div>
            </c:otherwise>
          </c:choose>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div style="padding:24px;border:1px dashed var(--border);border-radius:10px;background:#fff;color:var(--text-secondary);">No notifications yet.</div>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/components/footer.jsp"/>
