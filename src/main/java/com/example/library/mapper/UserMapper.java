package com.example.library.mapper;

import com.example.library.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {

    User findByUsername(String username);

    int insert(User user);
}
