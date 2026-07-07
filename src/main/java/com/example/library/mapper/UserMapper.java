package com.example.library.mapper;

import com.example.library.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {

    User findAdminByUsername(String username);

    User findReaderByUsername(String username);

    User findReaderById(Long id);

    int insertReader(User user);
    
    int updateReader(User user);
}
