package com.example.library.mapper;

import com.example.library.entity.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {

    User findAdminByUsername(String username);

    User findReaderByUsername(String username);

    User findReaderById(Long id);

    List<User> findAllReaders();

    int insertReader(User user);
    
    int updateReader(User user);
}
