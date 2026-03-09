package org.dromara.secure.util;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.CipherOutputStream;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;

/**
 * 流式 AES 加解密工具类
 * 支持大文件流式处理，使用缓冲区避免 OOM
 *
 * @author ruoyi
 */
public final class AesStreamUtil {

    private static final String ALGORITHM = "AES/CBC/PKCS5Padding";
    private static final int IV_LENGTH = 16;
    private static final int BUFFER_SIZE = 8192;

    /**
     * 硬编码的 16 位 AES 密钥（生产环境应使用配置或密钥管理服务）
     */
    public static final String SECRET_KEY = "MySecretKey12345";

    private AesStreamUtil() {
    }

    /**
     * 将 InputStream 加密后写入 OutputStream
     * 流式处理，使用缓冲区，不会一次性加载到内存
     *
     * @param inputStream  原始数据输入流
     * @param outputStream 加密后数据输出流
     * @throws IOException 加解密异常
     */
    public static void encrypt(InputStream inputStream, OutputStream outputStream) throws IOException {
        byte[] keyBytes = SECRET_KEY.getBytes(StandardCharsets.UTF_8);
        SecretKeySpec secretKeySpec = new SecretKeySpec(keyBytes, "AES");

        byte[] iv = new byte[IV_LENGTH];
        SecureRandom random = new SecureRandom();
        random.nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);

        try {
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivSpec);

            outputStream.write(iv);

            try (CipherOutputStream cos = new CipherOutputStream(outputStream, cipher)) {
                byte[] buffer = new byte[BUFFER_SIZE];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    cos.write(buffer, 0, bytesRead);
                }
            }
        } catch (Exception e) {
            throw new IOException("AES 加密失败: " + e.getMessage(), e);
        }
    }

    /**
     * 将 InputStream（加密数据）解密后写入 OutputStream
     * 流式处理，使用缓冲区，不会一次性加载到内存
     *
     * @param inputStream  加密数据输入流
     * @param outputStream 解密后数据输出流
     * @throws IOException 加解密异常
     */
    public static void decrypt(InputStream inputStream, OutputStream outputStream) throws IOException {
        byte[] keyBytes = SECRET_KEY.getBytes(StandardCharsets.UTF_8);
        SecretKeySpec secretKeySpec = new SecretKeySpec(keyBytes, "AES");

        byte[] iv = new byte[IV_LENGTH];
        int ivRead = inputStream.read(iv);
        if (ivRead != IV_LENGTH) {
            throw new IOException("读取 IV 失败，数据可能已损坏");
        }
        IvParameterSpec ivSpec = new IvParameterSpec(iv);

        try {
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivSpec);

            try (CipherInputStream cis = new CipherInputStream(inputStream, cipher)) {
                byte[] buffer = new byte[BUFFER_SIZE];
                int bytesRead;
                while ((bytesRead = cis.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } catch (Exception e) {
            throw new IOException("AES 解密失败: " + e.getMessage(), e);
        }
    }

}
