package com.example.library.service.impl;

import com.example.library.entity.Category;
import com.example.library.mapper.CategoryMapper;
import com.example.library.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryMapper categoryMapper;

    @Autowired
    public CategoryServiceImpl(CategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    @Override
    public List<Category> findAll() {
        return categoryMapper.findAll();
    }

    @Override
    public Category findById(Long id) {
        return categoryMapper.findById(id);
    }
}
