package com.example.library.service;

import com.example.library.entity.User;

public interface UserService {

    /**
     * 登录验证，成功返回用户对象，失败返回 null
     */
    User login(String username, String password);

    /**
     * 注册新用户，用户名已存在返回 false
     */
    boolean register(String username, String password);

    /**
     * 根据用户名查找用户
     */
    User findByUsername(String username);
}
