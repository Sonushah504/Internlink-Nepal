package com.internlink.util;

import org.mindrot.jbcrypt.BCrypt;


public class PasswordUtil {

    private static final int SALT_ROUNDS = 12;

    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(SALT_ROUNDS));
    }

    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
