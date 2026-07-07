package com.example.library.controller;

import com.example.library.entity.BorrowRecord;
import com.example.library.entity.User;
import com.example.library.service.BorrowRecordService;
import com.example.library.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class UserController {

    private final UserService userService;
    private final BorrowRecordService borrowRecordService;

    @Autowired
    public UserController(UserService userService, BorrowRecordService borrowRecordService) {
        this.userService = userService;
        this.borrowRecordService = borrowRecordService;
    }

    /** 登录接口 */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(
            @RequestBody Map<String, String> credentials,
            HttpSession session) {

        String username = credentials.get("username");
        String password = credentials.get("password");
        Map<String, Object> response = new HashMap<>();

        User user = userService.login(username, password);
        if (user != null) {
            user.setPassword(null);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(3600);
            response.put("success", true);
            response.put("message", "登录成功");
            response.put("username", user.getUsername());
            response.put("role", user.getRole());
            response.put("userId", user.getId());
        } else {
            response.put("success", false);
            response.put("message", "用户名或密码错误");
        }
        return ResponseEntity.ok(response);
    }

    /** 注册接口 */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(
            @RequestBody Map<String, String> userData) {

        String username = userData.get("username");
        String password = userData.get("password");
        Map<String, Object> response = new HashMap<>();

        if (username == null || username.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "用户名不能为空");
            return ResponseEntity.badRequest().body(response);
        }
        if (password == null || password.isEmpty()) {
            response.put("success", false);
            response.put("message", "密码不能为空");
            return ResponseEntity.badRequest().body(response);
        }

        boolean success = userService.register(username, password);
        if (success) {
            response.put("success", true);
            response.put("message", "注册成功，请登录");
        } else {
            response.put("success", false);
            response.put("message", "用户名已存在，请换一个");
        }
        return ResponseEntity.ok(response);
    }

    /** 退出登录 */
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "已退出登录");
        return ResponseEntity.ok(response);
    }

    /** 查询当前登录状态 */
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> status(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        if (user != null) {
            response.put("loggedIn", true);
            response.put("username", user.getUsername());
            response.put("role", user.getRole());
            response.put("userId", user.getId());
        } else {
            response.put("loggedIn", false);
        }
        return ResponseEntity.ok(response);
    }

    /** 读者：获取个人信息 */
    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null) {
            response.put("success", false);
            response.put("message", "未登录");
            return ResponseEntity.status(401).body(response);
        }
        
        // 从数据库获取最新、最全的用户信息
        User fullUser = userService.findReaderById(sessionUser.getId());
        if (fullUser != null) {
            response.put("success", true);
            response.put("id", fullUser.getId());
            response.put("username", fullUser.getUsername());
            response.put("role", fullUser.getRole());
            response.put("realName", fullUser.getRealName());
            response.put("email", fullUser.getEmail());
            response.put("phone", fullUser.getPhone());
            response.put("maxBooks", fullUser.getMaxBooks());
            response.put("status", fullUser.getStatus());
            response.put("gender", fullUser.getGender());
            response.put("createTime", fullUser.getCreateTime());
            return ResponseEntity.ok(response);
        }
        
        response.put("success", false);
        response.put("message", "用户不存在");
        return ResponseEntity.ok(response);
    }

    /** 读者：更新个人信息 */
    @PostMapping("/profile/update")
    public ResponseEntity<Map<String, Object>> updateProfile(@RequestBody User user, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null || !"user".equals(sessionUser.getRole())) {
            response.put("success", false);
            response.put("message", "未登录或非读者身份");
            return ResponseEntity.status(401).body(response);
        }
        
        user.setId(sessionUser.getId()); // 防止越权修改他人信息
        boolean success = userService.updateReader(user);
        response.put("success", success);
        if (success) {
            response.put("message", "更新成功");
        } else {
            response.put("message", "更新失败");
        }
        return ResponseEntity.ok(response);
    }

    /** 读者：上传/更新头像 */
    @PostMapping("/profile/avatar")
    public ResponseEntity<Map<String, Object>> updateAvatar(@RequestParam("file") MultipartFile file, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null || !"user".equals(sessionUser.getRole())) {
            response.put("success", false);
            response.put("message", "未登录或非读者身份");
            return ResponseEntity.status(401).body(response);
        }

        if (file.isEmpty()) {
            response.put("success", false);
            response.put("message", "文件不能为空");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            // 固定扩展名为 .png
            String filename = "custom_avatar_" + sessionUser.getId() + ".png";
            
            // 保存到源代码目录 src/main/resources/static/User_Picture/
            String srcDirPath = "src/main/resources/static/User_Picture/";
            File srcDir = new File(srcDirPath);
            if (!srcDir.exists()) srcDir.mkdirs();
            Path srcFilePath = Paths.get(srcDir.getAbsolutePath(), filename);
            Files.copy(file.getInputStream(), srcFilePath, StandardCopyOption.REPLACE_EXISTING);

            // 同时保存到 target/classes/static/User_Picture/ 以便热更新立即生效
            String targetDirPath = "target/classes/static/User_Picture/";
            File targetDir = new File(targetDirPath);
            if (!targetDir.exists()) targetDir.mkdirs();
            Path targetFilePath = Paths.get(targetDir.getAbsolutePath(), filename);
            Files.copy(file.getInputStream(), targetFilePath, StandardCopyOption.REPLACE_EXISTING);

            response.put("success", true);
            response.put("message", "头像上传成功");
            response.put("avatarUrl", "/User_Picture/" + filename);
            return ResponseEntity.ok(response);

        } catch (IOException e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "头像上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /** 读者：获取自己的借阅记录 */
    @GetMapping("/my-borrows")
    public ResponseEntity<?> getMyBorrows(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "未登录"));
        }
        List<BorrowRecord> records = borrowRecordService.findByUserId(user.getId());
        return ResponseEntity.ok(records);
    }
}
