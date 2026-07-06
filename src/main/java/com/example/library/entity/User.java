package com.example.library.entity;

import java.io.Serializable;
import java.time.LocalDateTime;

public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String username;
    private String password;
    private String role;
    private LocalDateTime createTime;

    public User() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}
