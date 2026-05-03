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

@WebServlet("/oauth/google/callback")
public class GoogleOAuthCallbackServlet extends HttpServlet {

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
        Object expected = req.getSession().getAttribute(GoogleOAuthStartServlet.SESS_STATE);
        req.getSession().removeAttribute(GoogleOAuthStartServlet.SESS_STATE);
        if (state == null || expected == null || !state.equals(expected)) {
            resp.sendRedirect(req.getContextPath() + "/login?error=oauth_state");
            return;
        }
        if (code == null || code.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=oauth_code");
            return;
        }

        try {
            String redirectUri = OAuthUtil.callbackUrl(req, "/oauth/google/callback");
            String tokenJson = postForm("https://oauth2.googleapis.com/token",
                    "code=" + enc(code)
                            + "&client_id=" + enc(InternlinkConfig.get("oauth.google.clientId", ""))
                            + "&client_secret=" + enc(InternlinkConfig.get("oauth.google.clientSecret", ""))
                            + "&redirect_uri=" + enc(redirectUri)
                            + "&grant_type=authorization_code");
            JsonObject tokenObj = JsonParser.parseString(tokenJson).getAsJsonObject();
            if (!tokenObj.has("access_token")) {
                resp.sendRedirect(req.getContextPath() + "/login?error=oauth_token");
                return;
            }
            String accessToken = tokenObj.get("access_token").getAsString();

            String userJson = httpGet("https://www.googleapis.com/oauth2/v2/userinfo",
                    accessToken);
            JsonObject u = JsonParser.parseString(userJson).getAsJsonObject();
            String email = u.has("email") ? u.get("email").getAsString() : null;
            String name = u.has("name") ? u.get("name").getAsString() : null;

            if (email == null || email.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/login?error=oauth_email");
                return;
            }
            email = email.trim().toLowerCase();

            User existing = userDAO.findByEmail(email);
            if (existing != null) {
                if (!"GOOGLE".equals(existing.getAuthProvider())) {
                    resp.sendRedirect(req.getContextPath() + "/login?error=oauth_existing_other");
                    return;
                }
                finishLogin(req, resp, existing);
                return;
            }

            String intendedRole = (String) req.getSession().getAttribute(GoogleOAuthStartServlet.SESS_ROLE);
            req.getSession().removeAttribute(GoogleOAuthStartServlet.SESS_ROLE);
            if (intendedRole == null || intendedRole.isBlank()) {
                intendedRole = "STUDENT";
            }
            if (!"STUDENT".equals(intendedRole)) {
                resp.sendRedirect(req.getContextPath() + "/login?error=oauth_student_only");
                return;
            }

            int userId = userDAO.createOAuthUser(email, "STUDENT", "GOOGLE", null);
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

    private void finishLogin(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        OAuthLoginHelper.completeLogin(req, resp, user, profileDAO);
    }

    private static String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }

    private static String postForm(String url, String body) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newBuilder().build();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }

    private static String httpGet(String url, String bearer) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newBuilder().build();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Authorization", "Bearer " + bearer)
                .GET()
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }
}
