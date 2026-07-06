package com.example.library.mapper;

import com.example.library.entity.Book;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BookMapper {

    List<Book> findAll();

    Book findById(Long id);

    List<Book> findByCategoryId(@Param("categoryId") Long categoryId);

    int insert(Book book);

    int update(Book book);

    int deleteById(Long id);
}