package it.util;

import java.security.MessageDigest;
import java.security.SecureRandom;

public class PasswordUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    public static String hash(String password) {
        byte[] saltBytes = new byte[16];
        RANDOM.nextBytes(saltBytes);
        String salt = bytesToHex(saltBytes);
        return salt + ":" + sha256(salt + password);
    }

    public static boolean verify(String password, String stored) {
        if (stored == null || !stored.contains(":")) return false;
        String salt = stored.substring(0, stored.indexOf(':'));
        String expected = stored.substring(stored.indexOf(':') + 1);
        return sha256(salt + password).equals(expected);
    }

    private static String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return bytesToHex(md.digest(input.getBytes("UTF-8")));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}
