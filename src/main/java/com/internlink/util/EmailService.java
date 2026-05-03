package com.internlink.util;

import jakarta.mail.Message;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;


public final class EmailService {

    private static final String COMPANY_NAME = "InternLink Nepal";

    private EmailService() {}

    public static void sendPasswordResetOtp(String toEmail, String otpCode, String deliveryNote) throws Exception {
        if (!InternlinkConfig.isMailConfigured()) {
            throw new IllegalStateException("Email is not configured. Set mail.smtp.* in internlink.properties.");
        }

        String host = InternlinkConfig.get("mail.smtp.host", "");
        String port = InternlinkConfig.get("mail.smtp.port", "587");
        String user = InternlinkConfig.get("mail.smtp.username", "");
        String pass = InternlinkConfig.get("mail.smtp.password", "");
        boolean startTls = Boolean.parseBoolean(InternlinkConfig.get("mail.smtp.starttls", "true"));
        boolean auth = Boolean.parseBoolean(InternlinkConfig.get("mail.smtp.auth", "true"));

        String fromAddr = InternlinkConfig.get("mail.from.address", "noreply@internlink.com.np");
        String fromName = InternlinkConfig.get("mail.from.name", COMPANY_NAME);

        Properties p = new Properties();
        p.put("mail.smtp.host", host);
        p.put("mail.smtp.port", port);
        p.put("mail.smtp.auth", String.valueOf(auth));
        if (startTls) {
            p.put("mail.smtp.starttls.enable", "true");
        }

        Session session = Session.getInstance(p, auth ? new jakarta.mail.Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(user, pass);
            }
        } : null);

        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(fromAddr, fromName, "UTF-8"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
        msg.setSubject(COMPANY_NAME + " — Password reset verification code", "UTF-8");

        String html = """
            <!DOCTYPE html><html><head><meta charset="UTF-8"></head><body style="font-family:Segoe UI,Roboto,Helvetica,Arial,sans-serif;line-height:1.6;color:#1a1a1a;background:#f6f8fb;padding:24px;">
            <table role="presentation" width="100%%" cellspacing="0" cellpadding="0"><tr><td align="center">
            <table role="presentation" width="560" cellspacing="0" cellpadding="0" style="background:#ffffff;border-radius:12px;border:1px solid #e5e7eb;padding:32px;">
            <tr><td>
            <p style="margin:0 0 12px;font-size:14px;color:#64748b;">%s</p>
            <p style="margin:0 0 20px;font-size:15px;">Use this one-time code to set a new password. It expires in 15 minutes.</p>
            <p style="margin:0 0 24px;font-size:28px;font-weight:700;letter-spacing:8px;color:#185FA5;">%s</p>
            <p style="margin:0;font-size:13px;color:#94a3b8;">If you did not request this, you can ignore this email.</p>
            </td></tr></table>
            <p style="margin:24px 0 0;font-size:12px;color:#94a3b8;">—<br><strong>%s</strong><br>Connecting students with verified opportunities in Nepal.</p>
            </td></tr></table></body></html>
            """.formatted(escapeHtml(deliveryNote), escapeHtml(otpCode), escapeHtml(COMPANY_NAME));

        msg.setContent(html, "text/html; charset=UTF-8");

        try (Transport transport = session.getTransport("smtp")) {
            if (auth && user != null && !user.isEmpty()) {
                transport.connect(host, Integer.parseInt(port), user, pass);
            } else {
                transport.connect();
            }
            transport.sendMessage(msg, msg.getAllRecipients());
        }
    }

    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
}
