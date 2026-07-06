package com.example.library.service.impl;

import com.example.library.entity.Book;
import com.example.library.mapper.BookMapper;
import com.example.library.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookServiceImpl implements BookService {

    private final BookMapper bookMapper;

    @Autowired
    public BookServiceImpl(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    @Override
    public List<Book> findAll() {
        return bookMapper.findAll();
    }

    @Override
    public Book findById(Long id) {
        return bookMapper.findById(id);
    }

    @Override
    public List<Book> findByCategoryId(Long categoryId) {
        return bookMapper.findByCategoryId(categoryId);
    }

    @Override
    public int insert(Book book) {
        return bookMapper.insert(book);
    }

    @Override
    public int update(Book book) {
        return bookMapper.update(book);
    }

    @Override
    public int deleteById(Long id) {
        return bookMapper.deleteById(id);
    }
}