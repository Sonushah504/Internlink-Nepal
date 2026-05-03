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

@WebServlet("/oauth/facebook")
public class FacebookOAuthStartServlet extends HttpServlet {

    public static final String SESS_STATE = "oauth_facebook_state";
    public static final String SESS_ROLE   = "oauth_fb_intended_role";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!InternlinkConfig.isFacebookOAuthConfigured()) {
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

        String appId = InternlinkConfig.get("oauth.facebook.appId", "");
        String redirectUri = OAuthUtil.callbackUrl(req, "/oauth/facebook/callback");
        String url = "https://www.facebook.com/v18.0/dialog/oauth"
                + "?client_id=" + enc(appId)
                + "&redirect_uri=" + enc(redirectUri)
                + "&state=" + enc(state)
                + "&scope=" + enc("email,public_profile");
        resp.sendRedirect(url);
    }

    private static String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
