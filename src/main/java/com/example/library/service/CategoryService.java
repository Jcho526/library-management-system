package com.example.library.service;

import com.example.library.entity.Category;

import java.util.List;

public interface CategoryService {

    List<Category> findAll();

    Category findById(Long id);
}
