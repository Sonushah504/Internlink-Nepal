package com.internlink.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class StorageUtil {
    private static final String BASE = System.getProperty("internlink.data.dir", System.getProperty("user.home") + "/.internlink");

    public static Path ensureDataDir() throws IOException {
        Path p = Paths.get(BASE, "data");
        if (!Files.exists(p)) Files.createDirectories(p);
        return p;
    }

    public static Path ensureUploadsDir(String sub) throws IOException {
        Path p = Paths.get(BASE, "uploads", sub);
        if (!Files.exists(p)) Files.createDirectories(p);
        return p;
    }

    public static Path dataFile(String name) throws IOException {
        Path dir = ensureDataDir();
        return dir.resolve(name);
    }

    public static Path uploadsPath(String sub, String filename) throws IOException {
        Path dir = ensureUploadsDir(sub);
        return dir.resolve(filename);
    }

    public static String webPath(String sub, String filename) {
        // The app serves uploads from a relative path "uploads/..." — ensure code stores consistent path
        return "uploads/" + sub + "/" + filename;
    }
}
