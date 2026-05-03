package com.internlink.util;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;


public final class InternlinkConfig {

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = InternlinkConfig.class.getClassLoader().getResourceAsStream("internlink.properties")) {
            if (in != null) {
                PROPS.load(in);
            }
        } catch (IOException ignored) {
        }
        loadTomcatConfOverrides();
    }

    /**
     * Loads optional {@code conf/internlink.properties} from CATALINA_BASE / CATALINA_HOME so OAuth and SMTP
     * can be configured without rebuilding the WAR (same pattern as Tomcat's context XML).
     */
    private static void loadTomcatConfOverrides() {
        String[] bases = {
                System.getenv("CATALINA_BASE"),
                System.getenv("CATALINA_HOME")
        };
        for (String base : bases) {
            if (base == null || base.isBlank()) {
                continue;
            }
            Path p = Paths.get(base, "conf", "internlink.properties");
            if (Files.isReadable(p)) {
                try (InputStream in = Files.newInputStream(p)) {
                    PROPS.load(in);
                } catch (IOException ignored) {
                }
            }
        }
    }

    private InternlinkConfig() {}

    /**
     * Property value with optional environment override (for OAuth / deployment without editing the JAR).
     */
    public static String get(String key, String defaultValue) {
        String env = getenvForKey(key);
        if (env != null && !env.isBlank()) {
            return env.trim();
        }
        String v = PROPS.getProperty(key);
        if (v != null && !v.isBlank()) {
            return v.trim();
        }
        return defaultValue == null ? "" : defaultValue.trim();
    }

    private static String getenvForKey(String key) {
        return switch (key) {
            case "oauth.google.clientId" -> firstNonBlank(
                    System.getenv("INTERNLINK_OAUTH_GOOGLE_CLIENT_ID"),
                    System.getenv("GOOGLE_OAUTH_CLIENT_ID"),
                    System.getenv("GOOGLE_CLIENT_ID"));
            case "oauth.google.clientSecret" -> firstNonBlank(
                    System.getenv("INTERNLINK_OAUTH_GOOGLE_CLIENT_SECRET"),
                    System.getenv("GOOGLE_OAUTH_CLIENT_SECRET"),
                    System.getenv("GOOGLE_CLIENT_SECRET"));
            case "oauth.facebook.appId" -> firstNonBlank(
                    System.getenv("INTERNLINK_OAUTH_FACEBOOK_APP_ID"),
                    System.getenv("FACEBOOK_APP_ID"),
                    System.getenv("FACEBOOK_CLIENT_ID"));
            case "oauth.facebook.appSecret" -> firstNonBlank(
                    System.getenv("INTERNLINK_OAUTH_FACEBOOK_APP_SECRET"),
                    System.getenv("FACEBOOK_APP_SECRET"),
                    System.getenv("FACEBOOK_CLIENT_SECRET"));
            default -> null;
        };
    }

    private static String firstNonBlank(String... vals) {
        if (vals == null) {
            return null;
        }
        for (String v : vals) {
            if (v != null && !v.isBlank()) {
                return v.trim();
            }
        }
        return null;
    }

    public static boolean isMailConfigured() {
        String host = PROPS.getProperty("mail.smtp.host", "").trim();
        if (!host.isEmpty()) {
            return true;
        }
        String envHost = System.getenv("INTERNLINK_MAIL_SMTP_HOST");
        return envHost != null && !envHost.isBlank();
    }

    public static boolean isGoogleOAuthConfigured() {
        return !get("oauth.google.clientId", "").isEmpty() && !get("oauth.google.clientSecret", "").isEmpty();
    }

    public static boolean isFacebookOAuthConfigured() {
        return !get("oauth.facebook.appId", "").isEmpty() && !get("oauth.facebook.appSecret", "").isEmpty();
    }
}
