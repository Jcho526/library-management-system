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
        
        // 1. 先尝试在管理员表中查找
        User admin = userMapper.findAdminByUsername(username.trim());
        if (admin != null && admin.getPassword().equals(password)) {
            admin.setRole("admin");
            return admin;
        }

        // 2. 再尝试在普通读者表中查找
        User reader = userMapper.findReaderByUsername(username.trim());
        if (reader != null && reader.getPassword().equals(password)) {
            reader.setRole("user");
            return reader;
        }

        return null;
    }

    @Override
    public boolean register(String username, String password) {
        if (username == null || username.trim().isEmpty()) return false;
        if (password == null || password.isEmpty()) return false;
        
        // 检查用户名是否已存在于任一表中
        if (userMapper.findAdminByUsername(username.trim()) != null) return false;
        if (userMapper.findReaderByUsername(username.trim()) != null) return false;

        // 注册始终作为普通读者创建
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        return userMapper.insertReader(newUser) > 0;
    }

    @Override
    public User findByUsername(String username) {
        if (username == null) return null;
        User admin = userMapper.findAdminByUsername(username.trim());
        if (admin != null) return admin;
        return userMapper.findReaderByUsername(username.trim());
    }

    @Override
    public User findReaderById(Long id) {
        if (id == null) return null;
        return userMapper.findReaderById(id);
    }

    @Override
    public boolean updateReader(User user) {
        if (user == null || user.getId() == null) return false;
        return userMapper.updateReader(user) > 0;
    }
}
