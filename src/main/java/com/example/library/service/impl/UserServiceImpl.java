package com.example.library.service.impl;

import com.example.library.entity.User;
import com.example.library.mapper.UserMapper;
import com.example.library.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;

    @Autowired
    public UserServiceImpl(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public User login(String username, String password) {
        if (username == null || password == null) return null;
        User user = userMapper.findByUsername(username.trim());
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    @Override
    public boolean register(String username, String password) {
        if (username == null || username.trim().isEmpty()) return false;
        if (password == null || password.isEmpty()) return false;
        // 检查用户名是否已存在
        User existing = userMapper.findByUsername(username.trim());
        if (existing != null) return false;
        // 创建新用户
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        newUser.setRole("user");
        return userMapper.insert(newUser) > 0;
    }

    @Override
    public User findByUsername(String username) {
        if (username == null) return null;
        return userMapper.findByUsername(username.trim());
    }
}
