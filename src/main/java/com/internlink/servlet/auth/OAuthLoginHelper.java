package com.internlink.servlet.auth;

import com.internlink.dao.StudentProfileDAO;
import com.internlink.model.StudentProfile;
import com.internlink.model.User;
import com.internlink.util.SessionUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

final class OAuthLoginHelper {

    private OAuthLoginHelper() {}

    static void completeLogin(HttpServletRequest req, HttpServletResponse resp, User user, StudentProfileDAO profileDAO) throws IOException {
        if ("STUDENT".equals(user.getRole()) && (user.getProfilePhoto() == null || user.getProfilePhoto().isBlank())) {
            try {
                StudentProfile sp = profileDAO.findByUserId(user.getId());
                if (sp != null && sp.getProfilePhoto() != null && !sp.getProfilePhoto().isBlank()) {
                    user.setProfilePhoto(sp.getProfilePhoto());
                }
            } catch (Exception ignored) {
            }
        }
        SessionUtil.invalidate(req);
        SessionUtil.setUser(req, user);
        LoginServlet.redirectByRoleStatic(req, resp);
    }
}
