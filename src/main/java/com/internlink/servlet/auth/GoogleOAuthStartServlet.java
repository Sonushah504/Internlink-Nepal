package com.internlink.servlet.auth;

import com.internlink.util.InternlinkConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@WebServlet("/oauth/google")
public class GoogleOAuthStartServlet extends HttpServlet {

    public static final String SESS_STATE = "oauth_google_state";
    public static final String SESS_ROLE   = "oauth_intended_role";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!InternlinkConfig.isGoogleOAuthConfigured()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String state = UUID.randomUUID().toString();
        req.getSession().setAttribute(SESS_STATE, state);
        String role = req.getParameter("role");
        if (role == null || role.isBlank()) {
            role = "STUDENT";
        }
        req.getSession().setAttribute(SESS_ROLE, role.trim().toUpperCase());

        String clientId = InternlinkConfig.get("oauth.google.clientId", "");
        String redirectUri = OAuthUtil.callbackUrl(req, "/oauth/google/callback");
        String url = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + enc(clientId)
                + "&redirect_uri=" + enc(redirectUri)
                + "&response_type=code"
                + "&scope=" + enc("openid email profile")
                + "&state=" + enc(state)
                + "&access_type=online"
                + "&prompt=select_account";
        resp.sendRedirect(url);
    }

    private static String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
