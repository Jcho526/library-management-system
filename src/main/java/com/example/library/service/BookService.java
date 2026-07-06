package com.example.library.service;

import com.example.library.entity.Book;

import java.util.List;

public interface BookService {

    List<Book> findAll();

    Book findById(Long id);

    List<Book> findByCategoryId(Long categoryId);

    int insert(Book book);

    int update(Book book);

    int deleteById(Long id);
}