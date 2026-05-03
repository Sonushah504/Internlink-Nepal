package com.internlink.util;

public final class CompanyLogoUtil {
    public static final String DEFAULT_LOGO_PATH = "assets/images/default-company-logo.svg";

    private CompanyLogoUtil() {}

    public static String getLogoUrl(String logoPath) {
        if (logoPath == null || logoPath.isBlank()) {
            return DEFAULT_LOGO_PATH;
        }
        String normalized = logoPath.trim().replace('\\', '/');
        return normalized.startsWith("/") ? normalized.substring(1) : normalized;
    }
}
