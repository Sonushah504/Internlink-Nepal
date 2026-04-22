package com.internlink.filter;

import com.internlink.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/student/*", "/company/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getServletPath();
        String role = SessionUtil.getRole(req);

        if (role == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        boolean allowed =
            (path.startsWith("/student/") && "STUDENT".equals(role)) ||
            (path.startsWith("/company/") && "COMPANY".equals(role)) ||
            (path.startsWith("/admin/")   && "ADMIN".equals(role));

        if (!allowed) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
