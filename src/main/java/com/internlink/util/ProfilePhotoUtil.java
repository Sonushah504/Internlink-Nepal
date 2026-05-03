package com.internlink.util;

import com.internlink.model.User;

public final class ProfilePhotoUtil {
    public static final String DEFAULT_AVATAR_PATH = "assets/images/default-avatar.svg";

    private ProfilePhotoUtil() {}

    public static String getProfilePhotoUrl(User user) {
        return getProfilePhotoUrl(user == null ? null : user.getProfilePhoto());
    }

    public static String getProfilePhotoUrl(String profilePhotoPath) {
        if (profilePhotoPath == null || profilePhotoPath.isBlank()) {
            return DEFAULT_AVATAR_PATH;
        }

        String normalized = profilePhotoPath.trim().replace('\\', '/');
        if (normalized.startsWith("http://") || normalized.startsWith("https://")) {
            return normalized;
        }
        return normalized.startsWith("/") ? normalized.substring(1) : normalized;
    }
}
