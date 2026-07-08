package com.example.library.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@RestController
@RequestMapping("/api/upload")
@CrossOrigin(origins = "*")
public class UploadController {

    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("png", "jpg", "jpeg", "gif", "webp");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    /**
     * 上传图书封面图片
     */
    @PostMapping("/cover")
    public ResponseEntity<Map<String, Object>> uploadCover(@RequestParam("file") MultipartFile file) {
        Map<String, Object> response = new HashMap<>();

        if (file.isEmpty()) {
            response.put("success", false);
            response.put("message", "文件不能为空");
            return ResponseEntity.badRequest().body(response);
        }

        // 检查文件大小
        if (file.getSize() > MAX_FILE_SIZE) {
            response.put("success", false);
            response.put("message", "文件大小不能超过5MB");
            return ResponseEntity.badRequest().body(response);
        }

        // 检查文件扩展名
        String originalFilename = file.getOriginalFilename();
        String ext = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();
        }
        if (!ALLOWED_EXTENSIONS.contains(ext)) {
            response.put("success", false);
            response.put("message", "不支持的图片格式，仅支持 png/jpg/jpeg/gif/webp");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            // 生成唯一文件名
            String filename = "cover_" + System.currentTimeMillis() + "_" +
                    new Random().nextInt(10000) + "." + ext;
            byte[] bytes = file.getBytes();

            // 保存到两个目录
            Path srcPath = Paths.get("src/main/resources/static/book_covers/", filename);
            Path targetPath = Paths.get("target/classes/static/book_covers/", filename);
            Files.createDirectories(srcPath.getParent());
            Files.createDirectories(targetPath.getParent());
            Files.write(srcPath, bytes);
            Files.write(targetPath, bytes);

            String url = "/book_covers/" + filename;
            response.put("success", true);
            response.put("url", url);
            response.put("message", "上传成功");
            return ResponseEntity.ok(response);

        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "文件上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}