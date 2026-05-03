package com.internlink.servlet.auth;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.internlink.dao.StudentProfileDAO;
import com.internlink.dao.UserDAO;
import com.internlink.model.StudentProfile;
import com.internlink.model.User;
import com.internlink.util.InternlinkConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

@WebServlet("/oauth/facebook/callback")
public class FacebookOAuthCallbackServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final StudentProfileDAO profileDAO = new StudentProfileDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String err = req.getParameter("error");
        if (err != null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=oauth_denied");
            return;
        }
        String state = req.getParameter("state");
        String code = req.getParameter("code");
        Object expected = req.getSession().getAttribute(FacebookOAuthStartServlet.SESS_STATE);
        req.getSession().removeAttribute(FacebookOAuthStartServlet.SESS_STATE);
        if (state == null || expected == null || !state.equals(expected)) {
            resp.sendRedirect(req.getContextPath() + "/login?error=oauth_state");
            return;
        }
        if (code == null || code.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=oauth_code");
            return;
        }

        try {
            String appId = InternlinkConfig.get("oauth.facebook.appId", "");
            String secret = InternlinkConfig.get("oauth.facebook.appSecret", "");
            String redirectUri = OAuthUtil.callbackUrl(req, "/oauth/facebook/callback");
            String tokenUrl = "https://graph.facebook.com/v18.0/oauth/access_token"
                    + "?client_id=" + enc(appId)
                    + "&redirect_uri=" + enc(redirectUri)
                    + "&client_secret=" + enc(secret)
                    + "&code=" + enc(code);
            String tokenJson = httpGetPlain(tokenUrl);
            JsonObject tokenObj = JsonParser.parseString(tokenJson).getAsJsonObject();
            if (!tokenObj.has("access_token")) {
                resp.sendRedirect(req.getContextPath() + "/login?error=oauth_token");
                return;
            }
            String accessToken = tokenObj.get("access_token").getAsString();

            String meUrl = "https://graph.facebook.com/me?fields=name,email,picture.type(large)"
                    + "&access_token=" + URLEncoder.encode(accessToken, StandardCharsets.UTF_8);
            String meJson = httpGetPlain(meUrl);
            JsonObject u = JsonParser.parseString(meJson).getAsJsonObject();
            String email = u.has("email") && !u.get("email").isJsonNull() ? u.get("email").getAsString() : null;
            String name = u.has("name") && !u.get("name").isJsonNull() ? u.get("name").getAsString() : null;

            if (email == null || email.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/login?error=oauth_fb_email");
                return;
            }
            email = email.trim().toLowerCase();

            User existing = userDAO.findByEmail(email);
            if (existing != null) {
                if (!"FACEBOOK".equals(existing.getAuthProvider())) {
                    resp.sendRedirect(req.getContextPath() + "/login?error=oauth_existing_other");
                    return;
                }
                OAuthLoginHelper.completeLogin(req, resp, existing, profileDAO);
                return;
            }

            String intendedRole = (String) req.getSession().getAttribute(FacebookOAuthStartServlet.SESS_ROLE);
            req.getSession().removeAttribute(FacebookOAuthStartServlet.SESS_ROLE);
            if (intendedRole == null || intendedRole.isBlank()) {
                intendedRole = "STUDENT";
            }
            if (!"STUDENT".equals(intendedRole)) {
                resp.sendRedirect(req.getContextPath() + "/login?error=oauth_student_only");
                return;
            }

            int userId = userDAO.createOAuthUser(email, "STUDENT", "FACEBOOK", null);
            if (userId < 0) {
                resp.sendRedirect(req.getContextPath() + "/login?error=oauth_create");
                return;
            }

            StudentProfile sp = new StudentProfile();
            sp.setUserId(userId);
            sp.setFullName(name != null && !name.isBlank() ? name : email.substring(0, email.indexOf('@')));
            sp.setSemester(0);
            sp.setCgpa(0);
            sp.setExperienceType("FRESHER");
            sp.setProfileScore(0);
            profileDAO.create(sp);

            User created = userDAO.findById(userId);
            OAuthLoginHelper.completeLogin(req, resp, created, profileDAO);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private static String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }

    private static String httpGetPlain(String url) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newBuilder().build();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }
}
