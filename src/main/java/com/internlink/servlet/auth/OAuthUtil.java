package com.internlink.servlet.auth;

import jakarta.servlet.http.HttpServletRequest;

final class OAuthUtil {

    private OAuthUtil() {}

    /**
     * Absolute redirect URI registered with Google/Facebook. Uses {@code X-Forwarded-*} when behind a reverse proxy.
     */
    static String callbackUrl(HttpServletRequest req, String pathFromContext) {
        String scheme = firstNonBlank(req.getHeader("X-Forwarded-Proto"), req.getScheme());
        String hostPort = firstNonBlank(req.getHeader("X-Forwarded-Host"), null);

        String host;
        int port;
        if (hostPort != null && hostPort.contains(":")) {
            int colon = hostPort.lastIndexOf(':');
            host = hostPort.substring(0, colon).trim();
            try {
                port = Integer.parseInt(hostPort.substring(colon + 1).trim());
            } catch (NumberFormatException e) {
                port = req.getServerPort();
            }
        } else if (hostPort != null && !hostPort.isBlank()) {
            host = hostPort.trim();
            String fwdPort = req.getHeader("X-Forwarded-Port");
            if (fwdPort != null && !fwdPort.isBlank()) {
                try {
                    port = Integer.parseInt(fwdPort.trim());
                } catch (NumberFormatException e) {
                    port = req.getServerPort();
                }
            } else {
                port = req.getServerPort();
            }
        } else {
            host = req.getServerName();
            port = req.getServerPort();
        }

        String ctx = req.getContextPath();
        String base = scheme + "://" + host;
        boolean defaultHttp = "http".equalsIgnoreCase(scheme) && port == 80;
        boolean defaultHttps = "https".equalsIgnoreCase(scheme) && port == 443;
        if (!defaultHttp && !defaultHttps) {
            base += ":" + port;
        }
        return base + ctx + pathFromContext;
    }

    private static String firstNonBlank(String a, String b) {
        if (a != null && !a.isBlank()) {
            return a.trim();
        }
        return b;
    }
}
