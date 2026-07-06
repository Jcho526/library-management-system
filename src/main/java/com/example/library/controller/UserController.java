package com.example.library.controller;

import com.example.library.entity.User;
import com.example.library.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * 登录接口
     */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(
            @RequestBody Map<String, String> credentials,
            HttpSession session) {

        String username = credentials.get("username");
        String password = credentials.get("password");
        Map<String, Object> response = new HashMap<>();

        User user = userService.login(username, password);
        if (user != null) {
            // 将用户信息存入 Session（密码脱敏）
            user.setPassword(null);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(3600); // 1小时过期
            response.put("success", true);
            response.put("message", "登录成功");
            response.put("username", user.getUsername());
            response.put("role", user.getRole());
        } else {
            response.put("success", false);
            response.put("message", "用户名或密码错误");
        }
        return ResponseEntity.ok(response);
    }

    /**
     * 注册接口
     */
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

    /**
     * 退出登录
     */
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "已退出登录");
        return ResponseEntity.ok(response);
    }

    /**
     * 查询当前登录状态
     */
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> status(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        if (user != null) {
            response.put("loggedIn", true);
            response.put("username", user.getUsername());
            response.put("role", user.getRole());
        } else {
            response.put("loggedIn", false);
        }
        return ResponseEntity.ok(response);
    }
}
